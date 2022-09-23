class User::MessagesController < ApplicationController

  before_action :authenticate_user!, only: [:create]

  def create
    #formで送られてきたroom_idとcurrent_user.idを持ったデータがEntryにあるかを確認
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      #contentとroom_idはformで送られてきているため、user_idをマージして新規メッセージを作成
      @message = Message.create((message_params).merge(:user_id => current_user.id))
      redirect_to "/rooms/#{@message.room_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def message_params
      params.require(:message).permit(:user_id, :content, :room_id)
    end
end