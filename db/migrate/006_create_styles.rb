class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.string :name
    end
    
    Style.create(:name => "line")
    Style.create(:name => "box")
    Style.create(:name => "caret")
    Style.create(:name => "dashes")
    
  end

  def self.down
    drop_table :styles
  end
end
