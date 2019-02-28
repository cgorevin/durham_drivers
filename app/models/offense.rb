# frozen_string_literal: true

class Offense < ApplicationRecord
  alias_attribute :street, :street_address
  alias_attribute :first, :first_name
  alias_attribute :middle, :middle_name
  alias_attribute :last, :last_name
  # alias_attribute :dob, :date_of_birth

  before_validation :downcase_fields

  has_and_belongs_to_many :contacts
  has_many :contact_histories

  paginates_per 100

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :status, presence: true
  validates :status, allow_blank: true, inclusion: {
    in: %w[pending approved denied],
    message: %("%{value}" is not a valid status)
  }

  def age
    return unless dob

    t = Date.today
    age = t.year - dob.year
    b4bday = t.strftime('%m%d') < dob.strftime('%m%d')
    age - (b4bday ? 1 : 0)
  end

  def approved?
    status == 'approved'
  end

  def denied?
    status == 'denied'
  end

  def pending?
    status == 'pending'
  end

  # NOTE: use method instead of alias_attribute so that we can write our own
  # dob= setter method
  def dob
    date_of_birth
  end

  def fta?
    !ftp
  end

  def name
    names = [last_name, first_name, middle_name]
    names.delete_if(&:blank?)
    names.join ', '
  end

  def type
    ftp ? 'FTP' : 'FTA'
  end

  # abc: [18.6/15]
  # cyclomatic complexity: [<7/6]
  # method length: [9/10]
  def name=(string)
    names = string.split string[',']
    names.delete_if(&:blank?)

    first, last, join1, join2 = [names[0], names[-1], names[0..1].join(' '), names[2..3]&.join(' ')]

    first, middle, last = {
      1 => ['n/a', nil, first],     2 => [last, nil, first],
      3 => [names[1], last, first], 4 => [names[2], last, join1],
      5 => [join2, last, join1],    6 => [join2, names[4..5]&.join(' '), join1]
    }[names.count]

    self.attributes = { first: first, middle: middle, last: last }
  end

  def dob=(string)
    return unless string.length > 7

    # '20120203'
    self.date_of_birth = Date.parse string
  end

  def self.exact_search(first_name, middle_name, last_name, date_of_birth)
    like = Rails.env.production? ? 'ILIKE' : 'LIKE'
    search = where date_of_birth: date_of_birth
    search.where(
      "first_name #{like} ? AND middle_name #{like} ? AND last_name #{like} ?",
      first_name, middle_name, last_name
    )
  end

  def self.fuzzy_search(*names, dob)
    fuzzy_date_search(dob).fuzzy_name_search(names)
  end

  # date based query, only has to match 2/3 of the date (year, month, day)
  def self.fuzzy_date_search(dob)
    return all unless dob.present?

    # date = Date.parse(dob)
    date = Chronic.parse(dob).to_date
    year, month, day = date.strftime('%Y-% %%-%m-% %%-%d').split

    # add support for postgres like operator
    like, column = if Rails.env.production?
                     ['ILIKE', "to_char(date_of_birth, 'YYYY-MM-DD')"]
                   else %w[LIKE date_of_birth]
                   end

    sql = "((%<dob>s %<like>s :y AND %<dob>s %<like>s :m)
          OR (%<dob>s %<like>s :y AND %<dob>s %<like>s :d)
          OR (%<dob>s %<like>s :m AND %<dob>s %<like>s :d))
          OR date_of_birth IS NULL"
    phrase = format(sql, dob: column, like: like).squish
    where phrase, y: year, m: month, d: day
  end

  def self.fuzzy_name_search(*names)
    # array of columns you want to search for
    attrs = %w[first_name middle_name last_name]

    # array of keywords we are search for
    # get the number of words in a query. the query "john doe smith" has 3 words
    names = I18n.transliterate(names.join(' ')).split
    return all unless names.any?

    # split "john doe smith" into ["john", "doe", "smith"]
    # multiply by the number of columns you are searching for
    # if columns = [first_name and last_name], then multiply by 2
    # ["john", "doe", "smith", "john", "doe", "smith"]
    # sort it: ["doe", "doe", "john", "john", "smith", "smith"]
    # wrap with %'s to allow wildcard searches
    # ["%doe%", "%doe%", "%john%", "%john%", "%smith%", "%smith%"]
    terms = (names * attrs.size).sort.map { |term| "%#{term}%" }

    # use case insensitive operator
    # allows to find 'John' with 'john', 'JOHN', 'jOhN', etc
    # sqlite3's operator for case insensitivity is LIKE
    # postgres's operator for case insensitivity is ILIKE
    like = Rails.env.production? ? 'ILIKE' : 'LIKE'

    # turn columns into SQL phrase
    # ['first_name', 'last_name'] => "(first_name like ? OR last_name like ?)"
    phrase = %`(#{attrs.map { |c| "#{c} #{like} ?" }.join(' OR ')})`

    # multiply by 3 if words.size = 3. join with ' AND '
    # (first_name LIKE ? OR last_name LIKE ?) AND
    # (first_name LIKE ? OR last_name LIKE ?) AND
    # (first_name LIKE ? OR last_name LIKE ?)
    # pass that string in and the array of terms to get sql like:
    # (first_name LIKE "%doe%" OR last_name LIKE "%doe%") AND
    # (first_name LIKE "%john%" OR last_name LIKE "%john%") AND
    # (first_name LIKE "%smith%" OR last_name LIKE "%smith%")
    where ([phrase] * names.size).join(' AND '), *terms
  end

  def self.pg_fuzzy_name_search(*names)
    # array of columns you want to search for
    attrs = %w[first_name middle_name last_name]

    # remove accents and make array full of names
    names = I18n.transliterate(names.join(' ')).split
    return all unless names.any?

    # split "john doe smith" into ["john", "doe", "smith"]
    # multiply by the number of columns you are searching for
    # if columns = [first_name and last_name], then multiply by 2
    # wrap with %'s to allow wildcard searches
    # ["%john%", "%doe%", "%smith%", "%john%", "%doe%", "%smith%"]
    terms = names * attrs.size

    # loop thru attrs and make an array of strings like
    # 'difference(first_name, ?) > 3 OR difference(first_name, ?) > 3'
    # join the strings with ' AND '
    phrase = attrs.map do |atr|
      %`(#{(["difference(#{atr}, ?) > 2"] * names.size).join ' OR '})`
    end.join(' AND ')

    where phrase, *terms
  end

  def self.pg_fuzzy_name_search(*names)
    # array of columns you want to search for
    attrs = %w[first_name middle_name last_name]

    # remove accents and make array full of names
    names = I18n.transliterate(names.join(' ')).split
    return all unless names.any?

    # split "john doe smith" into ["john", "doe", "smith"]
    # multiply by the number of columns you are searching for
    # if columns = [first_name and last_name], then multiply by 2
    # wrap with %'s to allow wildcard searches
    # ["%john%", "%doe%", "%smith%", "%john%", "%doe%", "%smith%"]
    terms = names * attrs.size

    # turn columns into SQL phrase
    # ['first_name', 'last_name'] => "(first_name like ? OR last_name like ?)"
    phrase = %`(#{attrs.map { |c| "difference(#{c}, ?) > 3" }.join(' OR ')})`

    # multiply by 3 if words.size = 3. join with ' AND '
    # (first_name LIKE ? OR last_name LIKE ?) AND
    # (first_name LIKE ? OR last_name LIKE ?) AND
    # (first_name LIKE ? OR last_name LIKE ?)
    # pass that string in and the array of terms to get sql like:
    # (first_name LIKE "%doe%" OR last_name LIKE "%doe%") AND
    # (first_name LIKE "%john%" OR last_name LIKE "%john%") AND
    # (first_name LIKE "%smith%" OR last_name LIKE "%smith%")
    where ([phrase] * names.size).join(' AND '), *terms
  end

  # find all groups that partially match group given
  # search for "5" should return ["5", "15", "25", "35", "45", "50", "51", "52"]
  def self.groups(group)
    like = Rails.env.production? ? 'ILIKE' : 'LIKE'
    search = where %("offenses"."group" #{like} ?), "%#{group}%"
    search.map(&:group).uniq.map(&:to_i).sort
  end

  # find all offenses that belong to a group
  def self.group_search(group)
    return all unless group.present?

    group = 'NA' if group.to_i.zero?
    # SQL will try to use GROUP BY unless you clearly specify offenses.group
    where '"offenses"."group" = ?', group
  end

  def self.fuzzy_group_search(*names, dob, group)
    search = group_search(group)
             .fuzzy_date_search(dob)
    if Rails.env.production?
      search.pg_fuzzy_name_search(names)
    else
      search.fuzzy_name_search(names)
    end
  end

  private

  def downcase_fields
    self.status.downcase!
  end
end
