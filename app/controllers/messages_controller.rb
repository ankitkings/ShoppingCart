class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.build(message_params)
    @message.sender = current_user

    if @message.save
      html = render_to_string(partial: 'messages/message', locals: { message: @message })
      ChatRoomChannel.broadcast_to(@chat_room, html: html)
    end

    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
