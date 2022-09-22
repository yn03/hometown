class Admin::CommentsController < ApplicationController
  def destroy
    @post = Post.find(params[:post_id])
    post_comment = @post.comments.find(params[:id])
    post_comment.destroy
    redirect_to admin_post_path(@post)
  end
end
