require File.dirname(__FILE__) + '/../test_helper'

class FeatureTypeTest < ActiveSupport::TestCase
  
  def test_uniqueness_validation
    fc = FeatureType.create(:name => "~test", :configuration_id => 1)
    assert !FeatureType.new(:name => "~test", :configuration_id => 1).valid?
    # uniqueness is defined in user_id scope:
    assert FeatureType.new(:name => "~test", :configuration_id => 2).valid?
    fc.destroy
  end

end
