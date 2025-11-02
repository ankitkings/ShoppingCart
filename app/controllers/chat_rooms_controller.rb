class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @chat_rooms = ChatRoom.includes(:user).all
    else
      redirect_to chat_room_path(current_user.chat_room)
    end
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.order(created_at: :asc)
  end
end
