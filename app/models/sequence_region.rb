class SequenceRegion < ActiveRecord::Base
  belongs_to :annotation
  
  def picture(seq_begin = self.seq_begin, seq_end = self.seq_end)
   #
 end

end
