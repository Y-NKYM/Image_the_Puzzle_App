require "test_helper"

class Admin::OpinionBoxesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_opinion_boxes_index_url
    assert_response :success
  end

  test "should get edit" do
    get admin_opinion_boxes_edit_url
    assert_response :success
  end
end
