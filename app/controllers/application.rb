# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_genomeviewer_session_id'
  
  # sends the png data directly to the browser
  #
  # can be moved to the controller that really uses it
  # 
  # usage: image_tag(url_for(:action =>:png_image, :annotation => ..., 
  #                          :sequence_region => ..., :seq_begin => ..., :seq_end => ...)
  def png_image
    annotation=Annotation.find(params[:annotation])
    sequence_region=SequenceRegion.find(params[:sequence_region])
    png_data = sequence_region.to_png(params[:seq_begin].to_i,params[:seq_end].to_i)
    send_data(png_data, 
             :type => "image/png", 
             :disposition => "inline", 
             :filename => "#{annotation.name}_#{sequence_region.seq_id}.png")
  end
  
end
