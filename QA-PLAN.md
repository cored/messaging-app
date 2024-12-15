### QA Plan

This updated QA Plan includes detailed steps on how to navigate to each feature in the system, allowing testers to follow a clear path to test the functionality and verify that each role can access and interact with messages in the application. This also includes reference to the seed data and what specific records should be used for testing.

---

## **QA Plan for Message Application**

### **Overview**

The message application facilitates communication between users, doctors, and customer care representatives regarding orders. The key functionalities include sending messages, differentiating message visibility based on roles, and ensuring that only relevant parties can view specific messages. This QA plan outlines the testing scope, strategy, test cases, validation requirements, and how to navigate to each feature to perform the tests.

---

### **Testing Scope**

1. **User Role-based Access Control**
		- Ensure that messages are visible based on user roles: customer (user), doctor, and customer care.
		- Each role should have specific access privileges for viewing and sending messages.

2. **Message Creation**
		- Verify that messages can be successfully created by different roles (user, doctor, customer care).
		- Ensure messages are correctly associated with the user, doctor, and order.

3. **Message Visibility**
		- Validate that messages are visible only to the relevant parties:
				- Users can only see messages from the doctor and customer care.
				- Doctors can see messages from the user but not customer care's messages.
				- Customer care can see all messages, including those between the user and doctor.

4. **Message Retrieval**
		- Ensure messages are retrieved in reverse chronological order.
		- Test the pagination of message lists to ensure older messages can be loaded.

5. **Validation & Error Handling**
		- Verify that invalid or missing messages are not saved.
		- Ensure appropriate error messages are displayed if message creation fails.

---

### **Test Cases with Navigation Steps**

#### **Test Case 1: User Sends a Message to a Doctor**
- **Navigation Steps**:
		1. Log in as the user (`user@example.com`).
		2. Navigate to the "Orders" section.
		3. Click on **Order 1** (`Order ID: 1`).
		4. Find the "Message" section at the bottom of the order.
		5. Type a message: "Can I get some more information on this product?" and click "Send."
		6. Ensure the message is saved with `user_id = 1` and `doctor_id = 1` for order 1.
- **Expected Result**: Message is successfully sent and saved with `user_id = 1` and `doctor_id = 1`.

#### **Test Case 2: Doctor Sends a Message to a User**
- **Navigation Steps**:
		1. Log in as the doctor (`doctor@example.com`).
		2. Navigate to the "Orders" section.
		3. Click on **Order 1** (`Order ID: 1`).
		4. Scroll to the "Message" section.
		5. Type a message: "Sure, I can help you with that. What do you need to know?" and click "Send."
		6. Ensure the message is saved with `doctor_id = 1` and `user_id = 1`.
- **Expected Result**: Message is successfully sent and saved with `doctor_id = 1` and `user_id = 1`.

#### **Test Case 3: Customer Care Sends a Message**
- **Navigation Steps**:
		1. Log in as customer care (`customercare@example.com`).
		2. Navigate to the "Orders" section.
		3. Click on **Order 1** (`Order ID: 1`).
		4. Scroll to the "Message" section.
		5. Type a message: "Hello, how can I assist you with your order?" and click "Send."
		6. Ensure the message is saved with `customer_care_id = 3` and is visible to all roles.
- **Expected Result**: Message is saved with `customer_care_id = 3` and visible to all roles.

#### **Test Case 4: User Sees Messages From the Doctor, But Not From Customer Care**
- **Navigation Steps**:
		1. Log in as the user (`user@example.com`).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. Review the "Message" section and ensure the user can see messages from the doctor and customer care, but **not** between the doctor and customer care.
		4. Verify that the user **cannot** see the customer care message.
- **Expected Result**: User can see messages from the doctor but not from customer care.

#### **Test Case 5: Doctor Sees Messages From the User, But Not From Customer Care**
- **Navigation Steps**:
		1. Log in as the doctor (`doctor@example.com`).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. Review the "Message" section and ensure the doctor can see messages from the user, but **not** from customer care.
		4. Verify that the doctor **cannot** see messages from customer care.
- **Expected Result**: Doctor can see messages from the user but not customer care.

#### **Test Case 6: Customer Care Sees All Messages**
- **Navigation Steps**:
		1. Log in as customer care (`customercare@example.com`).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. Review the "Message" section and ensure that customer care can see all messages, including those between the user and the doctor.
- **Expected Result**: Customer care can see all messages for order 1.

#### **Test Case 7: Invalid Message Input (Empty Message)**
- **Navigation Steps**:
		1. Log in as any role (e.g., user).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. In the "Message" section, leave the message input blank and click "Send."
		4. Verify that the system displays an error message: "Message cannot be blank."
- **Expected Result**: Error message: "Message cannot be blank."

#### **Test Case 8: Ensure Messages are Ordered Correctly**
- **Navigation Steps**:
		1. Log in as the user (`user@example.com`).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. Review the "Message" section and verify that messages are listed in reverse chronological order.
		4. Ensure that the most recent messages appear first.
- **Expected Result**: Messages are listed in reverse chronological order.

#### **Test Case 9: Pagination for Message Retrieval**
- **Navigation Steps**:
		1. Log in as the user (`user@example.com`).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. Scroll down to the bottom of the message list.
		4. Click the "Load more" button to load older messages.
		5. Verify that older messages load correctly.
- **Expected Result**: Older messages should load when clicking "Load more."

#### **Test Case 10: Unauthorized Access Attempt (e.g., User Accessing Doctor’s Messages)**
- **Navigation Steps**:
		1. Log in as the user (`user@example.com`).
		2. Navigate to **Order 1** (`Order ID: 1`).
		3. Try to view messages that should only be visible to the doctor or customer care.
		4. Verify that the system denies access and displays an error message.
- **Expected Result**: Unauthorized access is denied with an appropriate error message.

---

### **Additional Notes for Navigation:**
- **Role-based Navigation**: Each user should have specific access to orders and messages based on their role. If any user navigates to a message or order they don't have access to, an appropriate error message should be shown.

- **Navigation to Order Details**: Users, doctors, and customer care can access orders from a list of their orders. Orders are displayed on the user's dashboard and can be clicked to view the details.

- **Message Visibility by Role**: Ensure that the visibility of messages changes dynamically based on the role of the logged-in user. For example, the user should not be able to see messages that are meant for customer care or other users.

---

### **Next Steps**
1. **Run Tests on Seeded Data**:
	 - Ensure the database is populated with the seed data by running `rails db:seed`.
	 - Execute the QA tests to verify the correct functionality of messages, user permissions, and roles with the seeded data.

2. **Test Edge Cases**:
	 - Test cases such as users trying to access messages not meant for them (e.g., doctor-to-customer-care) should be handled by error messages.

3. **Ensure Proper Message Flow**:
	 - Confirm that messages between users, doctors, and customer care are correctly handled based on user roles.

4. **Test Database Integration**:
	 - Ensure that messages are correctly stored, associated with orders, and retrievable by the appropriate users.

By following these navigation steps in the QA plan, testers can effectively evaluate the application’s messaging functionality and ensure role-based access control is working as expected.
