class SequenceRegion < ActiveRecord::Base
  belongs_to :annotation
  
  # returns the png image representing the sequence region
  def to_png(seq_begin = self.seq_begin, seq_end = self.seq_end)
   temp_file = "tmp/images/#{self.annotation.id}_#{self.id}_#{self.seq_begin}_#{self.seq_end}.png"  
   if generate_png(seq_begin, seq_end, temp_file)   
     png_data = IO.read(temp_file)
     File.delete(temp_file)
     return png_data
   else
     return nil
   end
  end

  private
  
  # use the genometools ruby bindings to generate the png file for the to_png method
  def generate_png(seq_begin, seq_end, output_file)
    begin
        in_stream = GT::GFF3InStream.new(self.annotation.gff3_data_storage)
        feature_index = GT::FeatureIndex.new
        feature_stream = GT::FeatureStream.new(in_stream, feature_index)
        gn = feature_stream.next_tree
        # fill feature index
        while (gn) do
          gn = feature_stream.next_tree
        end

        seqid = feature_index.get_first_seqid
        range = feature_index.get_range_for_seqid(seqid)
        range.start = seq_begin
        range.end = seq_end

        config = GT::Config.new
        diagram = GT::Diagram.new(feature_index, seqid, range, config)
        
        render = GT::Render.new(config)
        render.to_png(diagram, output_file)
        return true
    rescue
        return false
    end
  end

end
