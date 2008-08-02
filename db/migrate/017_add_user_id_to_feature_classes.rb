#
# This allows to add feature classes on a per-user base;
# the user is optional; user_id null means the feature class is global 
# (i.e. for all user)
#
class AddUserIdToFeatureClasses < ActiveRecord::Migration

  def self.up
    add_column :feature_classes, :user_id, :integer, :default => nil
  end
  
  def self.down
    remove_column :feature_classes, :user_id
  end

end