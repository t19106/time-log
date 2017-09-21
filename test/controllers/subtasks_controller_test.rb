require 'test_helper'

class SubtasksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get subtasks_create_url
    assert_response :success
  end

end
