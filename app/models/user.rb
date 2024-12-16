# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  credit_card_number     :string
#  cvv                    :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  expiry                 :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders
  has_many :messages

  enum role: { user: 0, doctor: 1, customer_care: 2 }

  def doctor_orders
    Order.where(doctor_id: self.id)
  end
end
