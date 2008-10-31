#
# common helpers for public and private annotations controllers;
# see also +PublicAnnotationsHelper+ and +OwnAnnotationsHelper+
#
module AnnotationsHelper

  #
  # links to each sequence region of an annotations in the Viewer;
  # this helper is used by active_scaffold for the "list" action's table
  #
  def sequence_regions_column(record)
    record.sequence_regions.map do |sr|
      link_to sr.seq_id,
              :controller => :viewer,
              :username => record.user.username,
              :annotation => record.name,
              :seq_region => sr.seq_id
    end.join(", ")
  end

end