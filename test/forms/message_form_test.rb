require 'test_helper'

class MessageFormTest < ActiveSupport::TestCase
	setup do
		@user = users(:user)
		@doctor = users(:doctor)
		@order = orders(:one)
	end

	test "should be valid with valid attributes" do
		message_form = MessageForm.new(message: "Hello", order_id: @order.id, user_id: @user.id)
		assert message_form.valid?
	end

	test "should not be valid without a message" do
		message_form = MessageForm.new(message: "", order_id: @order.id, user_id: @user.id)
		assert_not message_form.valid?
	end

	test "should assign user_id when user is provided" do
		message_form = MessageForm.new(message: "Hello", order_id: @order.id, user_id: @user.id)
		assert message_form.save
		assert_equal message_form.user_id, @user.id
	end

	test "should assign doctor_id when doctor is provided" do
		message_form = MessageForm.new(message: "Hello", order_id: @order.id, doctor_id: @doctor.id)
		assert message_form.save
		assert_equal message_form.doctor_id, @doctor.id
	end

	test "should assign customer_care_id when customer care is provided" do
		message_form = MessageForm.new(message: "Hello", order_id: @order.id, customer_care_id: @user.id)
		assert message_form.save
		assert_equal message_form.customer_care_id, @user.id
	end
end
