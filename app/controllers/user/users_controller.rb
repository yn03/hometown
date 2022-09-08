class User::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to show
  end

  def unsubscribe
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end
