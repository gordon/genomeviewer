class Color
  
  Channels = [:red, :green, :blue]
  attr_reader *Channels
  
  def initialize(red, green, blue)
    @red   = Float(red)
    @green = Float(green)
    @blue  = Float(blue)
    raise RangeError, "Color component value outside [0..1]"\
      unless [@red, @green, @blue].all? {|x| x >= 0 and x <= 1}
  end
  
  def ==(other)
    Channels.all? do |comp|
      return nil unless other.respond_to?(comp)
      send(comp)==other.send(comp)
    end
  end
  
end