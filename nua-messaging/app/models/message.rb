class Message < ApplicationRecord
  belongs_to :inbox
  belongs_to :outbox

  # For conditional counters I used gem https://github.com/magnusvk/counter_culture , it seemed perfect for this task
  counter_culture :inbox, column_name: proc {|model| model.read? ? nil : 'unread_count' }
end
