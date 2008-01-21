class BrowserController < ApplicationController

 def sidselect
  partial = session[:user] ? "/in_session/navbar" : "/public/navbar"
  @navbar = (render_to_string :partial => partial)
 end

 def browser
  # check params
  
  #begin checking params annotation and seq_id
  unless params[:annotation] and
             params[:seq_id] and
	     Annotation.exists?(params[:annotation].to_i) and
	     SequenceRegion.exists?(params[:seq_id].to_i)
   redirect_to :action => :browserdummy
   return
  end
  #end checking params annotation and seq_id

  sequence_region = SequenceRegion.find(params[:seq_id].to_i)

  #begin checking params start_pos and end_pos
  seq_begin = sequence_region.seq_begin
  seq_end  = sequence_region.seq_end

  redirect_params = params.clone 
  
  unless params[:start_pos] and params[:end_pos]
   redirect_params[:start_pos] = seq_begin
   redirect_params[:end_pos] = seq_end
   redirect_to redirect_params
   return
  end

  if params[:start_pos].to_i < seq_begin then
   redirect_params[:start_pos] = seq_begin
   redirect_to redirect_params
   return
  end

  if params[:start_pos].to_i > seq_end then
   redirect_params[:start_pos] = seq_end-1
   redirect_to redirect_params
   return
  end

  if params[:end_pos].to_i > seq_end then
   redirect_params[:end_pos] = seq_end
   redirect_to redirect_params
   return
  end

  if params[:end_pos].to_i < seq_begin then
   redirect_params[:end_pos] = seq_begin+1
   redirect_to redirect_params
   return
  end
  #end checking params start_pos and end_pos

  render  :layout => false
 end

 def browser_image
  annotation=Annotation.find(params[:annotation])
  sequence_region=SequenceRegion.find(params[:seq_id])
  png_data = sequence_region.to_png(params[:start_pos].to_i,
                                                        params[:end_pos].to_i)
  send_data png_data,
                  :type => "image/png",
                  :disposition => "inline",
                  :filename => "#{annotation.name}_#{sequence_region.seq_id}.png"
 end

 private

 def initialize
  @stylesheets = "in_session"
 end

end
