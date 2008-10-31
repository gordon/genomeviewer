class Color

  Channels = [:red, :green, :blue]
  attr_reader *Channels

  def initialize(red, green, blue)
    begin
      @red   = Float(red)
      @green = Float(green)
      @blue  = Float(blue)
    rescue
      @red = @green = @blue = nil
    else
      raise RangeError, "Color channel value out of range 0..1"\
        unless [@red, @green, @blue].all? {|ch| (0..1).include?(ch)}
    end
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
    color = GTServer.color_new
    color.red   = @red
    color.green = @green
    color.blue  = @blue
    return color
  end

  # return the corresponding 24 bit hexadecimal color code string
  def to_hex
    return "undefined" if undefined?
    "#"+Channels.map{|c| sprintf("%02X",(send(c) * 255).round)}.join
  end
  alias_method :to_s, :to_hex

  def undefined?
    [@red, @green, @blue].any?(&:nil?)
  end

  def self.undefined
    new(nil, nil, nil)
  end

  Kernel.module_eval do
    #
    # Return a new Color based on an object.
    # Raises an exception if the object does not provide the
    # proper methods.
    #
    def Color(x)
      return Color.undefined if x.nil?
      begin
        Color.new(*(Color::Channels.map{|c| x.send(c)}))
      rescue
        raise ArgumentError, "invalid value for Color: #{x.inspect}"
      end
    end
  end

  String.class_eval do

    # Convert a string containing a valid 24 bit hex code
    # in an instance of the Color class.
    # Anything invalid returns the undefinite color.
    def to_color
      m = match(/^#([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/)
      if m
        Color.new(*[m[1],m[2],m[3]].map{|x|x.to_i(16)/255.0})
      else
        Color.undefined
      end
    end

  end

end
