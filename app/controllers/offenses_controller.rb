class OffensesController < ApplicationController
  before_action :authenticate_admin!, :except => [:show, :index, :new, :create]

  def timer(msg, start, stop, round = 2)
    p "#{msg}: #{(stop - start).round round} seconds"
  end

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
  def create
    file = params[:offense][:file]
    start = Time.now
    workbook = Creek::Book.new file.path # , check_file_extension: false
    new_book_time = Time.now
    timer 'LOAD FILE TIME', start, new_book_time
    worksheets = workbook.sheets
    puts "Found #{worksheets.count} worksheets"

    worksheets.each do |worksheet|
      puts "Reading: #{worksheet.name}"
      num_rows = 0
      name_key, ftp_key, dob_key, disposition_key, group_key, street_key, city_key = nil
      worksheet.simple_rows.each_with_index do |row, index|
        data = {}
        if index == 0
          name_key = row.key 'DEFENDANT_NAME'
          ftp_key = row.key 'FTP_RELIEF'
          dob_key = row.key 'DEFENDANT_BIRTHDATE'
          disposition_key = row.key 'DISPOSITION_DATE'
          group_key = row.key 'GRP_ID'
          street_key = row.key 'DEFENDANT_ADDRESS'
          city_key = row.key 'DEFENDANT_CITY'
          print 'name_key: '; p name_key
          print 'ftp_key: '; p ftp_key
          print 'dob_key: '; p dob_key
          print 'disposition_key: '; p disposition_key
          print 'group_key: '; p group_key
          print 'street_key: '; p street_key
          print 'city_key: '; p city_key
        else
          data[:name] = row[name_key] # need custom setter method
          data[:ftp] = row[ftp_key] # may need custom setter method
          data[:dob] = row[dob_key] # need custom setter method
          data[:disposition_date] = row[disposition_key] # need custom setter method
          data[:group] = row[group_key] # need custom setter method
          data[:street_address] = row[street_key] # need custom setter method
          data[:city] = row[city_key] # need custom setter method
          print 'data: '; pp data
        end
        print 'row: '; pp row
        row_cells = row.values

        # splitting the name
        num_rows += 1
      end
      puts "Read #{num_rows} rows"
    end

    stop = Time.now
    timer 'LOOP TIME', new_book_time, stop
    timer 'TOTAL TIME', start, stop

    redirect_to new_offense_path # , notice: 'CREATE SUCCESSFUL'
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
