require File.dirname(__FILE__) + '/../test_helper'
require 'party_editor_controller'

# Re-raise errors caught by the controller.
class PartyEditorController; def rescue_action(e) raise e end; end

class PartyEditorControllerTest < Test::Unit::TestCase
  def setup
    @controller = PartyEditorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
