require File.dirname(__FILE__) + '/../test_helper'

class CollapsingConfigurationTest < ActiveSupport::TestCase
  
  fixtures :users
  
  def test_load_collapsing_configuration
    giorgio = users("giorgio")
    cc = CollapsingConfiguration.new
    cc.to_parent = ["exon","intron"]
    giorgio.collapsing_configuration = cc
    assert giorgio.save
    assert_equal cc.to_parent, 
                      giorgio.config.get_cstr_list("collapse", "to_parent").to_a
  end
  
end
