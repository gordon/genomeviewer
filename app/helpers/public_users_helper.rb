module PublicUsersHelper

  def url_column(record)
    auto_link(record.url)
  end
  
end
