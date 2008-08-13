class SequenceRegion < ActiveRecord::Base
  belongs_to :annotation

  # returns the png image representing the sequence region
  def image(seq_begin = self.seq_begin, seq_end = self.seq_end, width = 800)
    gt_server_send(:get_image_stream, seq_begin, seq_end, width)
  end
  
  # returns the image map corresponding to a png image
  def image_map(seq_begin = self.seq_begin, seq_end = self.seq_end, width = 800)
    gt_server_send(:get_image_map, seq_begin, seq_end, width)
  end
  
  private
  
  # connects to the GT server, calling a method on it
  # (tries 3 times at 3 seconds distance, then gives up)
  def gt_server_send(method, seq_begin, seq_end, width)
    i = 0
    begin
      return GTServer.send(method, File.expand_path(self.annotation.gff3_data_storage),
               seq_id, seq_begin, seq_end, annotation.user.configuration.gt, width, annotation.add_introns)
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
