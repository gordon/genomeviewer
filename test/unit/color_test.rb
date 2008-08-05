require "test/unit"
require "app/models/color.rb"

class ColorTest < Test::Unit::TestCase

  def test_nof_arguments
    # must be 3
    assert_nothing_raised {Color.new(0.5, 0.5, 0.5)}
    [0,1,2,4].each do |n|
      args = [0.5]*n
      assert_raises(ArgumentError) {Color.new(*args)}
    end
  end
  
  def test_argument_range
    assert_nothing_raised {Color.new(0.0, 0.0, 0.0)}
    assert_nothing_raised {Color.new(0.1, 0.2, 0.3)}
    assert_nothing_raised {Color.new(1.0, 1.0, 1.0)}
    # underflow
    assert_raises(RangeError) {Color.new(-1.0, 0.0, 0.0)}
    assert_raises(RangeError) {Color.new(0.0, -1.0, 0.0)}
    assert_raises(RangeError) {Color.new(0.0, 0.0, -1.0)}
    # overflow
    assert_raises(RangeError) {Color.new(2.0, 1.0, 1.0)}
    assert_raises(RangeError) {Color.new(1.0, 2.0, 1.0)}
    assert_raises(RangeError) {Color.new(1.0, 1.0, 2.0)}
  end
  
  def test_argument_type
    # valid
    assert_nothing_raised {Color.new(1,1,1)}
    assert_nothing_raised {Color.new("0.5","0.5","0.5")}
    # invalid
    assert_raises(ArgumentError) {Color.new("a",1,1)}
    assert_raises(ArgumentError) {Color.new(1,"a",1)}
    assert_raises(ArgumentError) {Color.new(1,1,"a")}
    assert_raises(TypeError) {Color.new(nil,1,1)}
    assert_raises(TypeError) {Color.new(1,nil,1)}
    assert_raises(TypeError) {Color.new(1,1,nil)}
  end
  
  # according to 
  # http://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html
  # aggregations (such as colors) should be value objects:
  #   => immutable 
  #   => equality defined as equality of its fields

  def test_immutable
    assert_raises(NoMethodError) {Color.new(0,0,0).red=0.5}
    assert_raises(NoMethodError) {Color.new(0,0,0).green=0.5}
    assert_raises(NoMethodError) {Color.new(0,0,0).blue=0.5}
  end
  
  def test_equality
    c1 = Color.new(0.0, 0.0, 0.0)
    c2 = Color.new(0.0, 0.0, 0.0)
    assert_not_equal c1.object_id, c2.object_id
    assert_equal c1, c2
    c3 = Color.new(1.0, 1.0, 1.0)
    assert_not_equal c1, c3
  end

end