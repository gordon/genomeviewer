require File.dirname(__FILE__) + '/../test_helper'

class DominationConfigurationTest < ActiveSupport::TestCase

  fixtures :users, :feature_classes
  
  def test_load_dominations
    assert_not_equal ["intron","mRNA"],
         users("giorgio").config.get_cstr_list("dominate","exon").to_a
                      
                      
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
    
    users("giorgio").domination_configurations = [dd]
    assert users("giorgio").save
    assert_equal ["intron","mRNA"], 
                      users("giorgio").config.get_cstr_list("dominate","exon").to_a
                      
  end

end
