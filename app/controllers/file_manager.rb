module FileManager

 def do_upload
  @annotation = Annotation.new
  @annotation.name = params[:gff3_file].original_filename
  @annotation.user_id = session[:user]
  @annotation.description = params[:description] 
  @annotation.gff3_data = params[:gff3_file].read
  if @annotation.save
   flash[:notice] = "Successfully uploaded"
  else
   flash[:errors] = @annotation.errors.on_base
  end
  redirect_to :action => "upload"
 end

 def change_annotation_description
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.description=params[:description]
   annotation.save
  end
  redirect_to :action => "file_manager"
 end

 def file_delete
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.destroy
  end
  redirect_to :action => "file_manager"
 end

 def file_accessibility
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from modifying own data
  if annotation.user.id == session[:user]
   annotation.public=params[:public]
   annotation.save
  end
  redirect_to :action => "file_manager"
 end

end