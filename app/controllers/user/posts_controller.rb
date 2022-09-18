class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def new
    @post = Post.new
  end

  def index
    @post = Post.new
    @posts = Post.all
    @user = current_user
    @posting = Post.page(params[:page]).per(10)
    @tag_list = Tag.all
    @favorite_ranks = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
  end

  def show
    @post = Post.find(params[:id])
    @user = current_user
    @comment = Comment.new
    @comments = @post.comments
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    if @post.user == current_user
      render "edit"
    else
      redirect_to post_path
    end
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    tag_list=params[:post][:name].split(',')
    pp post
    if post.save!
      post.save_tag(tag_list)
      redirect_to posts_path(post.id),notice:'投稿しました'
    else
      render:new
    end
  end

  def update
    post = Post.find(params[:id])
    tag_list=params[:post][:name].split(',')
    if post.update(post_params)
      post.save_tag(tag_list)
       redirect_to post_path(post.id), notice: '更新しました'
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
    @favorite_ranks = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
  end

 def search_tag
    @tag_list=Tag.all
    @tag=Tag.find(params[:tag_id])
    @posts=@tag.posts.page(params[:page]).per(10)
  end

 def search
    @posts = Post.search(params[:keyword])
  end

 private
  def post_params
    params.require(:post).permit(:title, :text, :place_id, :genre_id, :image)
  end
end