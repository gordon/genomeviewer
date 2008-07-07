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
  user=User.find(session[:user])
  # prevent others from modifying own data
  if annotation.user == user
   previously_public = annotation.public
   annotation.public = params.has_key?(:public)
     if annotation.public
      user.increment(:public_annotations_count) unless previously_public        
     else # private
      user.decrement(:public_annotations_count) if previously_public
     end
   ActiveRecord::Base.transaction do 
     user.save
     annotation.save
    end
  end
  redirect_to :action => "file_manager"
 end

end
