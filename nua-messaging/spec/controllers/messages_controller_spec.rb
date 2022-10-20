require 'rails_helper'
require 'faker'

RSpec.describe MessagesController, type: :controller do
  let!(:admin) { User.create(is_patient: false, is_doctor: false, is_admin: true, first_name: "Mor", last_name: "Bius") }
  let!(:admin_inbox) { Inbox.create(user: admin) }
  let!(:doctor) { User.create(is_patient: false, is_doctor: true, is_admin: false, first_name: "Dr", last_name: "Who") }
  let!(:doctor_inbox) { Inbox.create(user: doctor) }
  let!(:current_user) { User.create(is_patient: true, is_doctor: false, is_admin: false, first_name: "Mr", last_name: "Beast") }

  describe '/show' do
    let!(:message) { Message.create(read: false, inbox: doctor_inbox) }

    it 'decrements unread count when doctor reads a message' do
      expect(doctor_inbox.reload.unread_count).to eq(1)
      get :show, params: { id: message.id }
      expect(doctor_inbox.reload.unread_count).to eq(0)
    end
  end

  describe '/create_reply' do
    let!(:user_outbox) { Outbox.create(user: current_user) }
    let!(:message) { Message.create(inbox: doctor_inbox) }

    it 'has unread message status after reply' do
      post :create_reply, params: { id: message.id, message: { body: 'test' } }

      expect(Message.last.read).to be false
    end

    it 'itcrements unread count when doctor receives a new message' do
      unread_count = doctor_inbox.reload.unread_count
      post :create_reply, params: { id: message.id, message: { body: 'test' } }
      expect(doctor_inbox.reload.unread_count).to eq(unread_count + 1)
    end

    context 'sends message to correct inbox and outbox' do
      include ActiveSupport::Testing::TimeHelpers

      it 'sends message to admin' do
        travel_to(Time.now + 1.week + 1.minute) do
          expect(admin_inbox.messages.count).to eq(0)
          post :create_reply, params: { id: message.id, message: { body: 'test' } }
          expect(admin_inbox.messages.count).to eq(1)
        end
      end

      it 'sends message to doctor' do
        expect(doctor_inbox.messages.count).to eq(1)
        post :create_reply, params: { id: message.id, message: { body: 'test' } }
        expect(doctor_inbox.messages.count).to eq(2)
      end
    end
  end

  describe '/issue_new_prescription' do
    context 'api returned true' do
      before { allow_any_instance_of(PaymentProviderApi).to receive(:call).and_return(true) }

      it 'sends message to admin' do
        post :issue_new_prescription, params: { id: 1 }
        expect(admin_inbox.messages.count).to eq(1)
      end

      it 'charges money from the client' do
        post :issue_new_prescription, params: { id: 1 }
        expect(Payment.count).to eq(1)
      end
    end

    context 'api returned error' do
      before { allow_any_instance_of(PaymentProviderApi).to receive(:call).and_return(false) }

      it 'does nothing' do
        post :issue_new_prescription, params: { id: 1 }
        expect(Payment.count).to eq(0)
      end
    end
  end
end
