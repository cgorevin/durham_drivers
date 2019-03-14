# frozen_string_literal: true
module OffensesHelper
  ATTRIBUTES = { 'f' => 'first_name', 'm' => 'middle_name',
                 'l' => 'last_name', 's' => 'status', 'd' => 'date_of_birth',
                  '"' => '"offenses"."group"' }
  ATTRIBUTES.default = 'first_name'

  DIRECTIONS = { 'a' => 'asc', 'd' => 'desc' }
  DIRECTIONS.default = 'asc'

  ALLOWED = %i[f m l d p c o] # details in #sort_params

  def sortable(column, title = nil)
    # set the title if not already set
    title ||= column.titleize
    # write a condition for the direction that this column should be when clickd
    direction_condition = column == sort_column && sort_direction == 'asc'
    direction = direction_condition ? 'desc' : 'asc'
    # give a class to link if column is the column we are currenly sorting
    css_class = column == sort_column ? sort_direction : nil
    # generate link for table header
    link_to title.html_safe, sort_params(column, direction), class: css_class
  end

  def sort_column
    ATTRIBUTES[params[:c]]
  end

  def sort_direction
    DIRECTIONS[params[:o]]
  end

  def sort_params(column, direction)
    # f m l stand for first, middle and last name
    # d stands for date of birth
    # p stands for page (1, 2, 3..)
    # c stands for column (first, middle, last, dob, or status)
    # o stands for order (ascending or descending)
    # " stand for group (only one that just don't make sense lol)
    params.permit(ALLOWED).merge(c: column.first, o: direction.first)
  end
end
