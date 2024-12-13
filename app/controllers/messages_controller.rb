class MessagesController < ApplicationController
    before_action :authenticate_user!

    def index
        if current_user.customer_care?
            @messages = Message.all # Customer care can see all messages
        else
            @messages = Message.where(order_id: current_user.orders.pluck(:id))
        end
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
end
