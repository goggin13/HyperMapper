class CommentsController < ApplicationController
  
  before_filter :redirect_unless_signed_in
  
  def create
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.create text: params[:comment][:text],
  									                 user_id: current_user.id
  	respond_to do |format|
  		format.js
  	end
  end

  def destroy
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.find(params[:id])
  	@comment.destroy
  	respond_to do |format|
  		format.js
  	end
  end
end
