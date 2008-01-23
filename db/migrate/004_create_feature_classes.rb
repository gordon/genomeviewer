class CreateFeatureClasses < ActiveRecord::Migration
  def self.up
    create_table :feature_classes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :feature_classes
  end
end
