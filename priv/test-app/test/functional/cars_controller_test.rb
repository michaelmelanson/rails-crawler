require 'test_helper'

class CarsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cars)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_car
    assert_difference('Car.count') do
      post :create, :car => { }
    end

    assert_redirected_to car_path(assigns(:car))
  end

  def test_should_show_car
    get :show, :id => cars(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => cars(:one).id
    assert_response :success
  end

  def test_should_update_car
    put :update, :id => cars(:one).id, :car => { }
    assert_redirected_to car_path(assigns(:car))
  end

  def test_should_destroy_car
    assert_difference('Car.count', -1) do
      delete :destroy, :id => cars(:one).id
    end

    assert_redirected_to cars_path
  end
end
