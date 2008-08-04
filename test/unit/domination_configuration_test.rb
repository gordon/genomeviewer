require File.dirname(__FILE__) + '/../test_helper'

class DominationConfigurationTest < ActiveSupport::TestCase

  fixtures :users, :feature_classes
  
  def test_load_dominations
    u = users("a_test")
    assert_not_equal ["intron","mRNA"],
         u.config.get_cstr_list("dominate","exon").to_a
                      
                      
    dd = DominationConfiguration.create(:dominator => feature_classes("exon"))
    df1 = DominatedFeature.new do |df|
      df.feature_class = feature_classes("intron")
      df.domination_configuration = dd
      df.save
    end    
    df2 = DominatedFeature.new do |df|
      df.feature_class = feature_classes("mRNA")
      df.domination_configuration = dd
      df.save
    end
    
    u.domination_configurations = [dd]
    u.save
    u.flush_config_cache
    assert_equal ["intron","mRNA"], 
                      u.config.get_cstr_list("dominate","exon").to_a
                      
  end

end
