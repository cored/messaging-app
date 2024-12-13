class MessagesController < ApplicationController
    before_action :authenticate_user!

    def index
        @messages = fetch_messages
    end

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

    def fetch_messages
        if current_user.customer_care?
            Message.customer_care_messages(current_user.id)
        elsif current_user.doctor?
            Message.doctor_messages(current_user.id)
        else
            Message.user_messages(current_user.id)
        end
    end
end
