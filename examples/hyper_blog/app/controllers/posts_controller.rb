class PostsController < ApplicationController
  
  before_filter :redirect_unless_signed_in, 
                only: [:edit, :update, :new, :create, :destroy]
  
  # GET /posts
  # GET /posts.json
  def index
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @title = "Posts tagged with \"#{@tag.name}\""
      @posts = @tag.posts.sort { |a,b| a.created_at <=> b.created_at }
    else
      @title = "All Posts"
      @posts = Post.where(order: :created_at, sort: :desc)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @user =  @post.user
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = current_user.posts.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = current_user.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @query = params[:query]
    @title = "Results for '#{@query}'"
    @posts = Post.where(title: @query)

    respond_to do |format|
      format.html { render "index.html.erb" }
      format.json { render json: @posts }
    end
  end
end
