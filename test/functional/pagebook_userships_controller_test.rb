require 'test_helper'

class PagebookUsershipsControllerTest < ActionController::TestCase
  setup do
    @pagebook_usership = pagebook_userships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pagebook_userships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pagebook_usership" do
    assert_difference('PagebookUsership.count') do
      post :create, pagebook_usership: @pagebook_usership.attributes
    end

    assert_redirected_to pagebook_usership_path(assigns(:pagebook_usership))
  end

  test "should show pagebook_usership" do
    get :show, id: @pagebook_usership
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pagebook_usership
    assert_response :success
  end

  test "should update pagebook_usership" do
    put :update, id: @pagebook_usership, pagebook_usership: @pagebook_usership.attributes
    assert_redirected_to pagebook_usership_path(assigns(:pagebook_usership))
  end

  test "should destroy pagebook_usership" do
    assert_difference('PagebookUsership.count', -1) do
      delete :destroy, id: @pagebook_usership
    end

    assert_redirected_to pagebook_userships_path
  end
end
