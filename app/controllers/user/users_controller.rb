class User::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @post = @user.posts
    @posts = Post.where(user_id: current_user.id)
    @favorites = Favorite.where(user_id: current_user.id)
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
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end
