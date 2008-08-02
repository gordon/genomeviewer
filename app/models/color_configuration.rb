class ColorConfiguration < ActiveRecord::Base

  belongs_to :element, :polymorphic => true
  belongs_to :user

  # returns an hash with the default values from view.lua
  def self.defaults_for(user)
    c = GTServer.default_config_object
    colors = {}
    # as there is no iterator in gtruby
    # try all features and graphical elements
    elements = user.feature_classes +
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
