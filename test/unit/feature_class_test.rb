require File.dirname(__FILE__) + '/../test_helper'

class FeatureClassTest < ActiveSupport::TestCase
  
  def test_uniqueness_validation
    fc = FeatureClass.create(:name => "~test")
    assert !FeatureClass.new(:name => "~test").valid?
    # uniqueness is defined in user_id scope:
    assert FeatureClass.new(:name => "~test", :user_id => 1).valid?
    fc.destroy
  end

  def test_default_user_is_null
    fc = FeatureClass.create(:name => "~test")
    assert_equal nil, fc.user_id
    fc.destroy   
  end

end
