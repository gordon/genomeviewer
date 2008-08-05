class Color
  
  attr_reader :red, :green, :blue
  
  def initialize(red, green, blue)
    @red   = Float(red)
    @green = Float(green)
    @blue  = Float(blue)
    raise RangeError, "Color component value outside [0..1]"\
      unless [@red, @green, @blue].all? {|x| x >= 0 and x <= 1}
  end
  
  def ==(other)
    @red   == other.red and
    @green == other.green and 
    @blue  == other.blue
  end
  
end