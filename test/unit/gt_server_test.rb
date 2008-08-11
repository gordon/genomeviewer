require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/modules/gt_objects_assertions.rb"

class GtServerTest < ActiveSupport::TestCase
  
  include GTObjectsAssertions

  def test_connection
    assert_nothing_raised {GTServer.test_call}
    assert_not_nil GTServer.test_call
  end

  def test_get_sequence_regions
    seq_ids =
     %w{X 1 2 5 6 7 8 9 10 11 12 13 14 15 16 18 19 20 21 22}.map{|n| "chr#{n}"}
    file = "test/gff3/encode_known_genes_Mar07.gff3"
    # don't test direct array equality as the order is not important:
    response = GTServer.get_sequence_regions(file)
    response.each_with_index{|e, i| response[i]=nil if seq_ids.delete(e)}
    assert response.compact.empty?
    assert seq_ids.empty?
  end

  def test_get_feature_types
    f_types = %w{mRNA gene exon intron TF_binding_site}
    file = "test/gff3/standard_gene_with_introns_as_tree.gff3"
    # don't test direct array equality as the order is not important:
    response = GTServer.get_feature_types(file)
    response.each_with_index{|e, i| response[i]=nil if f_types.delete(e)}
    assert response.compact.empty? 
    assert f_types.empty?
  end

  def test_get_range_for_sequence_region
    file = "test/gff3/little1.gff3"
    assert_equal [1000, 9000],
                 GTServer.get_range_for_sequence_region(file, "test1")
  end

  def test_new_config_object
    assert_nothing_raised {GTServer.new_config_object}
    assert_gt_config GTServer.new_config_object
  end
  
  def test_config_object_for_user
    assert_gt_config GTServer.config_object_for_user(1)
  end

  def test_default_config_object
    assert_gt_config GTServer.default_config_object
  end

  def test_config_cache
    GTServer.config_object_for_user(1, :delete_cache => true)
    assert !GTServer.cached_config_for?(1)
    GTServer.config_object_for_user(1)
    assert GTServer.cached_config_for?(1)
  end

  def test_independent_config_changes
    config1 = GTServer.config_object_for_user(1)
    config2 = GTServer.config_object_for_user(2)
    # set margin of config1 to 20 and of config2 to 40
    config1.set_cstr("format", "margins", 20.to_s)
    config2.set_cstr("format", "margins", 40.to_s)
    assert GTServer.cached_config_for?(1)
    assert GTServer.cached_config_for?(2)
    assert_not_equal config1.get_cstr("format", "margins"),
                     config2.get_cstr("format", "margins")
  end

  def test_new_color_object
    assert_nothing_raised {GTServer.new_color_object}
    assert_gt_color GTServer.new_color_object
  end

  def test_get_image_stream
    file = "test/gff3/encode_known_genes_Mar07.gff3"
    config = GTServer.default_config_object
    [true, false].each do |add_introns|
      png_data = GTServer.get_image_stream(file, "chrX", 122525028, 153939916, config, 100, add_introns)
      assert png_data.size > 1000
      assert_equal "PNG", png_data[1..3]
    end
  end

  def test_get_image_map
    file = "test/gff3/little1.gff3"
    config = GTServer.default_config_object
    info = GTServer.get_image_map(file, "test1", 1000, 9000, config, 100, true)
    info.each_hotspot do |a,b,c,d,feat|
      assert_equal [30,100,70,115], [a, b, c, d]
      assert_equal "gene1", feat.get_attribute("ID")
    end
  end

  #
  # note: GTServer.validate_file() does not raise
  # exceptions, but rather returns nil if the file
  # is valid, an error string otherwise
  #
  def test_validate_valid
    valid_gff3 = "test/gff3/little2.gff3"
    assert_nil GTServer.validate_file(valid_gff3)
  end

  def test_validate_invalid
    invalid_gff3 = "tmp/~deleteme"
    File.open(invalid_gff3,"w+") {|f| f.puts "nonsense"}
    assert_not_nil GTServer.validate_file(invalid_gff3)
    File.delete(invalid_gff3)
  end

  def test_feature_index_caching
    file = "test/gff3/little1.gff3"
    GTServer.get_feature_index_for_file(file, :delete_cache => true)
    assert !GTServer.cached_feature_index_for?(file)
    GTServer.get_feature_index_for_file(file)
    assert GTServer.cached_feature_index_for?(file)
  end

end
