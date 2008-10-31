require File.dirname(__FILE__) + '/../test_helper'

class GTRubyConfiguratorTest < ActiveSupport::TestCase

  def setup
    @section = {}
    @section['format'] = Format.new
    @section['exon']   = FeatureType.new(:name => "exon")
    @conf = Configuration.new do |conf|
              conf.format = @section['format']
              conf.feature_types << @section['exon']
            end
    @section['format'].configuration = @conf
    @section['format'].save
    @gt = GTServer.config(@conf.id)
  end

  ### instance methods defined by set_section ###

  def test_section
    assert_equal 'format', @section['format'].section
    assert_equal 'exon',   @section['exon'].section
  end

  [:local, :remote, :default].each do |x|
    define_method "test_#{x}" do
      assert_kind_of Hash, @section['format'].send(x)
      assert !@section['format'].send(x).keys.empty?
      assert_kind_of Hash, @section['exon'].send(x)
      assert !@section['exon'].send(x).keys.empty?
    end
  end

  def test_sync
    @section['format'][:margins] = 77
    assert !@section['format'].sync?
    @section['exon'][:max_num_lines] = 77
    assert !@section['exon'].sync?
    remote_value = GTServer.config(@conf.id).get_num("exon", "max_num_lines")
    assert @section['exon'].not_sync.include?([:max_num_lines, 77, remote_value])
  end

  [:upload, :download].each do |x|
    define_method "test_#{x}" do
      @section['format'][:margins] = 77
      assert !@section['format'].sync?
      @section['format'].send(x)
      assert @section['format'].sync?
      @section['exon'][:max_num_lines] = 77
      assert !@section['exon'].sync?
      @section['exon'].send(x)
      assert @section['exon'].sync?
    end
  end

  ### instance methods defined by set_<config_type> ###

  test_fixtures = [
    {:type => "decimals", :section => "format", :gtrget => :get_num,
     :attr => "margins", :value => 1000.0, :undefined => nil},
    {:type => "bools", :section => "format", :gtrget => :get_bool,
     :attr => "show_grid", :value => false, :undefined => nil},
    {:type => "colors", :section => "format", :gtrget => :get_color,
     :attr => "track_title_color", :value => Color.new(1.0, 1.0, 1.0),
     :undefined => Color.undefined},
    {:type => "colors", :section => "exon", :gtrget => :get_color,
     :attr => "fill", :value => Color.new(1.0, 1.0, 1.0),
     :undefined => Color.undefined},
    {:type => "bools", :section => "exon", :gtrget => :get_bool,
     :attr => "split_lines", :value => false, :undefined => nil},
    {:type => "integers", :section => "exon", :gtrget => :get_num,
     :attr => "max_num_lines", :value => 999, :undefined => nil},
    {:type => "styles", :section => "exon", :gtrget => :get_cstr,
     :attr => "style", :value => "caret".to_style,
     :undefined => Style.undefined}
  ]

  test_fixtures.each do |x|

    define_method "test_remote_get_#{x[:section]}_#{x[:type]}" do
      case x[:type]
      when "colors"
        assert_equal Color(@gt.send(x[:gtrget], x[:section], x[:attr])),
                     @section[x[:section]].send("remote_#{x[:attr]}")
      when "styles"
        assert_equal @gt.send(x[:gtrget], x[:section], x[:attr]).to_style,
                     @section[x[:section]].send("remote_#{x[:attr]}")
      else
        assert_equal @gt.send(x[:gtrget], x[:section], x[:attr]),
                     @section[x[:section]].send("remote_#{x[:attr]}")
      end
    end

    define_method "test_remote_set_#{x[:section]}_#{x[:type]}" do
      assert_not_equal x[:value],
                       @section[x[:section]].send("remote_#{x[:attr]}")
      # test return value:
      case x[:type]
      when "colors"
        assert_equal x[:value],
                     Color(@section[x[:section]].send("remote_#{x[:attr]}=",
                                                      x[:value]))
      when "styles"
        assert_equal x[:value].to_s,
                @section[x[:section]].send("remote_#{x[:attr]}=", x[:value])
      else
        assert_equal x[:value],
                @section[x[:section]].send("remote_#{x[:attr]}=", x[:value])
      end
      # test side effect:
      assert_equal x[:value], @section[x[:section]].send("remote_#{x[:attr]}")
    end

    define_method "test_sync_set_#{x[:section]}_#{x[:type]}" do
      assert_not_equal x[:value],
                       @section[x[:section]].send(x[:attr])
      assert_not_equal x[:value],
                       @section[x[:section]].send("remote_#{x[:attr]}")
      # test return value:
      assert_equal x[:value],
                   @section[x[:section]].send("sync_#{x[:attr]}=", x[:value])
      # test side effect:
      assert_equal x[:value], @section[x[:section]].send(x[:attr])
      assert_equal x[:value], @section[x[:section]].send("remote_#{x[:attr]}")
    end

    define_method "test_sync_unset_#{x[:section]}_#{x[:type]}" do
      value = (x[:type] == "bools") ? true : x[:value]
      @section[x[:section]].send("sync_#{x[:attr]}=", value)
      assert_not_equal x[:undefined],
                       @section[x[:section]].send(x[:attr])
      assert_not_equal x[:undefined],
                       @section[x[:section]].send("remote_#{x[:attr]}")
      # test return value:
      assert_equal x[:undefined],
                   @section[x[:section]].send("sync_#{x[:attr]}=", nil)
      # test side effect:
      assert_equal x[:undefined],
                   @section[x[:section]].send(x[:attr])
      assert_equal x[:undefined],
                   @section[x[:section]].send("remote_#{x[:attr]}")
    end

    define_method "test_sync_test_#{x[:section]}_#{x[:type]}" do
      assert_equal x[:value],
                   @section[x[:section]].send("sync_#{x[:attr]}=", x[:value])
      assert @section[x[:section]].send("#{x[:attr]}_sync?")
    end

    define_method "test_upload_#{x[:section]}_#{x[:type]}" do
      @section[x[:section]].send("#{x[:attr]}=", x[:value])
      assert !@section[x[:section]].send("#{x[:attr]}_sync?")
      # test return value
      case x[:type]
      when "colors"
        assert_equal x[:value],
                     Color(@section[x[:section]].send("upload_#{x[:attr]}"))
      when "styles"
        assert_equal x[:value].to_s,
                     @section[x[:section]].send("upload_#{x[:attr]}")
      else
        assert_equal x[:value],
                     @section[x[:section]].send("upload_#{x[:attr]}")
      end
      # test side effects
      assert_equal x[:value],
                   @section[x[:section]].send("remote_#{x[:attr]}")
      assert @section[x[:section]].send("#{x[:attr]}_sync?")
    end

    define_method "test_download_#{x[:section]}_#{x[:type]}" do
      @section[x[:section]].send("remote_#{x[:attr]}=", x[:value])
      assert !@section[x[:section]].send("#{x[:attr]}_sync?")
      # test return value
      assert_equal x[:value],
                   @section[x[:section]].send("download_#{x[:attr]}")
      # test side effects
      assert_equal x[:value], @section[x[:section]].send(x[:attr])
      assert @section[x[:section]].send("#{x[:attr]}_sync?")
    end

    define_method "test_default_#{x[:section]}_#{x[:type]}" do
      assert_not_nil @section[x[:section]].send("default_#{x[:attr]}")
    end

  end

end
