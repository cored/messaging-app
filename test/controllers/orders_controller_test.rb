require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	setup do
		@user = users(:one)
		sign_in @user
		@order = orders(:one)
	end

	test "should get index" do
		get orders_url
		assert_response :success
	end

	test "should get new" do
		get new_order_url
		assert_response :success
	end

	test "should create order" do
		assert_difference("Order.count") do
			post orders_url, params: { order: { order_items: 'Medication', total: 9.99, doctor_id: users(:doctor).id, user_id: @user.id } }
		end
		assert_redirected_to order_url(Order.last)
	end

	test "should show order" do
		get order_url(@order)
		assert_response :success
	end

	test "should get edit" do
		get edit_order_url(@order)
		assert_response :success
	end

	test "should update order" do
		patch order_url(@order), params: { order: { order_items: 'Updated Medication', total: 15.99 } }
		assert_redirected_to order_url(@order)
		@order.reload
		assert_equal 'Updated Medication', @order.order_items
		assert_equal 15.99, @order.total
	end

	test "should destroy order" do
		assert_difference("Order.count", -1) do
			delete order_url(@order)
		end
		assert_redirected_to orders_url
	end
end
