class OffensesController < ApplicationController
  # before_action :authenticate_admin!, :except => [:show, :index, :new, :create]

  def index
  end

  def show
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
  # 94817 SUCCESSFUL ROWS
  # 94817 OFFENSES CREATED
  # 32 ERRORS: {8329=>
  #   {:name=>"KEA-ALLEN CASSANDRA",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  8330=>
  #   {:name=>"ANDERSON SUSAN",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  8331=>
  #   {:name=>"RICHARDSON CHARLES KENITH",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  8332=>
  #   {:name=>"RICHARDSON CHARLES KENITH",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  15949=>
  #   {:name=>"JOHN DOE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  18736=>
  #   {:name=>"VICTOR",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  18737=>
  #   {:name=>"VICTOR",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  20054=>
  #   {:name=>"HERNANDEZ-BADILLO",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  22445=>
  #   {:name=>"JOHN DOE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  22446=>
  #   {:name=>"JOHN DOE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  35086=>
  #   {:name=>"FUENTE,JUAN,JOSE,ORZOA,DE,LA",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  35087=>
  #   {:name=>"FUENTE,JUAN,JOSE,ORZOA,DE,L",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  35088=>
  #   {:name=>"FUENTE,JUAN,JOSE,ORZOA,DE,L",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  37246=>{:name=>"MOORE,WILLIAM,,AUTHUR", :error=>"First name can't be blank"},
  #  37247=>{:name=>"MOORE,WILLIAM,,AUTHUR", :error=>"First name can't be blank"},
  #  46527=>
  #   {:name=>"JOHN DOE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  46528=>
  #   {:name=>"JOHN DOE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  52794=>
  #   {:name=>"GARCIA,HUGO,RAFAEL,,,,FLORES",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  52795=>
  #   {:name=>"GARCIA,HUGO,RAFAEL,,,,FLORES",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  56219=>
  #   {:name=>"PINEDA-MARADIAGA",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  56220=>
  #   {:name=>"PINEDA-MARADIAGA",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  56486=>{:name=>"MIRANDA-RENDON,,AMUEL", :error=>"First name can't be blank"},
  #  57518=>
  #   {:name=>"SOLER,LUIS,,,ANGEL,RECINO,FR",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  64003=>
  #   {:name=>"ANGEL,ADOLFO,DE,LA,GARZA,DEE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  64004=>
  #   {:name=>"ANGEL,ADOLFO,DE,LA,GARZA,DEE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  64005=>
  #   {:name=>"ANGEL,ADOLFO,DE,LA,GARZA,DEE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  64006=>
  #   {:name=>"ANGEL,ADOLFO,DE,LA,GARZA,DEE",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  75652=>
  #   {:name=>"ESRES RUDOLPH",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  86065=>{:name=>"LOYA,,SANTIAGO", :error=>"First name can't be blank"},
  #  91473=>
  #   {:name=>"CARRERA,RONALD,,,,,DOUGLAS,V",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  91721=>
  #   {:name=>"GARCIA,HUGO,RAFAEL,,,,FLORES",
  #    :error=>"First name can't be blank. Last name can't be blank"},
  #  91915=>
  #   {:name=>"SELF SHARMAN",
  #    :error=>"First name can't be blank. Last name can't be blank"}}
  # "LOAD FILE TIME: 10.58s"
  # "LOOP TIME: 13m28.48s"
  # "TOTAL TIME: 13m39.07s"
  # def create
  #   file = params[:offense][:file]
  #   start = Time.now
  #   workbook = Creek::Book.new file.path # , check_file_extension: false
  #   new_book_time = Time.now
  #   worksheets = workbook.sheets
  #   # puts "Found #{worksheets.count} worksheets"
  #
  #   worksheets.each do |worksheet|
  #     # puts "Reading: #{worksheet.name}"
  #     total_rows = 0
  #     succesful_rows = 0
  #     errors = {}
  #     name, ftp, dob, disposition, group, street, city, race, sex, code, text = nil
  #     worksheet.simple_rows.each_with_index do |row, index|
  #       if index == 0
  #         # the first row has all the names, we have to find the key associated
  #         # with that name, so that we can find the values of that column in all
  #         # future rows
  #         name = row.key 'DEFENDANT_NAME'
  #         ftp = row.key 'FTP_RELIEF'
  #         dob = row.key 'DEFENDANT_BIRTHDATE'
  #         disposition = row.key 'DISPOSITION_DATE'
  #         group = row.key 'GRP_ID'
  #         street = row.key 'DEFENDANT_ADDRESS'
  #         city = row.key 'DEFENDANT_CITY'
  #         race = row.key 'DEFENDANT_RACE'
  #         sex = row.key 'DEFENDANT_SEX'
  #         code = row.key 'CONVICTED_OFFENSE_CODE'
  #         text = row.key 'CONVICTED_OFFENSE_TEXT'
  #       else
  #         # make a hash of data that we will import
  #         data = {
  #           name: row[name], # need custom setter method
  #           ftp: row[ftp], # may need custom setter method
  #           dob: row[dob], # need custom setter method
  #           disposition_date: row[disposition],
  #           group: row[group], street_address: row[street], city: row[city],
  #           race: row[race], sex: row[sex], code: row[code], text: row[text],
  #           status: 'pending'
  #         }
  #         # print 'data: '; pp data
  #
  #         # now that we have some data, let's import it
  #         offense = Offense.create data
  #
  #         if offense.errors.any?
  #           # if there were any errors, log it
  #           errors[index + 1] = {
  #             name: data[:name],
  #             error: offense.errors.to_a.join('. ')
  #           }
  #         else
  #           # else this row was a succesfully imported
  #           succesful_rows += 1
  #         end
  #       end
  #
  #       total_rows += 1
  #     end
  #
  #     puts "#{total_rows} TOTAL ROWS"
  #     puts "#{succesful_rows} SUCCESSFUL ROWS"
  #     puts "#{Offense.count} OFFENSES CREATED"
  #     print "#{errors.count} ERRORS: "
  #     pp errors
  #   end
  #
  #   stop = Time.now
  #   timer 'LOAD FILE TIME', start, new_book_time
  #   timer 'LOOP TIME', new_book_time, stop
  #   timer 'TOTAL TIME', start, stop
  #
  #   redirect_to new_offense_path # , notice: 'CREATE SUCCESSFUL'
  # end

  def create
    file = params[:offense][:file]

    start = Time.now

    workbook = Creek::Book.new file.path

    load_time = Time.now

    import_worksheet(workbook.sheets.first)

    stop = Time.now

    timer 'LOAD FILE TIME', start, load_time
    timer 'LOOP TIME', load_time, stop
    timer 'TOTAL TIME', start, stop

    redirect_to new_offense_path
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
    total_rows, succesful_rows = 0
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
        # make a hash of data that we will import
        data = {
          name: row[name], dob: row[dob], # need custom setter methods
          ftp: row[ftp], disposition_date: row[disposition],
          group: row[group], street_address: row[street], city: row[city],
          race: row[race], sex: row[sex], code: row[code], text: row[text],
          status: 'pending'
        }
        # print 'data: '; pp data

        # now that we have some data, let's import it
        offense = Offense.create data

        if offense.errors.any?
          # if there were any errors, log it
          error = offense.errors.to_a.join('. ')
          errors[index + 1] = { name: data[:name], error: error }
        else succesful_rows += 1
        end
      end

      total_rows += 1
    end

    puts "#{total_rows} TOTAL ROWS"
    puts "#{succesful_rows} SUCCESSFUL ROWS"
    puts "#{Offense.count} OFFENSES CREATED"
    print "#{errors.count} ERRORS: ", pp errors
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

    p "#{msg}: #{elapsed_time}"
  end
end
