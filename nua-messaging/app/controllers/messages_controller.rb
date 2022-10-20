class MessagesController < ApplicationController
  def show
    @message = Message.find(params[:id])
    @message.update(read: true)
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

  def issue_new_prescription
    result = ActiveRecord::Base.transaction do
      new_prescription_message
      raise ActiveRecord::Rollback unless PaymentProviderApi.call(User.current)
      Payment.create(user: User.current)
    end

    result ? flash[:success] = 'Prescription request sent' : flash[:alert] = 'Oops, something went wrong with your payment'
    redirect_to :root
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
