require File.dirname(__FILE__) + '/../test_helper'
require 'eq_controller'

# Re-raise errors caught by the controller.
class EqController; def rescue_action(e) raise e end; end

class EqControllerTest < Test::Unit::TestCase
  def setup
    @controller = EqController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
