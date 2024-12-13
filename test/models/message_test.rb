# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  message          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  customer_care_id :integer
#  doctor_id        :integer
#  order_id         :integer          not null
#  user_id          :integer
#
# Indexes
#
#  index_messages_on_doctor_id  (doctor_id)
#  index_messages_on_order_id   (order_id)
#  index_messages_on_user_id    (user_id)
#
# Foreign Keys
#
#  doctor_id  (doctor_id => users.id)
#  order_id   (order_id => orders.id)
#  user_id    (user_id => users.id)
#
require "test_helper"

class MessageTest < ActiveSupport::TestCase
	setup do
		@user = users(:user)
		@doctor = users(:doctor)
		@customer_care = users(:customer_care)
		@order = orders(:one)

		@user_message = Message.create!(message: "User message", order_id: @order.id, user_id: @user.id)
		@doctor_message = Message.create!(message: "Doctor message", order_id: @order.id, doctor_id: @doctor.id)
		@customer_care_message = Message.create!(message: "Customer Care message", order_id: @order.id, customer_care_id: @customer_care.id)
	end

	test "should return user messages" do
		user_messages = Message.user_messages(@user.id)
		assert_includes user_messages, @user_message
		assert_not_includes user_messages, @doctor_message
		assert_not_includes user_messages, @customer_care_message
	end

	test "should return doctor messages" do
		doctor_messages = Message.doctor_messages(@doctor.id)
		assert_includes doctor_messages, @doctor_message
		assert_not_includes doctor_messages, @user_message
		assert_not_includes doctor_messages, @customer_care_message
	end

	test "should return customer care messages" do
		customer_care_messages = Message.customer_care_messages(@customer_care.id)
		assert_includes customer_care_messages, @customer_care_message
		assert_not_includes customer_care_messages, @user_message
		assert_not_includes customer_care_messages, @doctor_message
	end
end
