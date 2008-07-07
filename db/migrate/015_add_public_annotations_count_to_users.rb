#
# The column "public annotations count" is added to cache the number of public 
# annotations present in each record. This simplifies and speeds up the process
# of selecting those users which have a public annotation for listing in the 
# public repository. On the other side it must be incremented/decremented each 
# time the status of an annotation is changed. 
#
class AddPublicAnnotationsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :public_annotations_count, :integer, 
                       :default => 0, :null => false
  end

  def self.down
    remove_column :users, :public_annotations_count
  end
end
