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

  --> the data params[:gff3_file] will be saved in a file
      the rest of the information is saved in the db table

 The filename is automatically calculated as $GFF3_STORAGE_PATH/userid_name

  where:

  * $GFF3_STORAGE_PATH: gives the basis path,
    specified in the config/enviroments files.
    It can be any folder in the filesystem.
  * name is a metadata saved in a column in the database

  --> if the column name is changed, the file is automatically
      renamed after saving the object

  the current filename is given by the method "gff3_data_storage"
  however you should when possible use the following get/set methods
  to access the data:

  * gff3_data
  * gff3_data=()

=end
class Annotation < ActiveRecord::Base

  ### associations ###

  has_many :feature_type_in_annotations
  has_many :feature_types, :through => :feature_type_in_annotations
  has_many :sequence_regions, :dependent => :destroy
  belongs_to :user

  ### encapsulation of the storage mechanism ###

  # the filename where the data is found (or should be saved, by new records) is returned by this method
  # if the flag is set or no filename existed before, the filename is recalculated and stored in the class variable
  def gff3_data_storage(recalculate = false)
    if recalculate or not @gff3_data_storage
     @gff3_data_storage=(permanent_location || temporary_location)
   else
     @gff3_data_storage
   end
  end

  def permanent_location
    return nil if user.nil? or name.nil?
    return nil unless user.valid? and not name.blank?
    "#{$GFF3_STORAGE_PATH}/#{user_id}/#{name}"
  end
  private :permanent_location

  def temporary_location
    @gff3_data_storage ||= "tmp/gff3_data/"+Time.now.to_i.to_s+"_"+rand(10**20).to_s
  end
  private :temporary_location

  ### virtual attributes ###

  def gff3_data
    return nil unless File.exists?(gff3_data_storage)
    File.open(gff3_data_storage).read
  end
  def gff3_data=(data)
    File.open(gff3_data_storage, "w") {|f| f.write(data)}
  end

  ### validations ###

  validates_uniqueness_of :name, :scope => :user_id, :message => " error: you already have a file with this name. Either delete that or rename this."
  validates_presence_of :user

  def validate
    File.exists?(gff3_data_storage) and \
    gff3_data_valid?
  end

  def gff3_data_valid?
    errormsg = GTServer.gff3_errors(File.expand_path(gff3_data_storage))
    if errormsg.nil?
     return true
    else
     File.delete(File.expand_path(gff3_data_storage))
     errors.add_to_base errormsg
     return false
    end
  end

  ### callbacks ###

  after_save       :correct_gff3_file_position
  after_create     :create_sequence_regions
  after_create     :create_feature_types
  before_destroy   :delete_gff3_data

  after_create     :increment_pa_count
  after_destroy    :decrement_pa_count

  def increment_pa_count
    user.increment(:public_annotation_count) if public
  end

  def decrement_pa_count
    user.decrement(:public_annotation_count) if public
  end

  def correct_gff3_file_position
    File.rename gff3_data_storage, gff3_data_storage(:new_name)
  end

  def create_sequence_regions
    get_sequence_regions_params.each do |sequence_region_params|
      sequence_region_params[:annotation_id] = self[:id]
      SequenceRegion.create(sequence_region_params)
    end
  end

  #
  # feature types are added to the annotation list;
  # if they are not present in the user's list they are added
  #
  def create_feature_types
    ft_names = GTServer.gff3_feature_types(File.expand_path(gff3_data_storage))
    ft_names.each do |ft_name|
      ft = user.configuration.feature_types.find_by_name(ft_name)
      unless ft
        ft = FeatureType.default_new(:name => ft_name,
                   :configuration_id => user.configuration.id)
        user.configuration.feature_types(true) # update cache
      end
      feature_types << ft
    end
  end

  def get_sequence_regions_params
    seqids = GTServer.gff3_seqids(File.expand_path(gff3_data_storage))
    parsing_output = []
    seqids.each do |seq_id|
        r = GTServer.gff3_range(File.expand_path(gff3_data_storage), seq_id)
        parsing_output << ({:seq_id => seq_id, :seq_begin => r.first, :seq_end => r.last} )
    end
    return parsing_output
  end
  private :get_sequence_regions_params

  # delete the file containing the data pointed by this object
  def delete_gff3_data
    File.delete(gff3_data_storage)
  end

end
