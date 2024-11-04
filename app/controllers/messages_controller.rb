class MessagesController < ApplicationController
    before_action :authenticate_user!, only: [:create]
  
    def create
      if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
        @message = Message.new(params.require(:message).permit(:content, :room_id).merge(user_id: current_user.id))
  
        if @message.save
          # ルームのパスを明示的に指定
          redirect_to room_path(@message.room_id)
        else
          flash[:alert] = "メッセージの送信に失敗しました。内容を確認してください。"
          redirect_back(fallback_location: root_path)
        end
      else
        flash[:alert] = "メッセージの送信が許可されていません。"
        redirect_back(fallback_location: root_path)
      end
    end
  end
  