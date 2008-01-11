=begin rdoc
Represent an annotation, the content of a gff3 file, and contains 
one or several sequence regions, described by the SequenceRegion model
  
* data currently kept in two positions: 
   * metainformation ==> db-table "annotations"
   * gff3 data       ==> filesystem
   
* the storage of the data in the filesystem is kept transparent to 
  the outside of this class through following two mechanisms:

 Example usage:

    a = Annotation.new
    a.name = params[:gff3_file].original_filename
    a.user_id = session[:user]
    a.gff3_data = params[:gff3_file] # note: this can be any string
    
  --> the data params[:gff3_file] will be saved in a file with the given name
      the rest of the information is saved in the db table  
            

(1) filename automatically calculated as:
  
  $GFF3_STORAGE_PATH/"public_or_private"/user_id/name
  
  where:
  
  * $GFF3_STORAGE_PATH: gives the basis path, set up in environment.rb
    [note: it can be anywhere in the filesystem]
  * - public annotations are kept under /public/user_id
    - private annotations are kept under /private/user_id
    - if the user_id directory does not exist, it is created
  * name is a metadata saved in a column in the database

  --> if the column name is changed, the file is renamed; see method name=()
  --> if the public flag is set/unset, the file is moved; see method public=()
  
  (the filename is calculated in the private method "gff3_data_storage")

(2) virtual attributes to access the data: 

  * gff3_data 
  * gff3_data=() 
        
        provide I/O access to the data in the file

=end 
class Annotation < ActiveRecord::Base

  ### associations ###

  has_many :sequence_regions
  belongs_to :user
  
  ### encapsulation of the storage mechanism ###
  
  def gff3_data_storage_permanent?
    return false if user.nil? or name.nil?
    user.valid? and not name.blank?
  end
  
  def gff3_data_storage
    if gff3_data_storage_permanent?
      return "#{$GFF3_STORAGE_PATH}/#{public? ? 'public' : 'private'}/#{user_id}/#{name}"
    else
      Dir.mkdir("tmp/gff3_data") unless File.exists?("tmp/gff3_data")
      @tmp ||= "tmp/gff3_data/"+Time.now.to_i.to_s+"_"+rand(10**20).to_s
      return @tmp
    end
  end

  def save_gff3_file_position
    @old_filename = gff3_data_storage
  end

  def correct_gff3_file_position     
    if gff3_data_storage_permanent? and File.exists?(@old_filename)
      # create user directory if necessary
      user_dir = File.dirname(gff3_data_storage)
      Dir.mkdir(user_dir) unless File.exists?(user_dir)
      
      # move file
      File.rename(@old_filename, gff3_data_storage) 

      # delete old directory if empty 
      # (if not empty it will only raise an error which is ignored -> rescue nil)
      Dir.delete(File.dirname(oldname)) rescue nil   
    end
  end
  
  def user=(value)
    save_gff3_file_position
    self[:user_id]=value.id
    correct_gff3_file_position
  end
  
  def user_id=(value)
    save_gff3_file_position
    self[:user_id]=value
    correct_gff3_file_position
  end

  def name=(value)
    save_gff3_file_position
    self[:name]=value
    correct_gff3_file_position
  end
  
  def public=(value)
    save_gff3_file_position
    self[:public]=value
    correct_gff3_file_position   
  end

  ### virtual attributes ###
        
  def gff3_data
    return nil unless File.exists?(gff3_data_storage)
    File.open(gff3_data_storage).read
  end
  def gff3_data=(data)
    storage_dir = File.dirname(gff3_data_storage)
    Dir.mkdir(storage_dir) unless File.exists?(storage_dir)
    File.open(gff3_data_storage, "w") {|f| f.write(data)}
  end
  # see also delete_gff3_data() in the callbacks section 

  # a nice label for the annotation
  def label 
    # (currently: filename without extension)
    File.basename(name, ".*")
  end

  ### validations ###

  validates_presence_of :user

  def validate
    gff3_data_storage_valid? and \
    gff3_data_valid?
  end

  def gff3_data_storage_valid?
    File.exists?(gff3_data_storage)
  end
  
  def gff3_data_valid?
    error = 0
    # code for the validation of the GFF3 data, 
    # returns a error number > 0 if the data is invalid
    if error != 0 
      errors.add("GFF3 file","has an invalid format (error #{error})")
      return false
    else
      return true
    end
  end

  ### callbacks ###
  
  after_save     :create_sequence_regions
  before_destroy :destroy_sequence_regions
  before_destroy :delete_gff3_data
  
  def create_sequence_regions   
    get_sequence_regions_params.each do |sequence_region_params| 
      sequence_region_params[:annotation_id] = self[:id]
      SequenceRegion.create(sequence_region_params)
    end
  end

  def get_sequence_regions_params
    require "gtruby"
    # set up the feature stream
    genome_stream = GT::GFF3InStream.new(gff3_data_storage)
    feature_index = GT::FeatureIndex.new()
    genome_stream = GT::FeatureStream.new(genome_stream, feature_index)
    feature = genome_stream.next_tree()
    while (feature) do
      feature = genome_stream.next_tree()
    end
    # get sequence ids and ranges
    seqids = feature_index.get_seqids
    parsing_output = []
    seqids.each do |seq_id|
        range = feature_index.get_range_for_seqid(seq_id)
        seq_begin = range.start
        seq_end = range.end
        parsing_output << ({:seq_id => seq_id, :seq_begin => seq_begin, :seq_end => seq_end} )        
    end
    return parsing_output
  end
  private :get_sequence_regions_params
  
  # delete cascade behaviour
  def destroy_sequence_regions
     sequence_regions.destroy_all
  end

  # delete the file containing the data pointed by this object
  def delete_gff3_data
    File.delete(gff3_data_storage)
    # delete also directory if empty 
    # (if not empty it will only raise an error which is ignored -> rescue nil)
    Dir.delete(File.dirname(gff3_data_storage)) rescue nil
  end

end
