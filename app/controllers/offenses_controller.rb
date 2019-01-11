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
      name_position = nil
      worksheet.simple_rows.each_with_index do |row, index|
        if index == 0
          name_position = row.key 'DEFENDANT_NAME'
          p "name_position: ", name_position
        else
          name = row[name_position]
          p "name: ", name
        end
        print 'row: '
        pp row
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
