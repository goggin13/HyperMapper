class HyperController < ApplicationController

  def single_insert
    @user = HyperUser.new(params[:user])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def single_update
    @user = HyperUser.find(params[:id])

    if @user.update_attributes(params[:user])
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def single_destroy
    @user = HyperUser.find(params[:id])
    @user.destroy
    head :no_content
  end
    
  def single_query
    @user = HyperUser.find(params[:id])
    render json: @user
  end  
    
  def embedded_insert
    @user = HyperUser.find(params[:id])
  	@post = @user.posts.build params[:post]
  	
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
  
  def embedded_update
    @post = HyperUser.find(params[:id]).posts.find(params[:post_id])
  	
    if @post.update_attributes params[:post]
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end   
  end
  
  def embedded_destroy
    @post = HyperUser.find(params[:id]).posts.find(params[:post_id])
  	@post.destroy
    head :no_content
  end
end
