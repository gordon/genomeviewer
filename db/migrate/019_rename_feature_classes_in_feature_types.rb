#
# nomenclature change to use Genometools one
#
class RenameFeatureClassesInFeatureTypes < ActiveRecord::Migration
  def self.up
    rename_table :feature_classes, :feature_types
  end
  
  def self.down
    rename_table :feature_types, :feature_classes
  end
end