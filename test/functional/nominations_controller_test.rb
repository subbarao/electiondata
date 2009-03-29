require 'test_helper'

class NominationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nominations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nomination" do
    assert_difference('Nomination.count') do
      post :create, :nomination => { }
    end

    assert_redirected_to nomination_path(assigns(:nomination))
  end

  test "should show nomination" do
    get :show, :id => nominations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => nominations(:one).id
    assert_response :success
  end

  test "should update nomination" do
    put :update, :id => nominations(:one).id, :nomination => { }
    assert_redirected_to nomination_path(assigns(:nomination))
  end

  test "should destroy nomination" do
    assert_difference('Nomination.count', -1) do
      delete :destroy, :id => nominations(:one).id
    end

    assert_redirected_to nominations_path
  end
end
