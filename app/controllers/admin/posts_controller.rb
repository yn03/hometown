class Admin::PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    @post_all = Post.all
    @user = current_user

    @tag_list = Tag.all
    @users = User.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = @post.comments
    @post_tags = @post.tags
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  def update
    @post = Post.find(params[:id])

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
    params.require(:post).permit(:title, :text, :place_id, :genre_id)
  end
end