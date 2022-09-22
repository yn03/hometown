class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def new
    @post = Post.new
  end

  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    @user = current_user
    @posting = Post.page(params[:page]).per(5)
    @tag_list = Tag.all

    if params[:place_id]
      # Post.find([1, 4, 2])
      @favorite_ranks = Post.where(id: Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id), place_id: params[:place_id]).limit(3)
    else
      @favorite_ranks = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
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

 def search_tag
    @tag_list=Tag.all.order(created_at: :desc)
    @tag=Tag.find(params[:tag_id])
    @posts=@tag.posts.page(params[:page]).per(10)
  end

 def search
    keyword = params[:keyword].sub(/　/,' ')  #全角であれば半角にする
    keywordAry = keyword.split(' ')# "ケーキ 青森県" → ["ケーキ", "青森県"]のように、『半角スペースを基準に分割する』
    # @posts = []
    @posts = Post.all
    keywordAry.each do |keyword|
      # @posts.concat(Post.search(keyword))
      @posts = @posts.search(keyword)
    end
    # @posts = @posts.uniq
  end

 private
  def post_params
    params.require(:post).permit(:title, :text, :place_id, :genre_id, :image,:comment)
  end
end