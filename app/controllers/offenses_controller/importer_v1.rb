# frozen_string_literal: false

require 'csv'
class OffensesController
  # class for importing .xlsx and .cxv files
  # written to import the first version of the spreadsheet files we received
  class ImporterV1
    # the function so you can call Importer.new file and the import just goes
    def initialize(file = nil, initial_values = [0, 0, {}])
      @file = file
      @row_total, @success_count, @errors = initial_values

      # 8 lines
      @attrs = {
        name: { header: 'DEFENDANT_NAME' }, sex: { header: 'DEFENDANT_SEX' },
        ftp: { header: 'FTP_RELIEF' }, date: { header: 'DISPOSITION_DATE' },
        group: { header: 'GRP_ID' }, addr: { header: 'DEFENDANT_ADDRESS' },
        city: { header: 'DEFENDANT_CITY' }, race: { header: 'DEFENDANT_RACE' },
        dob: { header: 'DEFENDANT_BIRTHDATE' }, num: { header: 'CASE_NUMBER' },
        text: { header: 'CONVICTED_OFFENSE_TEXT' }, amount: { header: 'AMOUNT' }
      }

      # 7 lines
      # @attrs = {
      #   dob: 'DEFENDANT_BIRTHDATE', date: 'DISPOSITION_DATE',ftp:'FTP_RELIEF',
      #   addr: 'DEFENDANT_ADDRESS', name: 'DEFENDANT_NAME',sex:'DEFENDANT_SEX',
      #   city: 'DEFENDANT_CITY', race: 'DEFENDANT_RACE', num: 'CASE_NUMBER',
      #   text: 'CONVICTED_OFFENSE_TEXT', group: 'GRP_ID', amount: 'AMOUNT'
      # }
      # @attrs.each { |k, v| @attrs[k] = { header: v } }

      # 6 lines
      # attrs = %w[name sex ftp date group addr city race num dob text amount]
      # keys = %w[DEFENDANT_NAME DEFENDANT_SEX FTP_RELIEF DISPOSITION_DATE
      #           GRP_ID DEFENDANT_ADDRESS DEFENDANT_CITY DEFENDANT_RACE
      #           CASE_NUMBER DEFENDANT_BIRTHDATE CONVICTED_OFFENSE_TEXT AMOUNT]
      # @attrs = {}
      # attrs.each_with_index { |k, i| @attrs[k] = { header: keys[i] } }
    end

    # the function that loads the file and prints time lapse results
    def begin_import
      @start_time = Time.now

      rows = load_file

      @load_time = Time.now

      import_rows rows

      @stop_time = Time.now

      print_results
    end

    # use different gems to load file based on file type
    def load_file
      # load as csv file
      if csv? then CSV.read @file.path, headers: true
      elsif xls?
        # load as xls file
      elsif xlsx?
        # load as xlsx file
        workbook = Creek::Book.new @file.path
        workbook.sheets.first.simple_rows
      end
    end

    def csv?
      @file.content_type == 'text/csv'
    end

    def xls?
      @file.content_type == 'application/vnd.ms-excel'
    end

    def xlsx?
      @file.content_type == 'application/vnd.openxmlformats-officedocument.spr'\
      'eadsheetml.sheet'
    end

    def import_rows(rows)
      # handle key setting
      get_keys rows.first

      rows.each_with_index do |row, i|
        next if i.zero? && xlsx?

        data = get_data row

        offense = Offense.create data

        offense.errors.any? ? add_error(offense, data, i) : @success_count += 1

        @row_total += 1
      end
    end

    def get_keys(row)
      # the first row has all the names, we have to find the key associated with
      # that name, so that we can find the values of that column in all future
      # rows
      if xlsx?
        @attrs.each do |_attr, hash|
          hash[:key] = row.key hash[:header]
        end
      end

      @attrs.each do |attr, hash|
        instance_variable_set "@#{attr}", csv? ? hash[:header] : hash[:key]
      end
    end

    def get_data(row)
      # if case is FTA, then status is approved
      ftp_value = row[@ftp]
      fta = ftp_value == '0'
      status = fta ? 'approved' : 'pending'

      # return hash of data to import
      {
        name: row[@name], dob: row[@dob],
        ftp: ftp_value, disposition_date: row[@date],
        group: row[@group], street_address: row[@addr], city: row[@city],
        race: row[@race], sex: row[@sex], case_number: row[@num],
        description: row[@text], status: status, relief_amount: row[@amount]
      }
    end

    def add_error(offense, data, index)
      # if there were any errors, log it
      error = offense.errors.to_a.join('. ')
      @errors[index + 1] = { name: data[:name], error: error }
    end

    def print_results
      sleep 2
      puts "#{@row_total} TOTAL ROWS"
      puts "#{@success_count} SUCCESSFUL ROWS"
      puts "#{@errors.count} ERRORS"
      puts "#{((@success_count / @row_total.to_f) * 100).round 3}% SUCCESS RATE"
      print 'ERRORS: '
      pp @errors

      timer 'LOAD TIME', @start_time, @load_time
      timer 'LOOP TIME', @load_time, @stop_time
      timer 'TOTAL TIME', @start_time, @stop_time
    end

    # function for printing time
    def timer(msg, start, stop, round = 2)
      # elapsed_time = Time.at(time).utc.strftime '%H:%M:%S'
      time = stop - start
      # 1 hour is 60 seconds * 60 minutes = 60 * 60 = 3600
      hours = (time / 3600).to_i
      minutes = (time % 3600 / 60).to_i
      seconds = (time % 60).round round
      elapsed_time = ''
      elapsed_time << "#{hours}h" if hours.positive?
      elapsed_time << "#{minutes}m" if minutes.positive?
      elapsed_time << "#{seconds}s"

      puts "#{msg}: #{elapsed_time}"
    end
  end
