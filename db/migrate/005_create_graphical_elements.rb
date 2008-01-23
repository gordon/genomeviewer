class CreateGraphicalElements < ActiveRecord::Migration
  def self.up
    create_table :graphical_elements do |t|
      t.string :name
    end
    
    GraphicalElement.create(:name => "stroke")
    GraphicalElement.create(:name => "stroke_marked")
    GraphicalElement.create(:name => "track_title")
    
  end

  def self.down
    drop_table :graphical_elements
  end
end
