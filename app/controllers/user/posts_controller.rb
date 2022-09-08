class User::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @post = Post.new
    @posts = Post.all
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
    @user = current_user
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user == current_user
      render "edit"
    else
      redirect_to post_path
    end
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    pp post
    post.save!
      flash[:notice] = "You have created book successfully"
      redirect_to post_path(post.id)
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
       redirect_to post_path(post.id), notice: 'You have updated book successfully.'
    else
       render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def ranking
  end

 private
  def post_params
    params.require(:post).permit(:title, :text, :place_id, :genre_id)
  end
end

