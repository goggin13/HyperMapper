class MongoidController < ApplicationController
  
  # curl --data "user[username]=goggin13&user[bio]=hello world" localhost:3000/mongoid/single_insert
  def single_insert
    @user = MongoidUser.new(params[:user])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  # curl --data "user[username]=goggin13&user[bio]=hello world" localhost:3000/mongoid/single_insert
  def single_update
    @user = MongoidUser.find(params[:id])

    if @user.update_attributes(params[:user])
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def single_destroy
    @user = MongoidUser.find(params[:id])
    @user.destroy
    head :no_content
  end
  
  def single_query
    @user = MongoidUser.find(params[:id])
    render json: @user
  end
    
  def embedded_insert
    @user = MongoidUser.find(params[:id])
  	@post = @user.mongoid_posts.build params[:post]
  	
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
  
  def embedded_update
    @post = MongoidUser.find(params[:id]).mongoid_posts.find(params[:post_id])
  	
    if @post.update_attributes params[:post]
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end   
  end
  
  def embedded_destroy
    @post = MongoidUser.find(params[:id]).mongoid_posts.find(params[:post_id])
  	@post.destroy
    head :no_content
  end
  
  def embedded_query
    @post = MongoidUser.find(params[:id]).mongoid_posts.find(params[:post_id])
  	render json: @post
  end  
end
