require File.dirname(__FILE__) + '/../test_helper'

class CollapsingConfigurationTest < ActiveSupport::TestCase
  
  fixtures :users
  
  def test_load_collapsing_configuration
    u = users("a_test")
    cc = CollapsingConfiguration.new
    cc.to_parent = ["exon","intron"]
    u.collapsing_configuration = cc
    assert u.save
    u.flush_config_cache
    assert_equal cc.to_parent, 
                      u.config.get_cstr_list("collapse", "to_parent").to_a
  end
  
end
