class MessageForm
	include ActiveModel::Model

	attr_accessor :message, :order_id, :user_id, :doctor_id, :customer_care_id

	validates :message, presence: true
	validates :order_id, presence: true

	def initialize(attributes = {})
		super(attributes)
	end

	def save
		return false if invalid?

		message = Message.new(message_params)
		if message.save
			true
		else
			false
		end
	end

	private

	def message_params
		{
			message: message,
			order_id: order_id,
			user_id: user_id,
			doctor_id: doctor_id,
			customer_care_id: customer_care_id
		}.tap do |params|
			assign_user_role(params)
		end
	end

	def assign_user_role(params)
		if user_id
			params[:user_id] = user_id
		elsif doctor_id
			params[:doctor_id] = doctor_id
		elsif customer_care_id
			params[:customer_care_id] = customer_care_id
		end
	end
end
