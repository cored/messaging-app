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
        @message = Message.new(message_params)

        if current_user.doctor?
            @message.doctor = current_user
        elsif current_user.customer_care?
            @message.customer_care = current_user
        else
            @message.user = current_user
        end

        if @message.save
            redirect_to orders_path
        else
            flash[:error] = "Message failed to send: #{@message.errors.full_messages.join(", ")}"
            redirect_to orders_path
        end
    end

    private

    def message_params
        params.require(:message).permit(:message, :order_id, :user_id, :doctor_id, :customer_care_id)
    end
end
