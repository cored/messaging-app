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


class Message < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', optional: true
	belongs_to :order
	belongs_to :customer_care, class_name: 'User', foreign_key: 'customer_care_id', optional: true

	scope :user_messages, ->(user_id) { where(user_id: user_id) }
	scope :doctor_messages, ->(doctor_id) { where(doctor_id: doctor_id) }
	scope :customer_care_messages, ->(customer_care_id) { where(customer_care_id: customer_care_id) }

	default_scope { order(created_at: :desc) }
end
