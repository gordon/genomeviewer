class CreateFeatureTypeInAnnotations < ActiveRecord::Migration

  def self.up
    create_table :feature_type_in_annotations do |t|
      t.belongs_to :annotation
      t.belongs_to :feature_type
      t.boolean :show, :default => true, :null => false
    end
  end
  
  def self.down
    drop_table :feature_type_in_annotations
  end

end
