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
    names.delete_if &:blank?
    names.join ', '
  end

  def type
    ftp ? 'FTP' : 'FTA'
  end

  # abc: [41.62/15]
  # cyclomatic complexity: [7/6]
  # method length: [28/10]
  # def namev1=(string)
  #   # 1. KEA-ALLEN CASSANDRA            < first/last can't be blank
  #   # 2. ANDERSON SUSAN                 < first/last
  #   # 3. RICHARDSON CHARLES KENITH      < first/last
  #   # 4. RICHARDSON CHARLES KENITH      < first/last
  #   # 5. JOHN DOE                       < first/last
  #   # 6. VICTOR                         < first/last
  #   # 7. VICTOR                         < first/last
  #   # 8. HERNANDEZ-BADILLO              < first/last
  #   # 9. JOHN DOE                       < first/last
  #   # 10. JOHN DOE                      < first/last
  #   # 11. FUENTE,JUAN,JOSE,ORZOA,DE,LA  < first/last
  #   # 12. FUENTE,JUAN,JOSE,ORZOA,DE,LA  < first/last
  #   # 13. FUENTE,JUAN,JOSE,ORZOA,DE,LA  < first/last
  #   # 14. MOORE,WILLIAM,,AUTHUR         < first
  #   # 15. MOORE,WILLIAM,,AUTHUR         < first
  #   # 16. JOHN DOE                      < first/last
  #   # 17. JOHN DOE                      < first/last
  #   # 18. GARCIA,HUGO,RAFAEL,,,,FLORES  < first/last
  #   # 19. GARCIA,HUGO,RAFAEL,,,,FLORES  < first/last
  #   # 20. PINEDA-MARADIAGA              < first/last
  #   # 21. PINEDA-MARADIAGA              < first/last
  #   # 22. MIRANDA-RENDON,,AMUEL         < first
  #   # 23. SOLER,LUIS,,,ANGEL,RECINO,FR  < first/last
  #   # 24. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
  #   # 25. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
  #   # 26. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
  #   # 27. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
  #   # 28. ESRES RUDOLPH                 < first/last
  #   # 29. LOYA,,SANTIAGO                < first
  #   # 30. CARRERA,RONALD,,,,,DOUGLAS,V  < first/last
  #   # 31. GARCIA,HUGO,RAFAEL,,,,FLORES  < first/last
  #   # 32. SELF SHARMAN                  < first/last
  #
  #   # all first/last can't be blank
  #   # 1. VICTOR
  #   # 2. VICTOR
  #   # 3. HERNANDEZ-BADILLO
  #   # 4. FUENTE,JUAN,JOSE,ORZOA,DE,LA
  #   # 5. FUENTE,JUAN,JOSE,ORZOA,DE,L
  #   # 6. FUENTE,JUAN,JOSE,ORZOA,DE,L
  #   # 7. FLORES,JOSE,DE LE ROSA,ALVAR
  #   # 8. FLORES,JOSE,DE LE ROSA,ALVAR
  #   # 9. CASTILLO DE LA ROSA,JUAN,ANG
  #   # 10. CASTILLO DE LA ROSA,JUAN,ANG
  #   # 11. PINEDA-MARADIAGA
  #   # 12. PINEDA-MARADIAGA
  #   # 13. ANGEL,ADOLFO,DE,LA,GARZA,DEE
  #   # 14. ANGEL,ADOLFO,DE,LA,GARZA,DEE
  #   # 15. ANGEL,ADOLFO,DE,LA,GARZA,DEE
  #   # 16. ANGEL,ADOLFO,DE,LA,GARZA,DEE
  #
  #   # 1. VICTOR
  #   # 2. VICTOR
  #   # 3. HERNANDEZ-BADILLO
  #   # 4. PINEDA-MARADIAGA
  #   # 5. PINEDA-MARADIAGA
  #
  #   # if string.include? ','
  #   #   names = string.split ','
  #   # else
  #   #   names = string.split
  #   # end
  #   # names = string.include?(',') ? string.split(',') : string.split
  #   # names = string.split( string.include?(',') ? ',' : nil )
  #   # names = string.split( string[','] ? ',' : nil )
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   if names.count == 1
  #     first_name = 'n/a'
  #     last_name = names.first
  #   elsif names.count == 2
  #     first_name = names.last
  #     last_name = names.first
  #   elsif names.count == 3
  #     first_name = names[1]
  #     middle_name = names.last
  #     last_name = names.first
  #   elsif names.count == 4
  #     first_name = names[2]
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   elsif names.count == 5
  #     first_name = names[2..3].join(' ')
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   elsif names.count == 6
  #     first_name = names[2..3].join(' ')
  #     middle_name = names[4..5].join(' ')
  #     last_name = names[0..1].join(' ')
  #   end
  #   self.first_name = first_name
  #   self.middle_name = middle_name
  #   self.last_name = last_name
  # end

  # abc: [41.16/15]
  # cyclomatic complexity: [7/6]
  # method length: [26/10]
  # def namev2=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   if names.count == 1
  #     first_name = 'n/a'
  #     last_name = names.first
  #   elsif names.count == 2
  #     first_name = names.last
  #     last_name = names.first
  #   elsif names.count == 3
  #     first_name = names[1]
  #     middle_name = names.last
  #     last_name = names.first
  #   elsif names.count == 4
  #     first_name = names[2]
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   elsif names.count == 5
  #     first_name = names[2..3].join(' ')
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   elsif names.count == 6
  #     first_name = names[2..3].join(' ')
  #     middle_name = names[4..5].join(' ')
  #     last_name = names[0..1].join(' ')
  #   end
  #   assign_attributes first_name: first_name, middle_name: middle_name, last_name: last_name
  # end

  # abc: [40.69/15]
  # cyclomatic complexity: [7/6]
  # method length: [26/10]
  # def namev3=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   if names.count == 1
  #     first_name = 'n/a'
  #     last_name = names.first
  #   elsif names.count == 2
  #     first_name = names.last
  #     last_name = names.first
  #   elsif names.count == 3
  #     first_name = names[1]
  #     middle_name = names.last
  #     last_name = names.first
  #   elsif names.count == 4
  #     first_name = names[2]
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   elsif names.count == 5
  #     first_name = names[2..3].join(' ')
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   elsif names.count == 6
  #     first_name = names[2..3].join(' ')
  #     middle_name = names[4..5].join(' ')
  #     last_name = names[0..1].join(' ')
  #   end
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [31.38/15]
  # cyclomatic complexity: [7/6]
  # method length: [27/10]
  # def namev4=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   case names.count
  #   when 1
  #     first_name = 'n/a'
  #     last_name = names.first
  #   when 2
  #     first_name = names.last
  #     last_name = names.first
  #   when 3
  #     first_name = names[1]
  #     middle_name = names.last
  #     last_name = names.first
  #   when 4
  #     first_name = names[2]
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   when 5
  #     first_name = names[2..3].join(' ')
  #     middle_name = names.last
  #     last_name = names[0..1].join(' ')
  #   when 6
  #     first_name = names[2..3].join(' ')
  #     middle_name = names[4..5].join(' ')
  #     last_name = names[0..1].join(' ')
  #   end
  #
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [26.76/15]
  # cyclomatic complexity: [7/6]
  # method length: [31/10]
  # def namev5=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   first = names.first
  #   last = names.last
  #   join1 = names[0..1].join(' ')
  #   join2 = names[2..3].join(' ')
  #
  #   case names.count
  #   when 1
  #     first_name = 'n/a'
  #     last_name = first
  #   when 2
  #     first_name = last
  #     last_name = first
  #   when 3
  #     first_name = names[1]
  #     middle_name = last
  #     last_name = first
  #   when 4
  #     first_name = names[2]
  #     middle_name = last
  #     last_name = join1
  #   when 5
  #     first_name = join2
  #     middle_name = last
  #     last_name = join1
  #   when 6
  #     first_name = join2
  #     middle_name = names[4..5].join(' ')
  #     last_name = join1
  #   end
  #
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [18.22/15]
  # cyclomatic complexity: [7/6]
  # method length: [15/10]
  # def namev6=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   first = names.first
  #   last = names.last
  #   join1 = names[0..1].join(' ')
  #   join2 = names[2..3].join(' ')
  #
  #   first_name, middle_name, last_name = case names.count
  #   when 1 then ['n/a', nil, first]
  #   when 2 then [last, nil, first]
  #   when 3 then [names[1], last, first]
  #   when 4 then [names[2], last, join1]
  #   when 5 then [join2, last, join1]
  #   when 6 then [join2, names[4..5].join(' '), join1]
  #   end
  #
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [18.03/15]
  # cyclomatic complexity: [<7/6]
  # method length: [12/10]
  # def namev7=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   first = names.first
  #   last = names.last
  #   join1 = names[0..1].join ' '
  #   join2 = names[2..3]&.join ' '
  #
  #   first_name, middle_name, last_name = {
  #     1 => ['n/a', nil, first], 2 => [last, nil, first],
  #     3 => [names[1], last, first], 4 => [names[2], last, join1],
  #     5 => [join2, last, join1], 6 => [join2, names[4..5]&.join(' '), join1]
  #   }[names.count]
  #
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [18.6/15]
  # cyclomatic complexity: [<7/6]
  # method length: [11/10]
  # def namev8=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   first, last = [names.first, names.last]
  #   join1 = names[0..1].join ' '
  #   join2 = names[2..3]&.join ' '
  #
  #   first_name, middle_name, last_name = {
  #     1 => ['n/a', nil, first], 2 => [last, nil, first],
  #     3 => [names[1], last, first], 4 => [names[2], last, join1],
  #     5 => [join2, last, join1], 6 => [join2, names[4..5]&.join(' '), join1]
  #   }[names.count]
  #
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [19.21/15]
  # cyclomatic complexity: [<7/6]
  # method length: [10/10]
  # def namev9=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   first, last = [names.first, names.last]
  #   join1, join2 = [names[0..1].join(' '), names[2..3]&.join(' ')]
  #
  #   first_name, middle_name, last_name = {
  #     1 => ['n/a', nil, first], 2 => [last, nil, first],
  #     3 => [names[1], last, first], 4 => [names[2], last, join1],
  #     5 => [join2, last, join1], 6 => [join2, names[4..5]&.join(' '), join1]
  #   }[names.count]
  #
  #   self.attributes = { first_name: first_name, middle_name: middle_name, last_name: last_name }
  # end

  # abc: [18.6/15]
  # cyclomatic complexity: [<7/6]
  # method length: [9/10]
  # def namev10=(string)
  #   names = string.split string[',']
  #   names.delete_if &:blank?
  #
  #   first, last, join1, join2 = [names.first, names.last, names[0..1].join(' '), names[2..3]&.join(' ')]
  #
  #   first_name, middle_name, last_name = {
  #     1 => ['n/a', nil, first], 2 => [last, nil, first],
  #     3 => [names[1], last, first], 4 => [names[2], last, join1],
  #     5 => [join2, last, join1], 6 => [join2, names[4..5]&.join(' '), join1]
  #   }[names.count]
  #
  #   self.attributes={first_name:first_name,middle_name:middle_name,last_name:last_name}
  # end

  # abc: [18.6/15]
  # cyclomatic complexity: [<7/6]
  # method length: [9/10]
  def name=(string)
    names = string.split string[',']
    names.delete_if &:blank?

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

    # where(date_of_birth: [dob, nil])

    # NOTE: use string for where clause
    # date = Date.parse(dob).to_s
    # where 'date_of_birth LIKE ? OR date_of_birth IS ?', date, nil

    # NOTE: split date into 3 string and modify format for partial matching
    # date = Date.parse(dob).to_s
    # year, month, day = date.split '-'
    # year += '-%'
    # month = "%-#{month}-%"
    # day = "%-#{day}"
    # where '
    #   (date_of_birth LIKE ?
    #   AND date_of_birth LIKE ?
    #   AND date_of_birth LIKE ?)
    #   OR date_of_birth IS ?
    # ', year, month, day, nil

    # NOTE: add the 3 different conditions that are required for search to work
    # NOTE: to get 2/3 date match, there are 3 combinations that we must check
    # NOTE: 1. year-month. 2. year-day. 3. month-day.
    # NOTE: if any of these combinations work, we have a match
    # date = Date.parse(dob).to_s
    # year, month, day = date.split '-'
    # year += '-%'
    # month = "%-#{month}-%"
    # day = "%-#{day}"
    # where '
    #   (
    #     (
    #       date_of_birth LIKE ? AND date_of_birth LIKE ?
    #     ) OR (
    #       date_of_birth LIKE ? AND date_of_birth LIKE ?
    #     ) OR (
    #       date_of_birth LIKE ? AND date_of_birth LIKE ?
    #     )
    #   )
    #   OR date_of_birth IS ?
    # ', year, month, year, day, month, day, nil

    # NOTE: use hash and named variables to reduce repetition
    # date = Date.parse(dob).to_s
    # year, month, day = date.split '-'
    # year += '-%'
    # month = "%-#{month}-%"
    # day = "%-#{day}"
    # where '
    #   (
    #     (
    #       date_of_birth :like :y AND date_of_birth LIKE :m
    #     ) OR (
    #       date_of_birth LIKE :y AND date_of_birth LIKE :d
    #     ) OR (
    #       date_of_birth LIKE :m AND date_of_birth LIKE :d
    #     )
    #   )
    #   OR date_of_birth IS :nil
    # ', { y: year, m: month, d: day, nil: nil }

    # NOTE: alias date_of_birth to reduce complexity. remove nil from hash
    # date = Date.parse(dob).to_s
    # year, month, day = date.split '-'
    # year += '-%'
    # month = "%-#{month}-%"
    # select('*', 'date_of_birth AS dob')
    # .where '
    #   (
    #     (
    #       dob LIKE :y AND dob LIKE :m
    #     ) OR (
    #       dob LIKE :y AND dob LIKE :d
    #     ) OR (
    #       dob LIKE :m AND dob LIKE :d
    #     )
    #   )
    #   OR dob IS NULL
    # ', y: year, m: month, d: day

    # NOTE: use strftime to reduce lines of code and avoid variable reassignment
    # date = Date.parse(dob)
    # year, month, day = date.strftime('%Y-% %%-%m-% %%-%d').split
    # select('*', 'date_of_birth AS dob')
    # .where '
    #   (
    #     (
    #       dob LIKE :y AND dob LIKE :m
    #     ) OR (
    #       dob LIKE :y AND dob LIKE :d
    #     ) OR (
    #       dob LIKE :m AND dob LIKE :d
    #     )
    #   )
    #   OR dob IS NULL
    # ', y: year, m: month, d: day

    # NOTE: reduce string size
    # date = Date.parse(dob)
    # year, month, day = date.strftime('%Y-% %%-%m-% %%-%d').split
    # select('*', 'date_of_birth AS dob')
    #   .where '
    #     ((dob LIKE :y AND dob LIKE :m)
    #     OR (dob LIKE :y AND dob LIKE :d)
    #     OR (dob LIKE :m AND dob LIKE :d)) OR dob IS NULL
    #   ', y: year, m: month, d: day

    # add support for postgres like operator
    like = Rails.env.production? ? 'ILIKE' : 'LIKE'
    date = Date.parse(dob)
    year, month, day = date.strftime('%Y-% %%-%m-% %%-%d').split
    where "
      ((date_of_birth #{like} :y AND date_of_birth #{like} :m)
      OR (date_of_birth #{like} :y AND date_of_birth #{like} :d)
      OR (date_of_birth #{like} :m AND date_of_birth #{like} :d)) OR date_of_birth IS NULL
    ".squish, y: year, m: month, d: day
  end

  # name based search with case insensitive, partial matching on all name fields
  def self.fuzzy_name_search(*names)
    # array of columns you want to search for
    attrs = %w[first_name middle_name last_name]

    # array of keywords we are search for
    # get the number of words in a query. the query "john doe smith" has 3 words
    names = I18n.transliterate(names.join(' ')).split

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
    group_search(group)
      .fuzzy_date_search(dob)
      .fuzzy_name_search(names)
  end

  private

  def downcase_fields
    self.status.downcase!
  end
end
