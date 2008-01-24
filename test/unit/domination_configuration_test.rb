require File.dirname(__FILE__) + '/../test_helper'

class DominationConfigurationTest < ActiveSupport::TestCase

  fixtures :users, :feature_classes
  
  def test_load_dominations
    assert_not_equal users("giorgio").config.get_cstr_list("dominate","exon").to_a,
                      ["intron","mRNA"]
                      
    dd1 = DominationConfiguration.new
    dd1.dominating = feature_classes("exon")
    dd1.dominated = feature_classes("intron")
    dd2 = DominationConfiguration.new
    dd2.dominating = feature_classes("exon")
    dd2.dominated = feature_classes("mRNA")
    
    users("giorgio").domination_configurations = [dd1,dd2]
    assert users("giorgio").save
    assert_equal users("giorgio").config.get_cstr_list("dominate","exon").to_a,
                      ["intron","mRNA"]
  end

end
