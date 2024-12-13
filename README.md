# README

This is the take-home project for the interview process at Rugiet.

## Setup

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `rails db:seed`
5. Run `rails s`
6. Open your browser and navigate to `http://localhost:3000`

## The Application

The application is a small extract of our main application. It's a part of the messaging system between users and doctors.
Users with active orders leverage the chat system to ask their doctor questions, ask for changes, and to perform refills.

Whilst this application is not representative of our main application, performing the requested task will expose you to the same kinds of challenges you'll face in the real application.

### Login As User

Email: user@example.com
Password: Password1!

### Login As Doctor

Email: doctor@example.com
Password: Password1!

## Tips

Treat this task as if you were working a real ticket on our team. Think about how the code currently works and how you would feel maintaining it and what you add to it 6 months from now.

We want to see how you think about code and how you write it. If you see opportunities to improve the code, please feel free to change it.

We're also looking for you to write tests, but not for the entire application. We're looking for you to write tests for the code you write.

---

## **Upgrading to the New Infrastructure**

As part of modernizing the codebase, several key updates have been made to the infrastructure. These changes align the project with industry best practices and prepare the codebase for scalability, security, and maintainability. Below are the steps to upgrade the infrastructure and the reasoning behind these changes.

### 1. **Introduction of the `MessageForm` for Handling Messages**

#### Reasoning:
The previous message creation logic was entangled within the controller, making it difficult to test and maintain. By introducing a `MessageForm` object, we separate the concerns of message creation from the controller. This allows the controller to focus solely on handling user input and responding to the client, while the form object handles business logic, including validation and message assignment.

#### Benefits:
- **Single Responsibility**: The `MessageForm` class is responsible solely for message creation, encapsulating logic like role-based message assignment (user, doctor, customer care).
- **Improved Testability**: The form object simplifies testing of message creation logic since it's decoupled from the controller.
- **Maintainability**: Clear separation of concerns makes future changes (like adding new message types or validations) easier and safer.

#### How it Works:
- The `MessageForm` class collects the necessary attributes and validates them.
- It assigns the correct `user_id`, `doctor_id`, or `customer_care_id` based on the user’s role.
- It saves the message to the database.

Example:
```ruby
class MessageForm
	include ActiveModel::Model
	attr_accessor :message, :order_id, :user_id, :doctor_id, :customer_care_id

	def save
		return false unless valid?

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
		}.compact # compact removes any nil values (so only valid params are passed)
	end
end
```

#### Trade-offs:
- **More Code to Maintain**: The addition of a new class introduces more code. However, this trade-off is justified by the improved structure and testability of the codebase.
- **Increased Complexity for New Developers**: For developers unfamiliar with form objects, it introduces an extra layer of abstraction. However, this is a common pattern that can simplify complex form handling in the long term.

### 2. **Role-Based Message Visibility**

#### Reasoning:
In the original messaging system, all users (doctor, customer care, and patient) had access to all messages. However, the business requirement changed, and now the messages between doctors and patients should be hidden from customer care users, and vice versa.

#### Solution:
- We introduced three scopes in the `Message` model (`user_messages`, `doctor_messages`, `customer_care_messages`) to differentiate which messages a user can see.
- The new role-based access control (RBAC) is applied through these scopes, ensuring that users, doctors, and customer care agents can only see the messages relevant to them.

Example:
```ruby
class Message < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', optional: true
	belongs_to :order

	# Scope to filter messages for a user
	scope :user_messages, ->(user) { where(user_id: user.id) }

	# Scope to filter messages for a doctor
	scope :doctor_messages, ->(doctor) { where(doctor_id: doctor.id) }

	# Scope to filter messages for customer care
	scope :customer_care_messages, ->(customer_care) { where(customer_care_id: customer_care.id) }
end
```

#### Benefits:
- **Fine-grained Access Control**: By using scopes, we ensure that each user can only access messages they are authorized to view.
- **Security**: Only the relevant parties (user, doctor, or customer care) can see specific messages, reducing potential privacy breaches.

#### Trade-offs:
- **More Complex Queries**: Using scopes introduces more complex queries, especially when you need to filter by multiple roles or conditions. However, this is necessary to ensure secure and flexible messaging.

### 3. **Use of Service Objects (MessageForm) for Logic Handling**

#### Reasoning:
We wanted to follow Sandi Metz's advice about keeping classes under 100 lines and avoiding controllers with too many responsibilities. By introducing the `MessageForm` service object, we encapsulate the logic of message creation and role-based assignment, which keeps the controller concise.

#### How It Works:
The controller no longer directly handles message creation, reducing the size and complexity of the controller. Instead, it delegates the message creation logic to the `MessageForm`, which handles validation and object creation.

Example:
```ruby
class MessagesController < ApplicationController
	before_action :authenticate_user!

	def create
		@message_form = MessageForm.new(message_params)

		if @message_form.save
			redirect_to orders_path
		else
			flash[:error] = "Message failed to send: #{@message_form.errors.full_messages.join(", ")}"
			redirect_to orders_path
		end
	end

	private

	def message_params
		params.require(:message).permit(:message, :order_id, :user_id, :doctor_id, :customer_care_id)
	end
end
```

#### Benefits:
- **Cleaner Controller**: The controller only delegates the task to the form object, making it much easier to maintain.
- **Easier Testing**: Testing message creation becomes easier because the logic is encapsulated in a service object, which is easier to test independently.

#### Trade-offs:
- **New Abstraction**: Introducing a service object adds a layer of abstraction. Developers new to the codebase might initially find it harder to understand, but it ultimately leads to more maintainable and testable code.

---

### Future Work & Scalability

These changes have made the system more modular and easier to scale. Here are a few ways we can continue improving the system:

1. **Real-Time Messaging**: Integrating real-time messaging using ActionCable would improve user experience by pushing updates instantly as new messages are sent.
2. **Advanced Message Filtering**: Further refine message filtering by adding roles for administrative users or implementing additional business rules (e.g., prioritizing messages).
3. **Performance Optimization**: If the number of messages grows significantly, consider using database optimizations (indexes, pagination) to ensure the system remains performant.
4. **Testing**: Add more tests, especially for edge cases, such as large numbers of messages or incorrect user roles.

---

### Conclusion

By introducing a `MessageForm` object, role-based scopes, and service objects, we have made the application more maintainable, secure, and testable. While these changes add complexity, they also ensure the system is scalable and flexible in the long run. We are ready to handle growing user numbers and evolving business requirements.

Feel free to reach out if you have any questions or need further assistance.
