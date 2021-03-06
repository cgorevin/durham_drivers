# frozen_string_literal: true
class OffensesController < ApplicationController
  include OffensesHelper

  before_action :set_params, only: [:index, :group, :group_update]
  before_action :set_offense, only: [:show, :edit, :update]
  before_action :authenticate_admin!, only: [:new, :index, :show, :edit, :group, :panel]

  def index
    @group = params[:g]
    @groups = Offense.groups @group
    @offenses = Offense.fuzzy_group_search(@first, @middle, @last, @date, @group)
                       .order("#{sort_column} #{sort_direction}")
                       .page(@page)
  end

  def show
    @offense = Offense.includes(contacts: { contact_histories: :relief_message })
                      .order('contact_histories.id desc')
                      .find params[:id]
    @contacts = @offense.contacts
  end

  def new
    @offense = Offense.new
  end

  def create
    importer = ImporterV3.new params[:offense][:file]
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
  def group_update
    @group = params[:group]
    offenses = params[:offenses]
    Offense.update offenses.keys, offenses.values

    redirect_to group_offenses_path(@group, p: @page, f: @first, m: @middle, l: @last), notice: 'Save successful'
  end

  def stats
    @pending = Offense.where(status: 'pending')
    @pending_unnotified = @pending.unnotified.count
    @pending_notified = @pending.notified.count
    @approved = Offense.where(status: 'approved')
    @approved_unnotified = @approved.unnotified.count
    @approved_notified = @approved.notified.count
    @denied = Offense.where(status: 'denied')
    @denied_unnotified = @denied.unnotified.count
    @denied_notified = @denied.notified.count
    @pulled = Offense.where(status: 'pulled')
    @pulled_unnotified = @pulled.unnotified.count
    @pulled_notified = @pulled.notified.count
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
