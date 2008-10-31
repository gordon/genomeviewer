# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # a meaningful html <title>
  # it is used in application layout
  # in the header section
  def title_tag
    @subtitle = ": #@subtitle" if @subtitle
    content_tag :title do
      if !@title
        "GenomeViewer"
      elsif @title =~ /GenomeViewer/
        "#@title#@subtitle"
      elsif @title
        "GenomeViewer - #@title#@subtitle"
      end
    end
  end

end
