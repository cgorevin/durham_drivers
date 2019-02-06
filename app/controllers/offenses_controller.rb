class OffensesController < ApplicationController
  include OffensesHelper

  before_action :set_params, only: [:index, :group, :group_update]
  before_action :set_offense, only: [:show, :edit, :update]
  # before_action :authenticate_admin!, :except => [:index]

  def index
    @group = params[:g]
    @groups = Offense.groups @group
    @offenses = Offense.fuzzy_group_search(@first, @middle, @last, @date, @group)
                       .order("#{sort_column} #{sort_direction}")
                       .page @page
  end

  def show
    @contacts = @offense.contacts
  end

  def new
    @offense = Offense.new
  end

  def create
    importer = Importer.new params[:offense][:file]
    importer.begin_import
    redirect_to new_offense_path, notice: "Done! There are now #{Offense.count} offenses in the database."
  end

  def edit
  end

  def update
    if @offense.update offense_params
      redirect_to @offense, notice: 'Save successful'
    else
      flash.alert = @offense.errors.to_a.join('. ')
      render :edit
    end
  end

  def destroy
  end

  # GET "/offenses/group/4"
  def group
    @group = params[:group]
    # @offenses = Offense.group_search(params[:group]).page page
    @offenses = Offense.fuzzy_group_search(@first, @middle, @last, @dob, @group)
                       .order("#{sort_column} #{sort_direction}")
                       .page @page
  end

  # POST "/offenses/group/4"
  # when user submits table form
  # Parameters: {
  #   "p"=>"",
  #   "commit"=>"Save",
  #   "offenses"=>{
  #     "100"=>{"status"=>"pending"},
  #     "101"=>{"status"=>"approved"},
  #     "305"=>{"status"=>"denied"},
  #     "400"=>{"status"=>"pending"},
  #     ...
  #   },
  #   "group"=>"4"
  # }
  # when user presses one of the 'mark as ...' buttons
  # Parameters: {
  #   "ids"=>"55 56 57 58 29327",
  #   "status"=>"pending",
  #   "group"=>"4"
  # }
  def group_update
    @group = params[:group]
    if status = params[:status]
      Offense.where(id: params[:ids].split).update_all(status: status)
    elsif offenses = params[:offenses]
      Offense.update offenses.keys, offenses.values
    end

    redirect_to group_offenses_path(@group, p: @page, f: @first, m: @middle, l: @last), notice: 'Save successful'
  end

  private

  def offense_params
    params.require(:offense).permit(:status, :group)
  end

  def set_offense
    @offense = Offense.find params[:id]
  end

  def set_params
    @first = params[:f]
    @middle = params[:m]
    @last = params[:l]
    @date = params[:d]
    @page = params[:p]
  end
end
