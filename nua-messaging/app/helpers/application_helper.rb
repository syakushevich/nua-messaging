module ApplicationHelper
  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-error"
      when 'alert' then "alert alert-error"
    end
  end

  def new_prescription_message
    admin_inbox = Inbox.find_by(user: User.default_admin)
    outbox = Outbox.find_by(user: User.current)
    message = "User ##{User.current.id} requested new prescription"

    Message.create(inbox: admin_inbox, outbox: outbox, body: message)
  end
end
