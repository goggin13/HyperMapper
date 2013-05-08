class HyperController < ApplicationController

  MAX_USER_ID = 10000
  MAX_POST_ID = 25
  
  def single_insert
    @user = User.new(params[:user])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def single_query
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      User.find random_user_id
    end
    render :json => results
  end

  def single_update
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      user_id = random_user_id
      user = User.find user_id
      user.username = "user-#{random_user_id}"
      user.save

      user
    end
    render :json => results
  end
  
  def embedded_insert
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      user = User.find random_user_id
    	post = user.posts.build params[:post]
      post.save

      post
    end
    render :json => results    
  end
  
  def embedded_update
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      user = User.find random_user_id
    	post = user.posts.find random_post_id
    	post.title = "new title -> #{random_post_id}"
      post.save

      post
    end
    render :json => results    
  end
  
  def embedded_query
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      User.find(random_user_id).posts.find(random_post_id)
    end
    render :json => results
  end
  
  private
    
    def random_post_id
      Random.rand(MAX_POST_ID) + 1
    end
    
    def random_user_id
      Random.rand(MAX_USER_ID) + 1
    end
end
