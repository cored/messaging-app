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

As part of modernizing the codebase, there are several key updates made to the infrastructure. These changes align the project with industry best practices and prepare the codebase for scalability, security, and maintainability. Below are the steps to upgrade the infrastructure and the reasoning behind these changes:

### 1. **Upgrade to Use StimulusReflex for Real-Time Interaction**

#### Reasoning:
In the past, the application might have used traditional HTTP requests to update the user interface. However, real-time updates are crucial for improving the user experience, especially in messaging systems. StimulusReflex allows us to handle real-time updates seamlessly with WebSocket support, making interactions faster and more engaging.

#### How to Upgrade:
- **Install the StimulusReflex Gem**:
	Add the following gem to your `Gemfile`:

	```ruby
	gem 'stimulus_reflex', '~> 3.5'
	```

	Then run:
	```bash
	bundle install
	```

- **Install Stimulus and StimulusReflex JavaScript**:
	Run the following command to install the necessary JavaScript packages:

	```bash
	bin/rails stimulus_reflex:install
	```

- **Configure JavaScript**:
	If using Webpacker, make sure that the Stimulus and StimulusReflex controllers are properly imported and set up in your `app/javascript/packs/application.js` file:

	```javascript
	import { Application } from "stimulus"
	import { defineControllers } from "stimulus_reflex"
	import StimulusReflex from "stimulus_reflex"

	const application = Application.start()
	defineControllers(application)
	```

- **Replace Traditional Requests with Reflexes**:
	In your HTML and JavaScript, replace standard form submissions or AJAX requests with Reflex calls. Example:

	```javascript
	// Increment counter via Reflex
	this.stimulate("CounterReflex#increment")
	```

### 2. **Switch from Sprockets to TailwindCSS with Webpack**

#### Reasoning:
Sprockets was the default asset pipeline in Rails, but it has limitations when it comes to modern CSS frameworks. Using Webpack with TailwindCSS allows us to easily customize and extend our styles with modern tooling.

#### How to Upgrade:
- **Install TailwindCSS**:
	Add the following gem to your `Gemfile`:

	```ruby
	gem "tailwindcss-rails", "~> 2.7"
	```

	Then run:
	```bash
	bundle install
	```

- **Install TailwindCSS via Rails**:
	Run the following command to initialize TailwindCSS with Rails:

	```bash
	rails tailwindcss:install
	```

- **Remove Old CSS References**:
	Remove any outdated or conflicting CSS from your asset pipeline (e.g., `app/assets/stylesheets/application.css`) and ensure you're using the new Tailwind setup.

- **Use Tailwind in Views**:
	With Tailwind now in place, you can use utility classes directly in your HTML views. For example:

	```html
	<button class="bg-blue-500 text-white p-2 rounded">Submit</button>
	```

### 3. **Switch to Importmap for JavaScript Management (Rails 7+)**

#### Reasoning:
Rails 7 introduces `importmap` as an alternative to Webpack. If you're upgrading to Rails 7, it's recommended to use importmaps for lightweight JavaScript management. Importmap allows us to load JavaScript modules directly from CDN, reducing the need for bundling.

#### How to Upgrade:
- **Install Importmap**:
	If you're using Rails 7, replace Webpacker with `importmap`:

	```bash
	bin/rails importmap:install
	```

- **Pin JavaScript Libraries**:
	Pin the necessary JavaScript libraries in `config/importmap.rb`. For example:

	```ruby
	pin "application", preload: true
	pin "stimulus", to: "stimulus.js"
	pin "stimulus_reflex", to: "stimulus_reflex.js"
	```

- **Use JavaScript Modules**:
	Replace Webpacker imports with `import` statements directly in your `application.js`:

	```javascript
	import "stimulus"
	import "stimulus_reflex"
	```

### 4. **Use WebSocket for Real-Time Messaging (ActionCable)**

#### Reasoning:
ActionCable provides real-time WebSocket support, allowing the system to push new messages and updates to the user without requiring them to reload the page. This is essential for the chat functionality, as it enhances the user experience by providing instant updates.

#### How to Upgrade:
- **Install Redis**:
	For production, Redis is used to back the WebSocket server. Add it to your `Gemfile`:

	```ruby
	gem "redis", "~> 4.0"
	```

	Then run:

	```bash
	bundle install
	```

- **Configure ActionCable**:
	Ensure your `config/cable.yml` is properly configured for both development and production:

	```yml
	development:
		adapter: async
		channel_prefix: your_app_development

	production:
		adapter: redis
		url: redis://localhost:6379/1
		channel_prefix: your_app_production
	```

- **Enable WebSocket in Channels**:
	Make sure that your message and chat channels are set up to broadcast and listen for real-time updates.

---

These changes are aimed at improving the scalability, performance, and maintainability of the codebase. They enable us to build a more modern application using real-time interactions, a flexible CSS framework (TailwindCSS), and a more efficient way of managing JavaScript.

If you need further assistance with the migration or have any questions, feel free to reach out!
