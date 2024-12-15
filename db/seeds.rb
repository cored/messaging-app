# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# Example order items
order_items = [{
		name: 'Rugiet ED Strong',
		dosage: '1 troche',
		quantity: 3,
		instructions: 'Take 1 troche 30 minutes before sex',
		price: 150.00
}]

# Create users with various roles
user = User.create(
		email: 'user@example.com',
		credit_card_number: '4111 1111 1111 1111',
		expiry: '08/27',
		cvv: 988,
		password: 'Password1!',
		password_confirmation: 'Password1!',
		role: 0  # Regular user (customer)
)

doctor = User.create(
		email: 'doctor@example.com',
		password: 'Password1!',
		password_confirmation: 'Password1!',
		is_doctor: true,
		role: 1  # Doctor role
)

customer_care = User.create(
		email: 'customercare@example.com',
		password: 'Password1!',
		password_confirmation: 'Password1!',
		role: 2  # Customer care role
)

# Create an order
order = Order.create(user: user, doctor: doctor, order_items: order_items, total: 450.00, created_at: Time.now - 3.days)

# Messages between users, doctor, and customer care
Message.create(user: user, order: order, message: 'Can I get some more information on this product?', created_at: Time.now - 2.days)
Message.create(doctor: doctor, order: order, message: 'Sure, I can help you with that. What do you need to know?', created_at: Time.now - 2.days)
Message.create(user: user, order: order, message: 'What is the dosage?', created_at: Time.now - 1.day)
Message.create(user: user, order: order, message: 'Hello?', created_at: Time.now - 2.hours)
Message.create(user: user, order: order, message: 'Doc, are you there?', created_at: Time.now)

# Messages between customer care and user
Message.create(customer_care: customer_care, order: order, message: 'Hello, how can I assist you with your order?', created_at: Time.now - 1.day)
Message.create(user: user, order: order, message: 'I need help with payment issues.', created_at: Time.now)

# Example of doctor updating order or providing advice
Message.create(doctor: doctor, order: order, message: 'I recommend using this product 30 minutes before any sexual activity.', created_at: Time.now - 3.hours)

# Seed some additional users with different roles
another_user = User.create(
		email: 'anotheruser@example.com',
		credit_card_number: '4222 2222 2222 2222',
		expiry: '09/28',
		cvv: 333,
		password: 'Password2!',
		password_confirmation: 'Password2!',
		role: 0  # Regular user (customer)
)

another_doctor = User.create(
		email: 'anotherdoctor@example.com',
		password: 'Password2!',
		password_confirmation: 'Password2!',
		is_doctor: true,
		role: 1
)

# Create another order with different user and doctor
another_order = Order.create(user: another_user, doctor: another_doctor, order_items: order_items, total: 500.00, created_at: Time.now - 5.days)

# Messages for the second order
Message.create(user: another_user, order: another_order, message: 'Is this product safe for long-term use?', created_at: Time.now - 1.day)
Message.create(doctor: another_doctor, order: another_order, message: 'Yes, this is generally safe, but please consult your primary doctor.', created_at: Time.now - 12.hours)
Message.create(user: another_user, order: another_order, message: 'Thank you for the info!', created_at: Time.now)

# Example of another customer care message
Message.create(customer_care: customer_care, order: another_order, message: 'How can I assist you today?', created_at: Time.now - 2.days)
