class Color
  
  Channels = [:red, :green, :blue]
  attr_reader *Channels
  
  def initialize(red, green, blue)
    @red   = Float(red)
    @green = Float(green)
    @blue  = Float(blue)
    raise RangeError, "Color channel value out of range 0..1"\
      unless [@red, @green, @blue].all? {|ch| (0..1).include?(ch)}
  end
  
  def ==(other)
    Channels.all? do |ch|
      return nil unless other.respond_to?(ch)
      send(ch)==other.send(ch)
    end
  end
  
  # returns a reference to a gt ruby 
  # color object with the same colors
  def to_gt
    color = GTServer.new_color_object
    color.red   = @red
    color.green = @green
    color.blue  = @blue
    return color
  end
  
  Kernel.module_eval do 
    #
    # Return a new Color based on an object.
    # Raises an exception if the object does not provide the 
    # proper methods. 
    #
    def Color(x)
      begin
        Color.new(*(Color::Channels.map{|c| x.send(c)}))
      rescue
        raise ArgumentError, "invalid value for Color: #{x.inspect}"
      end
    end
  end
  
end
