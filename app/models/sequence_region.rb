class SequenceRegion < ActiveRecord::Base
  belongs_to :annotation
  
  # returns the png image representing the sequence region using the gt-ruby bindings
  def to_png(seq_begin = self.seq_begin, seq_end = self.seq_end)
    in_stream = GT::GFF3InStream.new(self.annotation.gff3_data_storage)
    feature_index = GT::FeatureIndex.new
    feature_stream = GT::FeatureStream.new(in_stream, feature_index)
    gn = feature_stream.next_tree
    # fill feature index
    while (gn) do
      gn = feature_stream.next_tree
    end

    range = feature_index.get_range_for_seqid(seq_id)
    range.start = seq_begin
    range.end = seq_end

    config = annotation.user.config
    diagram = GT::Diagram.new(feature_index, seq_id, range, config)
    render = GT::Render.new(config)

    return render.to_png_stream(diagram)
  end

end
