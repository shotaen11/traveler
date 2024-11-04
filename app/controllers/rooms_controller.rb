# app/controllers/rooms_controller.rb
class RoomsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @room = Room.create(user_id: current_user.id) # Roomの作成時にuser_idをセット
      @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
      @entry2 = Entry.create(entry_params.merge(room_id: @room.id))
      redirect_to room_path(@room)
    end
  
    def show
        @room = Room.find(params[:id])
        if Entry.where(user_id: current_user.id, room_id: @room.id).present?
          @messages = @room.messages
          @message = Message.new(room_id: @room.id) # メッセージの新規オブジェクトを初期化
          @entries = @room.entries

        # 相手のユーザーを取得
          @recipient = @entries.where.not(user_id: current_user.id).first.user
        else
          redirect_back(fallback_location: root_path)
        end
      end
  
    private
  
    def entry_params
      params.require(:entry).permit(:name, :profile, :profile_image)
    end
  end
  