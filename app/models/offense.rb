class Offense < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :status, presence: true
  has_many :contacts
  has_many :contact_histories

  def fta?
    !ftp
  end

  def type
    ftp ? 'FTP' : 'FTA'
  end

  def name=(string)
    names = string.split ','
    # 1. KEA-ALLEN CASSANDRA            < first/last can't be blank
    # 2. ANDERSON SUSAN                 < first/last
    # 3. RICHARDSON CHARLES KENITH      < first/last
    # 4. RICHARDSON CHARLES KENITH      < first/last
    # 5. JOHN DOE                       < first/last
    # 6. VICTOR                         < first/last
    # 7. VICTOR                         < first/last
    # 8. HERNANDEZ-BADILLO              < first/last
    # 9. JOHN DOE                       < first/last
    # 10. JOHN DOE                      < first/last
    # 11. FUENTE,JUAN,JOSE,ORZOA,DE,LA  < first/last
    # 12. FUENTE,JUAN,JOSE,ORZOA,DE,LA  < first/last
    # 13. FUENTE,JUAN,JOSE,ORZOA,DE,LA  < first/last
    # 14. MOORE,WILLIAM,,AUTHUR         < first
    # 15. MOORE,WILLIAM,,AUTHUR         < first
    # 16. JOHN DOE                      < first/last
    # 17. JOHN DOE                      < first/last
    # 18. GARCIA,HUGO,RAFAEL,,,,FLORES  < first/last
    # 19. GARCIA,HUGO,RAFAEL,,,,FLORES  < first/last
    # 20. PINEDA-MARADIAGA              < first/last
    # 21. PINEDA-MARADIAGA              < first/last
    # 22. MIRANDA-RENDON,,AMUEL         < first
    # 23. SOLER,LUIS,,,ANGEL,RECINO,FR  < first/last
    # 24. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
    # 25. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
    # 26. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
    # 27. ANGEL,ADOLFO,DE,LA,GARZA,DEE  < first/last
    # 28. ESRES RUDOLPH                 < first/last
    # 29. LOYA,,SANTIAGO                < first
    # 30. CARRERA,RONALD,,,,,DOUGLAS,V  < first/last
    # 31. GARCIA,HUGO,RAFAEL,,,,FLORES  < first/last
    # 32. SELF SHARMAN                  < first/last

    if names.count == 2
      # KAISERLIK,JULIE
      # MORGAN,ELAINE
      first_name = names.last
      last_name = names.first
    elsif names.count == 3
      # MAHUTA,HANNAH,B
      # RAMIREZ,JHONNY,JORGE-CRUZADO
      # MIN,JOHN,BYUNG-GUL
      # BRIDGES-JONES,CHERYL,L
      # NOTE: WHAT IF THE PERSON DOESN'T HAVE A MIDDLE NAME BUT HAS 1 FIRST NAME AND 2 LAST NAMES OR SOMETHING
      first_name = names[1]
      middle_name = names.last
      last_name = names.first
    elsif names.count == 4
      # LE,THANH,PHONG,H
      # ROSE,MILL,DENISE,BURKE
      # FARRISH,LISA,M,CRICHLOW
      # WISE,BEVERLY,A,FOSTER
      # NOTE: WHAT IF THE PERSON HAS 2 FIRST NAMES AND 1 LAST NAME
      # NOTE: WHAT IF THE PERSON HAS 2 LAST NAMES AND 1 FIRST NAME
      first_name = names[2]
      middle_name = names.last
      last_name = names[0..1].join(' ')
    elsif names.count == 5
      # COLE,BARBARA,ANN,GREEN,CARTE
      first_name = names[2..3].join(' ')
      middle_name = names.last
      last_name = names[0..1].join(' ')
    end
    self.first_name = first_name
    self.middle_name = middle_name
    self.last_name = last_name
    # print 'first name: '; p first_name
    # print 'middle name: '; p middle_name
    # print 'last name: '; p last_name
  end

  def dob=(string)
    if string.length > 7
      self.date_of_birth = Date.parse string
    else
      puts string.length
    end
  end
end
