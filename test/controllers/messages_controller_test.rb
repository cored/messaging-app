require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	setup do
		@user = users(:user)
		@doctor = users(:doctor)
		@customer_care = users(:customer_care)
		@order = orders(:one)
		sign_in @user
	end

	test "should create message as user" do
		assert_difference('Message.count', 1) do
			post messages_url, params: { message: { message: "Hello doctor!", order_id: @order.id, user_id: @user.id } }
		end
		assert_redirected_to orders_path
	end

	test "should create message as doctor" do
		sign_in @doctor
		assert_difference('Message.count', 1) do
			post messages_url, params: { message: { message: "Hello patient!", order_id: @order.id, doctor_id: @doctor.id } }
		end
		assert_redirected_to orders_path
	end

	test "should create message as customer care" do
		sign_in @customer_care
		assert_difference('Message.count', 1) do
			post messages_url, params: { message: { message: "How can I help?", order_id: @order.id, customer_care_id: @customer_care.id } }
		end
		assert_redirected_to orders_path
	end

	test "should fail to create message with invalid params" do
		assert_no_difference('Message.count') do
			post messages_url, params: { message: { message: "", order_id: @order.id, user_id: @user.id } }
		end
		assert_redirected_to orders_path
	end
end
