class User::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
    @post_all = @user.posts
    @favorites = Favorite.where(user_id: current_user.id)
    @currentUserEntry = Entry.where(user_id: current_user.id) # current_userをEntriesテーブルから探す
    @userEntry = Entry.where(user_id: @user.id) # DMを送る対象のユーザーをEntriesテーブルから探す
    if @user.id != current_user.id
      # currentUserと@userのEntriesをそれぞれ一つずつ取り出し、2人のroomが既に存在するかを確認
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
        # 2人のroomが既に存在していた場合
          if cu.room_id == u.room_id
            @isRoom = true
            #room_idを取り出す
            @roomId = cu.room_id
          end
        end
      end
      # 2人ののroomが存在しない場合
      unless @isRoom
        #roomとentryを新規に作成する
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(current_user)
  end

  def unsubscribe
    @user = User.find_by(name: params[:name])
  end

  def withdraw
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

   private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image, :image)
  end
end
