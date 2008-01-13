class BrowserController < ApplicationController

 def sidselect
  @navbar = (render_to_string :partial => "/in_session/navbar")
 end

 def browser
  # check params

  #begin checking params annotation and seq_id
  if not params[:annotation] or not params[:seq_id]
   redirect_to :action => :browserdummy
   return
  end

  begin
  Annotation.find(params[:annotation].to_i)
  rescue
   redirect_to :action => :browserdummy
   return
  end

  if not Annotation.find(params[:annotation].to_i).sequence_regions.find(params[:seq_id].to_i)
   redirect_to :action => :browserdummy
   return
  end
  #end checking params annotation and seq_id

  #begin checking params start_pos and end_pos
  seqStartPos= Annotation.find(params[:annotation]).sequence_regions.find(params[:seq_id].to_i).seq_begin
  seqEndPos  = Annotation.find(params[:annotation]).sequence_regions.find(params[:seq_id].to_i).seq_end

  if not params[:start_pos] or not params[:end_pos]
   redirect_to :action => :browser, :annotation => params[:annotation], :seq_id => params[:seq_id],\
    :start_pos => seqStartPos,\
    :end_pos => seqEndPos
   return
  end


  if params[:start_pos].to_i < seqStartPos then
   redirect_to :action => :browser,
               :annotation => params[:annotation],\
               :seq_id => params[:seq_id],\
               :start_pos => seqStartPos,\
               :end_pos => params[:end_pos]
   return
  end

  if params[:start_pos].to_i > seqEndPos then
   redirect_to :action => :browser, :annotation => params[:annotation], :seq_id => params[:seq_id],\
    :start_pos => seqEndPos-1,\
    :end_pos => params[:end_pos]
   return
  end

  if params[:end_pos].to_i > seqEndPos then
   redirect_to :action => :browser, :annotation => params[:annotation], :seq_id => params[:seq_id],\
    :start_pos => params[:start_pos],\
    :end_pos => seqEndPos
   return
  end

  if params[:end_pos].to_i < seqStartPos then
   redirect_to :action => :browser, :annotation => params[:annotation], :seq_id => params[:seq_id],\
    :start_pos => params[:start_pos],\
    :end_pos => seqStartPos+1
   return
  end
  #end checking params start_pos and end_pos


 end



 def browser_image
  annotation=Annotation.find(params[:annotation])
  sequence_region=SequenceRegion.find(params[:seq_id])
  png_data = 
  sequence_region.to_png(params[:start_pos].to_i,params[:end_pos].to_i)
  send_data(png_data,
            :type => "image/png",
            :disposition => "inline",
            :filename => "#{annotation.name}_#{sequence_region.seq_id}.png"
           )
 end


end
