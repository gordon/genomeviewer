class Style

  DefinedStyles = 
    {
      1 => "box",
      2 => "caret",
      3 => "dashes",
      4 => "line"
    }

  def initialize(key)
    @key = ([1,2,3,4].include?(key.to_i) ? key.to_i : nil)
  end
 
  attr_reader :key
 
  def string
    DefinedStyles.fetch(key, "undefined")
  end
  
  alias_method :to_s, :string
 
  def ==(other)
    return nil unless other.respond_to?(:key)
    @key == other.key
  end
  
  String.class_eval do
    
    def to_style
      Style.new(Style::DefinedStyles.index(self))
    end
    
  end
  
end
