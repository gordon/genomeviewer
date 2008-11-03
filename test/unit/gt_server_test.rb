require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/modules/gt_objects_assertions.rb"

class GtServerTest < ActiveSupport::TestCase

  include GTObjectsAssertions

  def test_connection
    assert_nothing_raised {GTServer.test_call}
    assert_not_nil GTServer.test_call
  end

  ### module Parsing ###

  [:on, :off, nil].each do |mode|
    string = mode.nil? ? "nil" : mode
    define_method "test_feature_index_caching_mode_#{string}" do
      filename = "test/gff3/little1.gff3"
      assert_nothing_raised { GTServer.gff3_uncache(filename) }
      assert_nil GTServer.gff3_uncache(filename)
      assert !GTServer.feature_index_cached?(filename, mode)
      assert !GTServer.feature_types_cached?(filename)
      fix = nil
      assert_nothing_raised { fix = GTServer.feature_index(filename, mode) }
      assert_not_nil fix
      assert GTServer.feature_index_cached?(filename, mode)
      assert GTServer.feature_types_cached?(filename)
      assert_not_nil GTServer.gff3_uncache(filename)
      assert_nil     GTServer.gff3_uncache(filename)
      fix = nil
    end
  end

  def test_errors_on_valid
    valid_gff3 = "test/gff3/little2.gff3"
    assert_nil GTServer.gff3_errors(valid_gff3)
  end

  def test_errors_on_invalid
    invalid_gff3 = "tmp/~deleteme"
    File.open(invalid_gff3,"w+") {|f| f.puts "nonsense"}
    assert_not_nil GTServer.gff3_errors(invalid_gff3)
    File.delete(invalid_gff3)
  end

  def test_seqids
    seqids =
     %w{X 1 2 5 6 7 8 9 10 11 12 13
        14 15 16 18 19 20 21 22}.map{|n| "chr#{n}"}
    filename = "test/gff3/encode_known_genes_Mar07.gff3"
    # use set as the order is not important
    require 'set'
    assert_equal seqids.to_set, GTServer.gff3_seqids(filename).to_set
  end

  def test_feature_types
    f_types = %w{mRNA gene exon intron TF_binding_site}
    file = "test/gff3/standard_gene_with_introns_as_tree.gff3"
    # use set as the order is not important
    require 'set'
    assert_equal f_types.to_set, GTServer.gff3_feature_types(file).to_set
  end

  def test_range
    file = "test/gff3/little1.gff3"
    assert_equal (1000..9000),
                 GTServer.gff3_range(file, "test1")
  end

  ### module Configuration ###

  def test_config_new
    assert_gt_config GTServer.config_new
  end

  def test_config_default
    assert_gt_config GTServer.config_default
  end

  def test_config_cache
    GTServer.config_uncache(1)
    assert_nil GTServer.config_uncache(1)
    assert !GTServer.config_cached?(1)
    assert_gt_config GTServer.config(1)
    assert GTServer.config_cached?(1)
    assert_not_nil GTServer.config_uncache(1)
  end

  def test_independent_config_changes
    config1 = GTServer.config(1)
    config2 = GTServer.config(2)
    # set margin of config1 to 20 and of config2 to 40
    config1.set_num("format", "margins", 20)
    config2.set_num("format", "margins", 40)
    assert GTServer.config_cached?(1)
    assert GTServer.config_cached?(2)
    assert_not_equal config1.get_num("format", "margins"),
                     config2.get_num("format", "margins")
  end

  def test_color_new
    assert_gt_color GTServer.color_new
  end

  ### module Output ###

  def test_generate_and_destroy
    uuid = UUID.random_create.to_s
    args = uuid, "test/gff3/little1.gff3", "test1", (1000..9000),
           GTServer.config_default, 100, false
    assert !GTServer.img_exists?(uuid)
    assert !GTServer.map_exists?(uuid)
    assert GTServer.img_and_map_generate(*args)
    assert GTServer.img_exists?(uuid)
    assert GTServer.map_exists?(uuid)
    assert_not_nil GTServer.img_and_map_destroy(uuid)
  end

  def test_image
    filename = "test/gff3/standard_gene_with_introns_as_tree.gff3"
    config = GTServer.config_default
    [true, false].each do |add_introns|
      uuid = UUID.random_create.to_s
      GTServer.img_and_map_generate(uuid,
                                    filename,
                                    "ctg123",
                                    (1..1497228),
                                    config,
                                    100,
                                    add_introns)
      png_data = GTServer.img(uuid)
      assert png_data.size > 1000
      assert_equal "PNG", png_data[1..3]
      # teardown:
      GTServer.img_and_map_destroy(uuid)
    end
  end

  def test_image_map
    uuid = UUID.random_create.to_s
    args = uuid, "test/gff3/little1.gff3", "test1", (1000..9000),
           GTServer.config_default, 100, false
    GTServer.img_and_map_generate(*args)
    info = GTServer.map(uuid)
    info.each_hotspot do |a,b,c,d,feat|
      assert_equal [30,100,70,116], [a, b, c, d]
      assert_equal "gene1", feat.get_attribute("ID")
    end
    # teardown:
    GTServer.img_and_map_destroy(uuid)
  end

end
