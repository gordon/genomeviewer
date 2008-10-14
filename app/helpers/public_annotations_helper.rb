#
# helpers for public annotations only; 
# see also +AnnotationsHelper+ and +OwnAnnotationsHelper+
#
module PublicAnnotationsHelper
  include AnnotationsHelper

  #
  # links to an user page (i.e. his public annotations list);
  # this helper is used by active_scaffold for the "list" action's table
  #
  def user_column(record)
    link_to record.user.name, 
            :controller => :public_annotations, 
            :action => :user, 
            :username => record.user.username
  end
  
  #
  # allows simple_format markup to be recognized by displaying an annotation's
  # description; 
  # this helper is used by active_scaffold for the "list" action's table
  #
  def description_column(record)
    simple_format(record.description)
  end

end