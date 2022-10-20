require 'rails_helper'
require 'faker'

RSpec.describe MessagesController, type: :controller do
  describe '/create_reply' do
    let!(:admin) { User.create(is_patient: false, is_doctor: false, is_admin: true, first_name: "Mor", last_name: "Bius") }
    let!(:doctor) { User.create(is_patient: false, is_doctor: true, is_admin: false, first_name: "Dr", last_name: "Who") }
    let!(:current_user) { User.create(is_patient: true, is_doctor: false, is_admin: false, first_name: "Mr", last_name: "Beast") }
    let!(:doctor_inbox) { Inbox.create(user: doctor) }
    let!(:user_outbox) { Outbox.create(user: current_user) }
    let!(:admin_inbox) { Inbox.create(user: admin) }
    let!(:message) { Message.create(inbox: doctor_inbox) }

    it 'has unread message status after reply' do
      post :create_reply, params: { id: message.id, message: { body: 'test' } }

      expect(Message.last.read).to be false
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
end