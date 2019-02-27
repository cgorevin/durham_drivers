require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test "approved" do
    mail = ContactMailer.approved
    assert_equal "Approved", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "denied" do
    mail = ContactMailer.denied
    assert_equal "Denied", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
