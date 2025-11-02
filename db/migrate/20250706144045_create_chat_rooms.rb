class CreateChatRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :admin_id

      t.timestamps
    end
  end
end
