module PublicUsersHelper

  def url_column(record)
    auto_link(record.url)
  end

  def name_column(record)
    link_to record.name,
            :controller => :public_annotations,
            :action => :user,
            :username => record.username
  end

end
