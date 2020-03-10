require File.dirname(__FILE__) + '/../test_helper'
require 'transfers_controller'

# Re-raise errors caught by the controller.
class TransfersController; def rescue_action(e) raise e end; end

class TransfersControllerTest < Test::Unit::TestCase
  def setup
    @controller = TransfersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
