class Admin::PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all
    @user = current_user
    @posting = Post.page(params[:page]).per(10)
    @tag_list = Tag.all
    @users = User.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = @post.comments
  end

  def  destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_root_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :text, :place_id, :genre_id)
  end
end