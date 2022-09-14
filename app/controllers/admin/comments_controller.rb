class Admin::CommentsController < ApplicationController
  def destroy
    comment = Comment.find_by(params[:id])
    comment.destroy
    redirect_to admin_post_path(comment.post)
  end
end
