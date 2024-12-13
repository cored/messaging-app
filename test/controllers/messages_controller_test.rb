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

	test "should create message as doctor" do
		sign_in @doctor
		assert_difference('Message.count', 1) do
			post messages_path, params: { message: { message: "Hello from Doctor", order_id: @order.id, doctor_id: @doctor.id } }
		end
		assert_redirected_to orders_path
	end

	test "should create message as user" do
		sign_in @user
		assert_difference('Message.count', 1) do
			post messages_path, params: { message: { message: "Hello Doctor", order_id: @order.id, user_id: @user.id } }
		end
		assert_redirected_to orders_path
	end

	test "should create message as customer care" do
		sign_in @customer_care
		assert_difference('Message.count', 1) do
			post messages_path, params: { message: { message: "Hello User", order_id: @order.id, customer_care_id: @customer_care.id } }
		end
		assert_redirected_to orders_path
	end

	test "should not show message to unauthorized user" do
		sign_in @user
		get messages_path
		assert_no_match /Hello from Doctor/, response.body
	end

	test "should show all messages to customer care" do
		sign_in @customer_care
		get messages_path
		assert_match /Hello patient!/, response.body
		assert_match /Hello doctor!/, response.body
	end

	test "should fail to create message with invalid params" do
		sign_in @user
		assert_no_difference('Message.count') do
			post messages_path, params: { message: { message: nil, order_id: @order.id } }
		end
		assert_redirected_to orders_path
		assert_equal "Message failed to send: Message can't be blank", flash[:error]
	end
end
