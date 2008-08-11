class Style

  def initialize(key)
    @key = ([1,2,3,4].include?(key.to_i) ? key.to_i : nil)
  end
 
  attr_reader :key
 
  def string
    case key 
      when 1 : "box"
      when 2 : "caret"
      when 3 : "dashes"
      when 4 : "line"
      else
        "undefined"
    end
  end
  
  alias_method :to_s, :string
 
  def ==(other)
    return nil unless other.respond_to?(:key)
    @key == other.key
  end
  
  String.class_eval do
    
    def to_style
      key = 
        case self
          when "box" : 1
          when "caret" : 2
          when "dashes" : 3
          when "line" : 4
        else
          nil
        end
      Style.new(key)
    end
    
  end
  
end
