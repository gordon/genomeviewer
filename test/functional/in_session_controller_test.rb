require File.dirname(__FILE__) + '/../test_helper'
require 'in_session_controller'

# Re-raise errors caught by the controller.
class InSessionController; def rescue_action(e) raise e end; end

class InSessionControllerTest < Test::Unit::TestCase
  def setup
    @controller = InSessionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
