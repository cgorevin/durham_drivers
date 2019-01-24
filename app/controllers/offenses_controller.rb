class OffensesController < ApplicationController
  before_action :authenticate_admin!, :except => [:index]

  def index
  end

  def show
    @offense = Offense.find(params[:id])
    @contacts = @offense.contacts
    @contact = @contacts.first
    # @contact = Contact.all
  end

  def new
    @offense = Offense.new
  end

  # use creek or simple_xlsx_reader gem to read file
  # file is 65,535 rows long in Numbers application
  # Creek says there are 94,850 rows
  # LOAD FILE TIME: 10.57 seconds
  # LOOP TIME: 121.78 seconds
  # TOTAL TIME: 132.34 seconds
  # NOTE: ACTUAL IMPORT RESULTS
  # 94850 TOTAL ROWS
  # 94849 SUCCESSFUL ROWS
  # 0 ERRORS
  # 100.0% SUCCESS RATE
  # LOAD TIME: 10.29s
  # LOOP TIME: 11m50.79s
  # TOTAL TIME: 12m1.08s
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
  # {"pending"=>22728, "approved"=>72121}

  def create
    file = params[:offense][:file]

    start = Time.now

    workbook = Creek::Book.new file.path

    load_time = Time.now

    import_worksheet(workbook.sheets.first)

    stop = Time.now

    timer 'LOAD TIME', start, load_time
    timer 'LOOP TIME', load_time, stop
    timer 'TOTAL TIME', start, stop

    redirect_to new_offense_path, notice: "Done! There are now #{Offense.count} offenses in the database."
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def import_worksheet(worksheet)
    # puts "Reading: #{worksheet.name}"
    total_rows, successful_rows = [0, 0]
    errors = {}
    name, dob, ftp, disposition, group, street, city, race, sex, code, text = nil

    worksheet.simple_rows.each_with_index do |row, index|
      if index == 0
        # the first row has all the names, we have to find the key associated
        # with that name, so that we can find the values of that column in all
        # future rows
        name = row.key 'DEFENDANT_NAME'
        dob = row.key 'DEFENDANT_BIRTHDATE'
        ftp = row.key 'FTP_RELIEF'
        disposition = row.key 'DISPOSITION_DATE'
        group = row.key 'GRP_ID'
        street = row.key 'DEFENDANT_ADDRESS'
        city = row.key 'DEFENDANT_CITY'
        race = row.key 'DEFENDANT_RACE'
        sex = row.key 'DEFENDANT_SEX'
        code = row.key 'CONVICTED_OFFENSE_CODE'
        text = row.key 'CONVICTED_OFFENSE_TEXT'
      else
        # if case is FTA, then status is approved
        ftp_value = row[ftp]
        fta = ftp_value == '0'
        status = fta ? 'approved' : 'pending'

        # make a hash of data that we will import
        data = {
          name: row[name], dob: row[dob], # need custom setter methods
          ftp: ftp, disposition_date: row[disposition],
          group: row[group], street_address: row[street], city: row[city],
          race: row[race], sex: row[sex], code: row[code], text: row[text],
          status: status
        }
        # print 'data: '; pp data

        # now that we have some data, let's import it
        offense = Offense.create data

        if offense.errors.any?
          # if there were any errors, log it
          error = offense.errors.to_a.join('. ')
          errors[index + 1] = { name: data[:name], error: error }
        else successful_rows += 1
        end
      end

      total_rows += 1
    end

    sleep 2
    puts "#{total_rows} TOTAL ROWS"
    puts "#{successful_rows} SUCCESSFUL ROWS"
    puts "#{errors.count} ERRORS"
    puts "#{((successful_rows / (total_rows - 1).to_f) * 100).round 3}% SUCCESS RATE"
    print "#{errors.count} ERRORS: "
    pp errors
  end

  def timer(msg, start, stop, round = 2)
    time = stop - start
    # elapsed_time = Time.at(time).utc.strftime '%H:%M:%S'
    hours = (time / (60 * 60)).to_i
    minutes = (time % (60 * 60) / 60).to_i
    seconds = (time % 60).round 2
    elapsed_time = ''
    elapsed_time << "#{hours}h" if hours.positive?
    elapsed_time << "#{minutes}m" if minutes.positive?
    elapsed_time << "#{seconds}s"

    puts "#{msg}: #{elapsed_time}"
  end
end
