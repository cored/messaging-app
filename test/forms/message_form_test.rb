class MessageFormTest < ActiveSupport::TestCase
	test "should be valid with valid attributes" do
		message_form = MessageForm.new(message: "Hello", order_id: 1, user_id: 1)
		assert message_form.valid?
	end

	test "should not be valid without a message" do
		message_form = MessageForm.new(message: "", order_id: 1, user_id: 1)
		assert_not message_form.valid?
	end

	test "should assign user_id when user is provided" do
		message_form = MessageForm.new(message: "Hello", order_id: 1, user_id: 1)
		message_form.save
		assert_equal message_form.message.user_id, 1
	end

	test "should assign doctor_id when doctor is provided" do
		message_form = MessageForm.new(message: "Hello", order_id: 1, doctor_id: 1)
		message_form.save
		assert_equal message_form.message.doctor_id, 1
	end

	test "should assign customer_care_id when customer care is provided" do
		message_form = MessageForm.new(message: "Hello", order_id: 1, customer_care_id: 1)
		message_form.save
		assert_equal message_form.message.customer_care_id, 1
	end
end
