require File.dirname(__FILE__) + '/../test_helper'
   
module InvalidUsers

   No_email = {
      :name => "John Smith",
      :password => "password"
    }
    
    No_pass = {
      :name => "John Smith",
      :email => "email@smith.org"
    }
    
    No_name = {
      :password => "genomeviewer",
      :email => "genome@viewer.org"
    }

    Invalid_email = {
      :name => "genomeviewer",
      :password => "genomeviewer",
      :email => "I haven't got one"
    }

    # this one duplicates fixture users(:giorgio)
    Duplicated_email = {
      :email => "ggonnella@rubyfanclub.jp",
      :name => "Twin",
      :password => "Towers"
    }
    
end

class UserTest < Test::Unit::TestCase
  
  fixtures :users
  include InvalidUsers
  
  def test_invalid_params
    [No_email, No_pass, No_name, 
    Invalid_email, Duplicated_email].each do |invalid_params|
      assert !User.new(invalid_params).save
    end
  end

end