#
# helpers for private annotations only;
# see also +AnnotationsHelper+ and +PublicAnnotationsHelper+
#
module OwnAnnotationsHelper
  include AnnotationsHelper

  #
  # an active radio button group to turn on/off an
  # annotation's public bit using AJAX;
  # this helper is used by active_scaffold for the "list" action's table
  #
  def public_column(record)
    make_it_private = remote_function :url => {:action => :file_access_control,
                                               :id => record.id,
                                               :checked => :private}
    make_it_public  = remote_function :url => {:action => :file_access_control,
                                               :id => record.id,
                                               :checked => :public}
    html = ""
    html << (radio_button_tag "access_#{record.id}",
                              "private", !record.public,
                              :id => "access_#{record.id}_private",
                              :onclick => make_it_private)
    html << "Private"
    html << tag(:br)
    html << (radio_button_tag "access_#{record.id}",
                              "public", record.public,
                              :id => "access_#{record.id}_public",
                              :onclick => make_it_public)
    html << "Public"
    return html
  end

  #
  # display the annotation's description and allow to edit it
  # this helper is used by active_scaffold for the "list" action's table
  #
  def description_column(record)
    simple_format(record.description) +
    '<p style="text-align: right; font-size: 80%;">['+
    link_to("edit",
            {"action" => :edit,
             "id" => record.id},
             {:class => "edit action",
              :position => :after})+
    ']</p>'
  end

  #
  # similar to the action view implementation of error_messages_for (*params),
  # with some hardcoded customizations
  #
  def upload_error_messages_for (record)
    object = instance_variable_get("@#{record}")
    count = object.errors.count
    if count.zero?
      return ''
    else
      contents = ''
      contents << content_tag(:h2, "This file could not be uploaded")
      contents << content_tag(:p, 'for the following reason:')
      error_messages = object.errors.
        full_messages.map {|msg| content_tag(:li, msg) }
      contents << content_tag(:ul, error_messages)
      return content_tag(:div, contents,
                         :id => 'errorExplanation',
                         :class => 'errorExplanation')
    end
  end

end
