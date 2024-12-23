# README

## Overview

This application represents a small component of a larger system. It models a messaging system used by users, doctors, and customer care agents, primarily for managing communication regarding medical orders. The goal of this exercise is to demonstrate how the application can be refactored to adopt an event-driven architecture, enhancing scalability, maintainability, and flexibility.

## Setup

1. Clone the repository.
2. Install the required gems by running `bundle install`.
3. Set up the database with `rails db:migrate`.
4. Seed the database with `rails db:seed`.
5. Start the server with `rails s`.
6. Open your browser and navigate to `http://localhost:3000`.

## The Application

The application allows users with active orders to communicate with their assigned doctors, request changes, and ask for refills. The system also supports customer care agents who can intervene as necessary. The goal is to rework the existing architecture into an event-driven model to facilitate easier scaling and improved maintainability.

### Login Credentials

- **Login as User**
	- Email: `user@example.com`
	- Password: `Password1!`

- **Login as Doctor**
	- Email: `doctor@example.com`
	- Password: `Password1!`

## Key Architectural Changes

### 1. **MessageForm for Handling Message Creation**

#### Previous Design:
In the original design, message creation was directly handled by the controller, leading to tightly coupled code that was difficult to test and maintain.

#### New Approach:
The introduction of the `MessageForm` encapsulates the message creation logic and validation, making the controller more concise and testable. This refactor follows an event-driven approach, where actions like message creation are now decoupled from the controller and can trigger other downstream events (e.g., notifications, updates).

##### Code Example:
```ruby
class MessageForm
	include ActiveModel::Model
	attr_accessor :message, :order_id, :user_id, :doctor_id, :customer_care_id

	def save
		return false unless valid?

		message = Message.new(message_params)

		if message.save
			# Event can be triggered here, e.g., publishing a message event
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
		}.compact # Removes nil values
	end
end
```

#### Benefits:
- **Separation of Concerns**: The `MessageForm` isolates message creation from the controller, leading to cleaner code.
- **Event-Driven Architecture**: Message creation can trigger events that notify other systems (e.g., push notifications or database updates).
- **Improved Testability**: The form object makes it easier to write unit tests for message creation.

#### Trade-offs:
- **Increased Abstraction**: The introduction of the `MessageForm` adds an extra layer of abstraction, which might be unfamiliar to developers new to the codebase.
- **More Code to Maintain**: While it adds a class to maintain, the benefits of testability and separation of concerns outweigh the downsides.

---

### 2. **Role-Based Message Visibility**

#### Previous Design:
All users (patients, doctors, and customer care agents) had access to all messages, which led to potential privacy concerns.

#### New Approach:
We introduced role-based visibility for messages, ensuring that each user can only see the messages relevant to their role. The access control mechanism is now handled through scopes in the `Message` model.

##### Code Example:
```ruby
class Message < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', optional: true
	belongs_to :order

	# Role-based message visibility
	scope :user_messages, ->(user) { where(user_id: user.id) }
	scope :doctor_messages, ->(doctor) { where(doctor_id: doctor.id) }
	scope :customer_care_messages, ->(customer_care) { where(customer_care_id: customer_care.id) }
end
```

#### Benefits:
- **Fine-grained Access Control**: Each user can only see the messages intended for them, preventing privacy issues.
- **Security**: Ensures that unauthorized users can't access sensitive data.

#### Trade-offs:
- **Complexity**: Implementing role-based filtering can increase the complexity of database queries, especially when multiple roles are involved in message access.

---

### 3. **Service Objects and Event Handling**

#### Previous Design:
The controller handled all the logic for message creation, making it large and difficult to maintain. This also made the system more challenging to scale.

#### New Approach:
By using service objects like `MessageForm` and decoupling logic from the controller, we adopt an event-driven architecture. The service object is responsible for processing the logic, and events (such as message creation) are triggered once actions are completed.

##### Example of Refactored Controller:
```ruby
class MessagesController < ApplicationController
	before_action :authenticate_user!

	def create
		@message_form = MessageForm.new(message_params)

		if @message_form.save
			# Optionally trigger events such as notifications or updates
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
- **Cleaner Controller**: The controller only delegates responsibilities, making it simpler and easier to maintain.
- **Event-Driven Design**: The logic of message creation can trigger events that notify other parts of the system (e.g., push notifications, message queues).
- **Testability**: The service object can be tested independently from the controller, making it easier to ensure correctness.

#### Trade-offs:
- **New Abstraction**: The introduction of service objects adds a layer of abstraction, which might require time to understand for new developers.

---

### Future Work & Scalability

With the current architecture in place, the system is ready for scalability and additional features:

1. **Real-Time Messaging**: Implement real-time messaging with ActionCable or other WebSocket solutions to allow users to receive messages instantly.
2. **Message Queues**: Integrate with message queues (e.g., RabbitMQ, Kafka) to handle asynchronous tasks like notifications and processing heavy workloads.
3. **Optimizing Performance**: For larger datasets, implement pagination, indexing, and other performance optimizations to keep the system fast and responsive.
4. **Expanded Testing**: Add more tests, particularly for edge cases (e.g., handling large message volumes, incorrect user roles).

---

### Conclusion

By refactoring the application to adopt an event-driven architecture, we’ve improved the scalability, maintainability, and testability of the codebase. The introduction of `MessageForm`, role-based access control, and service objects have helped decouple responsibilities and streamline the system’s growth potential. These changes lay the groundwork for adding real-time communication, advanced message filtering, and other features to support a growing user base.

Feel free to reach out if you have any questions or suggestions.
