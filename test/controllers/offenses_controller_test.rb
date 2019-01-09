require 'test_helper'

class OffensesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get offenses_new_url
    assert_response :success
  end

end
