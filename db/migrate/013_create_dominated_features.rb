class CreateDominatedFeatures < ActiveRecord::Migration
  def self.up
    create_table :dominated_features do |t|
      t.belongs_to :domination_configuration
      t.references :feature_class
    end
  end

  def self.down
    drop_table :dominated_features
  end
end
