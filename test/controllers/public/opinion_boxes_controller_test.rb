require "test_helper"

class Public::OpinionBoxesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_opinion_boxes_new_url
    assert_response :success
  end
end
