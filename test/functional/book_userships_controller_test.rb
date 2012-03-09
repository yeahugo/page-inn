#require 'test_helper'
#
#class BookUsershipsControllerTest < ActionController::TestCase
#  setup do
#    @book_usership = book_userships(:one)
#  end
#
#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:book_userships)
#  end
#
#  test "should get new" do
#    get :new
#    assert_response :success
#  end
#
#  test "should create book_usership" do
#    assert_difference('BookUsership.count') do
#      post :create, book_usership: @book_usership.attributes
#    end
#
#    assert_redirected_to book_usership_path(assigns(:book_usership))
#  end
#
#  test "should show book_usership" do
#    get :show, id: @book_usership
#    assert_response :success
#  end
#
#  test "should get edit" do
#    get :edit, id: @book_usership
#    assert_response :success
#  end
#
#  test "should update book_usership" do
#    put :update, id: @book_usership, book_usership: @book_usership.attributes
#    assert_redirected_to book_usership_path(assigns(:book_usership))
#  end
#
#  test "should destroy book_usership" do
#    assert_difference('BookUsership.count', -1) do
#      delete :destroy, id: @book_usership
#    end
#
#    assert_redirected_to book_userships_path
#  end
#end
