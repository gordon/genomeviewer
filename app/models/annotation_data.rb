class AnnotationData < ActiveRecord::Base
  set_table_name :annotation_data

  has_many :annotations
  belongs_to :user

  def validate
    # code for the validation of the GFF3 data, returns a error number > 0 if the data is invalid
    error = 0

    errors.add("GFF3 file","has an invalid format (error #{error})") if error != 0
  end

  after_save :create_annotations

  def create_annotations
    # these data should come from parser
    simulated1 = {:seq_id => "seq1", :seq_begin => 100, :seq_end => 200}
    simulated2 = {:seq_id => "seq2", :seq_begin => 10, :seq_end => 2000}
    annotations = [simulated1, simulated2]

    annotations.each do |a|
      a[:annotation_data_id] = self.id
      Annotation.create(a)
    end
  end

end
