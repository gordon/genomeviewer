=begin rdoc
Represent an annotation, the content of a gff3 file, and contains 
one or several sequence regions, described by the SequenceRegion model
  
* data currently kept in two positions: 
   * metainformation ==> db-table "annotations"
   * gff3 data       ==> filesystem
   
* the storage of the data in the filesystem is kept transparent to 
  the outside of this class through following two mechanisms:

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
  
  def gff3_data_storage
    return "#{$GFF3_STORAGE_PATH}/#{public? ? 'public' : 'private'}/#{user_id}/#{name}"
  end
  private :gff3_data_storage

  def name=(value)
    if new_record?
      self[:name]=value
    else
      oldname = gff3_data_storage
      self[:name]=value
      newname = gff3_data_storage
      File.rename(oldname, newname)      
    end
  end
  
  def public=(value)
    if new_record?
      self[:public]=value
    else
      oldname = gff3_data_storage
      self[:public]=value
      newname = gff3_data_storage
      # create directory if necessary
      user_dir = File.dirname(newname)
      Dir.mkdir(user_dir) unless File.exists?(user_dir)
      # move file
      File.rename(oldname, newname)  
      # delete old directory if empty 
      # (if not empty it will only raise an error which is ignored -> rescue nil)
      Dir.delete(File.dirname(oldname)) rescue nil      
    end
  end
  
  ### virtual attributes ###
        
  def gff3_data
    return nil unless File.exists?(gff3_data_storage)
    File.open(gff3_data_storage).read
  end
  def gff3_data=(data)
    user_dir = File.dirname(gff3_data_storage)
    Dir.mkdir(user_dir) unless File.exists?(user_dir)
    File.open(gff3_data_storage, "wb") {|f| f.write(data)}
  end
  # see also delete_gff3_data() in the callbacks section 

  # a nice label for the annotation
  def label 
    # (currently: filename without extension)
    File.basename(name, ".*")
  end

  ### validations ###

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
    # these data should come from parser
    parsing_output = [{:seq_id => "NC_003070", :seq_begin => 1, :seq_end => 4294967295}]

    parsing_output.each do |sequence_region| 
      sequence_region[:annotation_id] = self[:id]
      SequenceRegion.create(sequence_region)
    end
  end
  
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
