# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_genomeviewer_session_id'
  
  def png_image
    annotation=Annotation.find(params[:annotation])
    sequence_region=annotation.sequence_regions[0]
    send_data(sequence_region.to_png, 
             :type => "image/png", 
             :disposition => "inline", 
             :filename => "#{annotation.name}_#{sequence_region.seq_id}.png")
  end
  
end
