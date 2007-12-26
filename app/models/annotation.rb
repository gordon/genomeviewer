class Annotation < ActiveRecord::Base

  ### associations ###

  has_many :sequence_regions
  belongs_to :user

  ### virtual attributes ###
  
  # note: The current storage for gff3 data is in the filesystem.
  # 
  # Under the current implementation (filesystem storage),
  # the position and name of the file are stored in the table
  # entries #path and #filename. The code using this model
  # should however avoid to use directly path and filename
  # to allow a simple transition to other kinds of storage.
  # (e.g. drb or database based).
  #
  # Therefore are here defined some virtual columns that 
  # give higher level access to the gff3 data and can be
  # redefined if another kind of implementation is chosen,
  # without having to rewrite the code using them.
  #
  
  # a label for this annotation
  def name 
    # (currently: filename without extension)
    File.basename(filename, ".*")
  end
  
  # currently the position of the file;
  # 
  # in the future it can contain a pointer to the storage
  # location of the data, according to the implementation
  #
  def gff3_data_location
    "#{path}/#{filename}"
  end

  # a filehandle to the file containing the gff3 data
  #
  # if another implementation is chosen, it can return another 
  # kind of pointer to the data or the data itself
  # 
  def gff3_data
    File.open(gff3_data_location)
  end 

  ### validations ###

  def validate
    gff3_data_location_exists? and \
    gff3_data_valid?
  end

  def gff3_data_location_exists?
    File.exists?(gff3_data_location)
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
    File.delete(gff3_data_location)
  end

end
