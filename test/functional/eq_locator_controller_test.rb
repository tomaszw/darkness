require File.dirname(__FILE__) + '/../test_helper'
require 'eq_locator_controller'

# Re-raise errors caught by the controller.
class EqLocatorController; def rescue_action(e) raise e end; end

class EqLocatorControllerTest < Test::Unit::TestCase
  def setup
    @controller = EqLocatorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
