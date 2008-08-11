require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + "/modules/gt_objects_assertions.rb"

class ConfigurationTest < ActiveSupport::TestCase
  
  include GTObjectsAssertions
  
  def setup
    @conf = Configuration.create(:user_id => 1)
  end
  
  def test_default_format
    assert @conf.format.kind_of?(Format)
  end
  
  def test_gt
    assert_gt_config @conf.gt
  end
  
  def test_flush_cache
    @conf.gt
    assert GTServer.cached_config_for?(@conf.user_id)
    @conf.flush_cache
    assert !GTServer.cached_config_for?(@conf.user_id)
  end
  
  def default
    assert_gt_config Configuration.default
  end
  
end