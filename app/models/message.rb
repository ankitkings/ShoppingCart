class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :sender, polymorphic: true
end
