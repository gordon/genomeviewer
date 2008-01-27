class ColorConfiguration < ActiveRecord::Base
  
  belongs_to :element, :polymorphic => true
  belongs_to :user
  
  # returns an hash with the default values from view.lua
  def self.defaults
    c = GTSvr.getConfigObject
    c.load_file(File.expand_path("config/view.lua"))
    colors = {}
    # as there is no iterator yet in gtruby 
    # try all features and graphical elements
    elements = FeatureClass.find(:all) + 
                  GraphicalElement.find(:all)
    elements.map(&:name).each do |e| 
      # if e did not exist 0.8 is returned for all colors
      # (default gray color)
      colors[e] = {}
      [:red, :green, :blue].each do |rgb|
        colors[e][rgb] = c.get_color(e).send(rgb)
      end
    end
    return colors
  end
  
end
