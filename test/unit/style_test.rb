require "test/unit"
require "app/models/style.rb"

class StyleTest < Test::Unit::TestCase

  def test_initialize
    assert_raises(ArgumentError) { Style.new() }
    [1, 2, 3.0, "4"].each {|n| assert_not_nil Style.new(n).key}
    [nil, "a", 0, 5].each {|x| assert_nil     Style.new(x).key}
  end

  def test_string
    s = Style.new(1)
    assert_equal "box", s.string
    assert_equal "box", s.to_s
    s = Style.new(nil)
    assert_equal "undefined", s.string
  end
  
  # according to 
  # http://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html
  # aggregations (such as colors) should be value objects:
  #   => immutable 
  #   => equality defined as equality of its fields

  def test_immutable
    assert_raises(NoMethodError) {Style.new(1).key=2}
  end
  
  def test_equality
    s1 = Style.new(1)
    assert_equal s1, s1
    s2 = Style.new(1)
    assert_not_equal s1.object_id, s2.object_id
    assert_equal s1, s2
    s3 = Style.new(2)
    assert_not_equal s1, s3
    assert_not_nil s1==s3
    assert_nil s1=="string"
    assert_not_equal s1, "string"
  end
  
end