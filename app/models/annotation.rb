class Annotation < ActiveRecord::Base

  ### associations ###

  has_many :sequence_regions
  belongs_to :user

  ### virtual attributes ###
    
  # currently the storage is in the filesystem:
  # gff3_data is therefore implemented as virtual attribute
  # based on gff3_data_storage, the actual column in the table
  # which currently contains the name of the file where 
  # the data is stored
  
  def gff3_data
    File.open(gff3_data_storage).read
  end 
  def gff3_data=(data)
    File.open(gff3_data_storage, "wb").write(data)
  end
  # see also delete_gff3_data() in the callbacks section 

  # a nice label for the annotation
  def name 
    # (currently: filename without extension)
    File.basename(gff3_data_storage, ".*")
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
  end

end
