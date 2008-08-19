require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + "/modules/gt_objects_assertions.rb"

class ConfigurationTest < ActiveSupport::TestCase
  
  include GTObjectsAssertions
  
  def setup
    @conf = Configuration.create(:user_id => 1)
    # reinit config
    @conf.uncache
    @conf.gt
  end
  
  def test_there_is_a_format
    assert_not_nil @conf.format
    assert_kind_of Format, @conf.format
  end
  
  def test_section_objects_and_sections
    assert_kind_of Array, @conf.sections
    assert_kind_of Array, @conf.section_objects
    assert !@conf.sections.empty?
    assert !@conf.section_objects.empty?
    assert_equal ["format"], @conf.sections
    assert_kind_of Format, @conf.section_objects[0]
    ft = FeatureType.new(:name => "test")
    @conf.feature_types << ft
    assert @conf.section_objects.include?(ft)
    assert_equal ["format", "test"], @conf.sections
  end
  
  def test_gt
    assert_gt_config @conf.gt
  end
  
  def test_gt_cached
    assert GTServer.config_cached?(@conf.id)
  end
  
  def test_uncache
    assert GTServer.config_cached?(@conf.id)
    @conf.uncache
    assert !GTServer.config_cached?(@conf.id)
  end
  
  def test_gt_upload_exception
    attr = ["format","margins"]
    assert_not_equal 777.0, @conf.format.margins
    assert_not_equal 777.0, GTServer.config(@conf.id).get_num(*attr)
    @conf.format.margins = 777.0
    @conf.gt(*attr)
    assert_equal 777.0, @conf.format.margins
    assert_not_equal 777.0, GTServer.config(@conf.id).get_num(*attr)
    @conf.uncache
    @conf.gt # no exception now
    assert_equal 777.0, @conf.format.margins
    assert_equal 777.0, GTServer.config(@conf.id).get_num(*attr)
  end
  
  def test_default_gt_config
    assert_gt_config Configuration.default
  end
  
  def test_equal_img_config_new_and_default
    filename = File.expand_path("../gff3/little1.gff3",File.dirname(__FILE__))
    assert File.exist?(filename)
    args = [filename, "test1", (1000..9000), nil, # <- args[3] is config_obj
            800, true, true]
    args_conf_gt = args.clone
    args_conf_gt[3] = @conf.gt
    args_conf_new = args.clone
    args_conf_new[3] = GTServer.config_new
    assert_equal GTServer.image(*args_conf_new), GTServer.image(*args_conf_gt)
    @conf.gt.set_num("format", "margins", 200.0)
    assert_not_equal GTServer.image(*args_conf_new), GTServer.image(*args_conf_gt)
  end
  
end