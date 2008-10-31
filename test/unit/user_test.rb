require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + "/modules/invalid_users.rb"

class UserTest < Test::Unit::TestCase

  fixtures :users

  i = 0
  InvalidUsers.each do |invalid_params, error_msg|
    i += 1
    define_method :"test_invalid_params_#{i}" do
      assert !User.new(invalid_params).save,
             "Save was expected to return false as #{error_msg}"
    end
  end

  def test_email_duplication
    # create an user to duplicate email from
    User.create(:password => "test",
                :name => "test",
                :email => "test@test.tst")
    assert_nil User.create(:password => "test2",
                     :name => "test2",
                     :email => "test@test.tst").id
  end

end