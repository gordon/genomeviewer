module GTObjectsAssertions

  #
  # "duck type" check if an object could be a GT::Config
  #
  def assert_gt_config(obj, message = nil)
    message ||= "It does not look like a GT::Config"
    assert_block(message) do 
      types = ["bool", "color", "cstr", "num"]
      methods = (["get","set"].map {|a| types.map {|t| "#{a}_#{t}"}}).flatten
      methods << "load_file"
      methods << "unset"
      methods.all?{|m| obj.respond_to?(m)}
    end
  end

  #
  # "duck type" check if an object could be a GT::Color
  #
  def assert_gt_color(obj, message = nil)
    message ||= "It does not look like a GT::Color"
    assert_block(message) do 
      methods = ["red","green","blue","red=","green=","blue="]
      methods.all?{|m| obj.respond_to?(m)}
    end    
  end
  
end