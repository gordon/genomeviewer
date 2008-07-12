class BrowserController < ApplicationController

 prepend_before_filter :check_permissions

 def check_permissions
   @annotation = Annotation.find(params[:annotation])
   if !@annotation.public and
      @annotation.user.id != session[:user].to_i
     flash[:errors] = "Private annotations can be browsed only by their owners."
     redirect_to :controller => :default, :action => :index
   end
 end

 def seq_id_select
  @annotation = Annotation.find(params[:annotation])
  @sequence_regions = @annotation.sequence_regions
  @width = session[:user] ? User.find(session[:user]).width : @annotation.user.width
  @seq_ids_per_line = 10
 end

 def browser
  # check params

  #begin checking params annotation and seq_region
  unless params[:annotation] and
             params[:seq_region] and
	     Annotation.exists?(params[:annotation].to_i) and
	     SequenceRegion.exists?(params[:seq_region].to_i)
   redirect_to :action => :empty_browser
   return
  end
  #end checking params annotation and seq_region

  sequence_region = SequenceRegion.find(params[:seq_region].to_i)

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

  @width = User.find(session[:user]).width rescue sequence_region.annotation.user.width
  render  :layout => false
 end

 def browser_image
  annotation=Annotation.find(params[:annotation])
  user = User.find(session[:user]) rescue annotation.user
  sequence_region=SequenceRegion.find(params[:seq_region])
  png_data = sequence_region.to_png(params[:start_pos].to_i,
                                                        params[:end_pos].to_i, user.width)
  send_data png_data,
                  :type => "image/png",
                  :disposition => "inline",
                  :filename => "#{annotation.name}_#{sequence_region.seq_id}.png"
 end

end
