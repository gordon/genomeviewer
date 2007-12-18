class Annotation < ActiveRecord::Base

  has_many :sequence_regions
  belongs_to :user

  def validate
    error = 0
    # code for the validation of the GFF3 data, returns a error number > 0 if the data is invalid
    errors.add("GFF3 file","has an invalid format (error #{error})") if error != 0
  end

  after_save :create_sequence_regions

  def create_sequence_regions
    # these data should come from parser
    parsing_output = [{:seq_id => "NC_003070", :seq_begin => 1, :seq_end => 4294967295}]

    parsing_output.each do |sequence_region|
      sequence_region[:annotation_id] = self.id
      SequenceRegion.create(sequence_region)
    end
  end

end
