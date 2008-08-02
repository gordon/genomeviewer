class SequenceRegion < ActiveRecord::Base
  belongs_to :annotation

  # returns the png image representing the sequence region using the gt-ruby bindings
  def to_png(seq_begin = self.seq_begin, seq_end = self.seq_end, width = 800)
    i = 0
    begin
      return GTServer.get_image_stream(File.expand_path(self.annotation.gff3_data_storage),
               seq_id, seq_begin, seq_end, annotation.user.config, width, annotation.add_introns)
    rescue => err_msg
      i += 1
      if i < 3 # limit the number of try
        sleep 3 # give time to gt_server to restart
        retry
      else
        raise err_msg
      end
    end
  end

end
