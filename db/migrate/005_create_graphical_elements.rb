class CreateGraphicalElements < ActiveRecord::Migration
  def self.up
    create_table :graphical_elements do |t|
      :name
    end
    
    GraphicalElement.create("stroke")
    GraphicalElement.create("stroke_marked")
    GraphicalElement.create("track_title")
    
  end

  def self.down
    drop_table :graphical_elements
  end
end
