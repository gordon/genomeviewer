require File.dirname(__FILE__) + '/../test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  
  def setup
    @conf = Configuration.create(:user_id => 1)
  end
  
  def test_default_format
    assert @conf.format.kind_of?(Format)
  end
  
  def test_flush_cache
    @conf.gt
    assert GTServer.cached_config_for?(@conf.user_id)
    @conf.flush_cache
    assert !GTServer.cached_config_for?(@conf.user_id)
  end
  
end