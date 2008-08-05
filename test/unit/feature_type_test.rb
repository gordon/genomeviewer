require File.dirname(__FILE__) + '/../test_helper'

class FeatureTypeTest < ActiveSupport::TestCase
  
  def test_uniqueness_validation
    fc = FeatureType.create(:name => "~test")
    assert !FeatureType.new(:name => "~test").valid?
    # uniqueness is defined in user_id scope:
    assert FeatureType.new(:name => "~test", :user_id => 1).valid?
    fc.destroy
  end

  def test_default_user_is_null
    fc = FeatureType.create(:name => "~test")
    assert_equal nil, fc.user_id
    fc.destroy   
  end

end