end

# use creek or simple_xlsx_reader gem to read file
# file is 65,535 rows long in Numbers application
# Creek says there are 94,850 rows
# LOAD FILE TIME: 10.57 seconds
# LOOP TIME: 121.78 seconds
# TOTAL TIME: 132.34 seconds
# def counter(interval = 1, klass = Offense)
#   residuals = []
#   old_count = klass.count
#   sleep interval
#   loop do
#     new_count = klass.count
#     break if old_count == new_count
#     residual = new_count - old_count
#     residuals << residual
#     puts "#{new_count} (+#{residual})"
#     old_count = new_count
#     sleep interval
#   end
#   puts "MINIMUM RESIDUAL: #{residuals.min}"
#   puts "MAXIMUM RESIDUAL: #{residuals.max}"
#   puts "AVERAGE RESIDUAL: #{(residuals.sum / residuals.size.to_f).round 1}"
# end
# VERSION 1 DATA IMPORT RESULTS
# 94850 TOTAL ROWS
# 94849 SUCCESSFUL ROWS
# 0 ERRORS
# 100.0% SUCCESS RATE
# LOAD TIME: 10.29s
# LOOP TIME: 11m50.79s
# TOTAL TIME: 12m1.08s
# { GROUPS
#   "1"=>423, "2"=>442, "3"=>476, "4"=>391, "5"=>462, "6"=>453, "7"=>419,
#   "8"=>440, "9"=>456, "10"=>426, "11"=>439, "12"=>434, "13"=>449, "14"=>438,
#   "15"=>436, "16"=>440, "17"=>426, "18"=>406, "19"=>412, "20"=>447, "21"=>421,
#   "22"=>443, "23"=>417, "24"=>454, "25"=>446, "26"=>409, "27"=>471, "28"=>441,
#   "29"=>439, "30"=>449, "31"=>446, "32"=>433, "33"=>467, "34"=>469, "35"=>448,
#   "36"=>423, "37"=>471, "38"=>460, "39"=>375, "40"=>453, "41"=>402, "42"=>419,
#   "43"=>449, "44"=>419, "45"=>439, "46"=>408, "47"=>447, "48"=>430, "49"=>447,
#   "50"=>454, "51"=>447, "52"=>417, "NA"=>72121
# }
# statuses
# { "approved"=>72121, "pending"=>22728 }
# case type
# { "FTA"=>72121, "FTP"=>22728 }
# VERSION 2 DATA IMPORT RESULTS (csv version)
# 86863 TOTAL ROWS
# 86863 SUCCESSFUL ROWS
# 0 ERRORS
# 100.0% SUCCESS RATE
# ERRORS: {}
# LOAD TIME: 5.66s
# LOOP TIME: 11m59.02s
# TOTAL TIME: 12m4.68s
# { GROUPS
#   "1"=>275, "2"=>285, "3"=>305, "4"=>262, "5"=>309, "6"=>295, "7"=>289,
#   "8"=>295, "9"=>300, "10"=>287, "11"=>279, "12"=>288, "13"=>298, "14"=>296,
#   "15"=>287, "16"=>292, "17"=>286, "18"=>276, "19"=>275, "20"=>295, "21"=>279,
#   "22"=>292, "23"=>276, "24"=>306, "25"=>284, "26"=>271, "27"=>311, "28"=>298,
#   "29"=>297, "30"=>296, "31"=>300, "32"=>293, "33"=>301, "34"=>308, "35"=>285,
#   "36"=>278, "37"=>315, "38"=>307, "39"=>258, "40"=>285, "41"=>269, "42"=>283,
#   "43"=>306, "44"=>283, "45"=>290, "46"=>272, "47"=>292, "48"=>276, "49"=>300,
#   "50"=>298, "51"=>301, "52"=>288, "NA"=>71791
# }
# STATUSES
# { "pending" => 86863 }
# CASE TYPE
# {"FTA"=>86863}
