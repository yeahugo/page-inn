require 'test_helper'

class PagebooksControllerTest < ActionController::TestCase
  setup do
    @pagebook = pagebooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pagebooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pagebook" do
    assert_difference('Pagebook.count') do
      post :create, pagebook: @pagebook.attributes
    end

    assert_redirected_to pagebook_path(assigns(:pagebook))
  end

  test "should show pagebook" do
    get :show, id: @pagebook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pagebook
    assert_response :success
  end

  test "should update pagebook" do
    put :update, id: @pagebook, pagebook: @pagebook.attributes
    assert_redirected_to pagebook_path(assigns(:pagebook))
  end

  test "should destroy pagebook" do
    assert_difference('Pagebook.count', -1) do
      delete :destroy, id: @pagebook
    end

    assert_redirected_to pagebooks_path
  end
end
