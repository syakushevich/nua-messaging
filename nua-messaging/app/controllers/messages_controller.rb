class MessagesController < ApplicationController
  def show
    @message = Message.find(params[:id])
  end

  def create_reply
    ActiveRecord::Base.transaction do
      message_created = Message.where(id: params[:id]).pick(:created_at)

      receipient = (message_created > 1.week.ago ? User.default_doctor : User.default_admin)
      inbox = Inbox.find_by(user: receipient)
      outbox = Outbox.find_by(user: User.current)

      Message.create(message_params.merge(inbox_id: inbox.id, outbox_id: outbox.id))
    end

    flash[:success] = 'Message Sent'
    redirect_to :root
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
