class SequenceRegion < ActiveRecord::Base
  belongs_to :annotation

  # returns the png image representing the sequence region using the gt-ruby bindings
  def to_png(seq_begin = self.seq_begin, seq_end = self.seq_end, width = 800)

    return GTSvr.getImageStream(File.expand_path(self.annotation.gff3_data_storage), seq_id, seq_begin, seq_end, annotation.user.config, width)
    return render.to_png_stream(diagram, width)

  end

end
