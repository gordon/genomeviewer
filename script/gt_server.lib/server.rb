$: << ENV['GTRUBY']
require 'gtruby'
require File.dirname(__FILE__)+"/parsing.rb"
require File.dirname(__FILE__)+"/configuration.rb"
require File.dirname(__FILE__)+"/output.rb"

#
# The GTServer forwards requests from the GenomeViewer to the
# GenomeTools Ruby bindings GTRuby.
#
# Additionally it is responsible for caching
# feature_index, config structures and image maps
#
class GTServerClass

  #
  # GTServerClass.new initializes the GTServer, logging output on STDOUT
  # GTServerClass.new(nil) initializes in silent mode (no output logging)
  #
  def initialize(output_buffer = STDOUT)

    @buffer = output_buffer

    log('Initializing GT DRB server...', 0)

    cache_keys =
      [
      :on,  #feature_indeces, add_introns on
      :off, #feature_indeces, add_introns off
      :ft,  #feature_types
      :c,   #config objecs
      :img, #png images
      :map, #image maps of png images
      ]

    @cache = {}
    @mutex_on = {}
    cache_keys.each do |key|
      @cache[key]    = Hash.new
      @mutex_on[key] = Mutex.new
    end

  end

  def log(message, level = 1)
    return if @buffer.nil?
    prefix = level == 0 ? '' : "-"*level+" "
    message = prefix + message
    @buffer.puts(message)
    @buffer.flush
    return message
  end
  private :log

  def lock(cache, &block)
    @mutex_on[cache].synchronize(&block)
  end
  private :lock

  #
  # test the DRb connection
  #
  def test_call
    log    "tast_call() called"
    return "test_call() return value"
  end

  include Parsing

  # public methods:

  # gff3_errors(filename)                 => nil or String (error msg)
  # gff3_feature_types(filename)          => Array of strings
  # gff3_seqids(filename)                 => Array of strings
  # gff3_range(filename, seqid)           => Range
  # gff3_uncache(filename)                => nil or Array of deleted objects
  # feature_index(filename, mode)         => GT::FeatureIndex
  # feature_index_cached?(filename, mode) => true or false
  # feature_types_cached?(filename)       => true or false

  include Configuration

  # public methods:

  # config(key)         => GT::Style
  # config_default      => GT::Style
  # config_new          => GT::Style
  # color_new           => GT::Color
  # config_uncache(key) => nil or GT::Style
  # config_cached?(key) => true or false

  include Output

  # public methods:

  # img_and_map_generate(uuid, filename, => true or false
  #   seq_id, range, config_obj, width,
  #   add_introns, config_override)
  #
  # img(uuid, delete=true)    => String (png image binary)
  # map(uuid, delete=true)    => GT::ImageMap
  # img_and_map_destroy(uuid) => nil or Array of deleted objects
  # img_exists?(uuid)         => true or false
  # map_exists?(uuid)         => true or false

end
