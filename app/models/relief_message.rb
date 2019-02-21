class ReliefMessage < ApplicationRecord
  before_validation :set_body

  belongs_to :contact

  has_many :contact_histories

  has_and_belongs_to_many :offenses

  validates :body, presence: true

  private

  def set_body
    self.body = generate_body_text
  end

  # 1. FTA dismissed only               (fta approved)
  # 2. FTC eliminated only              (ftp approved)
  # 3. FTA dismissed and FTC eliminated (fta and ftp approved)
  # 4. FTA dismissed and FTC still pending (fta approved && fta)
  # 5. FTC still pending only           (ftp pending)
  # 6. FTC remittance denied            (ftp denied) << no letters for these
  # remember that fta will always be approved, eliminates the possibility of fta being denied
  # fta approved                (1)
  # ftp pending                 (5)
  # ftp approved                (2)
  # ftp denied                  (6)
  # fta approved, ftp approved  (3)
  # fta approved, ftp pending   (4)
  # fta approved, ftp denied    (missing)
  def generate_body_text
    # we must determine if all the offenses are fta or ftp or both
    # we must determine if all the offenses are approved/pending/denied
    if offenses.all?(&:fta?)
      # render message 1
      message_1
    elsif offenses.all?(&:ftp?)
      if offenses.all?(&:pending?)
        # pending => message 5
      elsif offenses.all?(&:approved?)
        # approved => message 2
        message_2
      elsif offenses.all?(&:denied?)
        # denied => message 6
      end
    elsif offenses.any?(&:fta?) && offenses.any?(&:ftp?)
      # ftp approved => message 3
      # ftp pending => message 4
      # ftp denied => missing
    end
  end

  def message_1
    o_count = offenses.count
    one_offense = o_count == 1
    requestor_name = contact.requestor_name.presence
    full_name = offenses.first.name
    lines = offenses.map { |x| "Full name: #{x.name}. Case number: #{x.case_number}.  Charge description: #{x.description}" }
    lines = lines.join "\n"
    tickets = 'ticket'.pluralize o_count
    have = 'has'.pluralize o_count
    are = 'is'.pluralize o_count
    these = 'this'.pluralize o_count
    <<~HTML
      Dear #{full_name}:

      Thank you for using the city’s online portal to see if you have received relief through the Durham Driver’s License Restoration Project. This project is staffed by the Durham Expungement and Restoration (“DEAR”) program in collaboration with the Durham District Attorney’s Office. Our goal is to provide relief to people who have had a suspended driver’s license for more than two years due to unresolved traffic tickets in Durham County that do not involve DWIs or other “high risk” traffic offenses.

      We are excited to inform you that the Durham District Attorney’s office has dismissed the following traffic ticket(s):

      #{lines}

      The #{tickets} identified above #{have} been dismissed and #{are} now resolved. Any suspension of your driver’s license caused by the specific unresolved #{tickets} has ended. Although #{these} #{tickets} #{have} been dismissed and #{are} no longer causing your license to be suspended, this does not mean that you are now legally able to drive. There may be other traffic matters that are causing your license to remain suspended. If there are no other traffic matters causing your license to be suspended, then you will need to pay a reinstatement fee to the NCDMV in order to reinstate your license. For more information about the status of your driver’s license and/or procedures to reinstate a driver’s license, please call the NC Division of Motor Vehicles (NC DMV) at (919) 715-7000.

      If you would like to meet with a DEAR staff person to review your entire state driving record, please visit the Durham Expunction and Restoration Program (DEAR) office. The office is open Monday – Friday, 9:30am – 3:00pm and is located at the Durham County Courthouse in suite 6400 on the 6th floor. This service is free.

      Sincerely,

      The DEAR team
    HTML
  end

  def message_2
    o_count = offenses.count
    one_offense = o_count == 1
    requestor_name = contact.requestor_name.presence
    full_name = offenses.first.name
    lines = offenses.map { |x| "Full name: #{x.name}. Case number: #{x.case_number}.  Charge description: #{x.description}" }
    lines = lines.join "\n"
    tickets = 'ticket'.pluralize o_count
    have = 'has'.pluralize o_count
    are = 'is'.pluralize o_count
    these = 'this'.pluralize o_count
    cases = 'cases'.pluralize o_count
    <<~HTML
      Dear #{full_name}:

      Thank you for using this portal to see if you have received relief through the Durham Driver’s License Restoration Project. This project is staffed by the Durham Expungement and Restoration (“DEAR”) program in collaboration with the Durham District Attorney’s Office. Our goal is to provide relief to people who have had a suspended driver’s license for more than two years due to unresolved traffic tickets in Durham County that do not involve DWIs or other “high risk” traffic offenses.

      We are excited to inform you that the Durham County court has eliminated all unpaid fines and/or fees for the following traffic ticket(s):

      #{lines}

      All fines and/or fees for the #{tickets} identified above #{have} been eliminated by the court and the #{cases} #{are} now resolved. Any suspension of your driver’s license caused by the specific unresolved #{tickets} has ended. Although the fines and/or fees  for the #{tickets} identified above have been eliminated and the #{tickets} #{are} no longer causing your license to be suspended, this does not mean that you are now legally able to drive. There may be other traffic matters that are causing your license to remain suspended. If there are no other traffic matters causing your license to be suspended, then you will need to pay a reinstatement fee to the NCDMV in order to reinstate your license. For more information about the status of your driver’s license and/or procedures to reinstate a driver’s license, please call the NC Division of Motor Vehicles (NC DMV) at (919) 715-7000.

      If you would like to meet with a DEAR staff person to review your entire state driving record, please visit the Durham Expunction and Restoration Program (DEAR) office. The office is open Monday – Friday, 9:30am – 3:00pm and is located at the Durham County Courthouse in suite 6400 on the 6th floor. This service is free.

      Sincerely,

      The DEAR team
    HTML
  end

  def message_3
    full_name = offenses.first.name
    ftas = offenses.select(&:fta?)
    fta_lines = ftas.map { |x| "Full name: #{x.name}. Case number: #{x.case_number}.  Charge description: #{x.description}" }
    fta_lines = lines.join "\n"
    ftps = offenses.select(&:ftp?)
    ftp_lines = ftas.map { |x| "Full name: #{x.name}. Case number: #{x.case_number}.  Charge description: #{x.description}" }
    ftp_lines = lines.join "\n"
    fta_tickets = 'ticket'.pluralize ftas.count
    ftp_tickets = 'ticket'.pluralize ftps.count

    <<~HTML
      Dear #{full_name}:

      This project is staffed by the Durham Expungement and Restoration (“DEAR”) program in collaboration with the Durham District Attorney’s Office. Our goal is to provide relief to people who have had a suspended driver’s license for more than two years due to unresolved traffic tickets in Durham County that do not involve DWIs or other “high risk” traffic offenses.

      We are excited to inform you that the Durham District Attorney’s office has dismissed the following traffic #{fta_tickets}:

      #{fta_lines}

      We are excited to inform you that the Durham County court has eliminated all unpaid fines and/or fees for the following traffic #{ftp_tickets}:

      #{ftp_lines}

      All tickets identified above have been resolved. Any suspensions of your driver’s license caused by the specific tickets being unresolved have ended. Although the fines and/or fees  for the tickets identified above have been eliminated and the tickets are no longer causing your license to be suspended, this does not mean that you are now legally able to drive. There may be other traffic matters that are causing your license to remain suspended. If there are no other traffic matters causing your license to be suspended, then you will need to pay a reinstatement fee to the NCDMV in order to reinstate your license. For more information about the status of your driver’s license and/or procedures to reinstate a driver’s license, please call the NC Division of Motor Vehicles (NC DMV) at (919) 715-7000.

      If you would like to meet with a DEAR staff person to review your entire state driving record, please visit the Durham Expunction and Restoration Program (DEAR) office. The office is open Monday – Friday, 9:30am – 3:00pm and is located at the Durham County Courthouse in suite 6400 on the 6th floor. This service is free.

      Sincerely,

      The DEAR team
    HTML
  end
end
