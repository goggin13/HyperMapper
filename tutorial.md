## HyperMapper in Rails

This tutorial will walk through the construction of a basic application using HyperDex, HyperMapper and Rails.  Like any good Hello World demo, we'll be building a very basic blogging application. 

You can see the finished application in the [example source code](https://github.com/goggin13/HyperMapperExamples/tree/master/HyperMapperDemo).  This is just a skeletal app; if you would like to look at a slightly more polished implementation of this same basic code, [check one out here](https://github.com/goggin13/HyperMapperExamples/tree/master/hyper_blog).

### Prerequisites

We'll start presuming you have Ruby >= 1.9.3, Rails 3.2.x and HyperDex 1.0. 

Additionally, I presume that you have built Rails applications before.  If you're familiar with
[HyperDex](http://hyperdex.org/) that doesn't hurt, but you should be just fine getting through 
this tutorial without any previous HyperDex experience.

If you don't feel like meddling with set up tasks, you may wish to do the tutorial on an EC2 instance.  We have 
provided an AMI with all of the requisite software (ami-51dfb338).

The AMI has all of the required libraries checked out as git repositories and it is  
 
**NOT RECOMMENDED FOR USE IN PRODUCTION**

The current package releases of HyperDex do not yet support the ruby client; a subsequent release should fix this issue.  Just the cost of being on the bleeding edge.  

## Starting HyperDex

If you are using the AMI, then these two commands will fire up a HyperDex coordinator and a single daemon.

```
./tasks/start_local_coordinator.sh  
./tasks/start_local_daemon.sh
```

If you are running on your own machine, these commands will do the same:  

```
hyperdex coordinator -f -l 127.0.0.1 -p 1982 --daemon  
hyperdex daemon -f --listen=127.0.0.1 \  
                   --listen-port=2012 \  
                   --coordinator=127.0.0.1 \  
                   --coordinator-port=1982 \  
                   --data=/home/ubuntu/data/daemon_data \  
                   --daemon  
```

Note that both of these commands should be run from their own directory; the hyperdex programs like to write log files to their current directory, and they will conflict with one another.  The scripts on the AMI will take care of this for you.  

## Creating the Rails Application

We'll start with a new blank Rails app.  

```
~/# rails new HyperMapperDemo --skip-active-record
```

Add the HyperMapper gem to your Gemfile

```
gem 'hyper_mapper', git: 'https://github.com/goggin13/HyperMapper.git'
```

And run 

```
bundle install
```

## HyperDex config

Add the following two files to tell HyperMapper about your HyperDex installation:

config/hyper_mapper.yml

```
host: 127.0.0.1
port: 1982
```

config/initializers/hyper_mapper.rb

```
require 'hyper_mapper'
HyperMapper::Config.load_from_file 'config/hyper_mapper.yml'
```

## Users

Now we can start with the standard Rails generate command.

```
rails generate scaffold User username:string password:string bio:text
```

We'll start with our User model. Instead of inheriting from ActiveRecord, we will include the HyperMapper::Document module.

```
class User
  include HyperMapper::Document
  
  attr_accessor :password
  
  # Determines, as in Rails, which attributes can be modified via mass assignment
  attr_accessible :username, :bio, :password
  
  # HyperMapper will generate a unique ID the first time this 
  # User is saved
  autogenerate_id
  
  # Create two attributes, :username, and :bio
  attribute :username
  attribute :bio
  
  # Things we'll need for authentication
  attribute :salt
  attribute :hashed_password
  attribute :session_id  
  
  # Maintain :created_at and :updated_at timestamps
  timestamps
    
end
```

Generating migrations is not yet supported, so we'll have to create the User space ourselves. `User.create_space` will do the work of making a call to the HyperDex client to create the new space.

```
~/# rails c
1.9.3p392 :001 > User.create_space
```


That's all it takes to start! If you fire up your Rails server you should be able to CRUD in HyperDex all the users you desire.  We aimed to support as much querying and creation functionality that you will be familiar with from using ActiveRecord in Rails.  You can call ```User.create!```, or ```User.new(username: "Matt", bio: "Hello world")```, or ```User.find('some_user_id')```.  Check out [the docs](TODO INSERT LINK) for the rest of the Document API. But for now, you don't need to touch anything, as all the code from the scaffold generator will work as is. Start your Rails server and checkout `/users` to try out your first HyperDex CRUD operations through Rails.


#### Validations
Since HyperMapper includes many of the ActiveModel modules, we have access to validators and callback hooks.

Let's add some simple validators, just like we would in a ActiveRecord model.


```
class User
  include HyperMapper::Document
  
  …
  
  validates :username, presence: true,
                       format: /[a-zA-Z\s]+/
  validates :password, presence: true, if: "hashed_password.blank?"
end
```

#### Callbacks
Let's set up our authentication with a few functions and the `before_save` callback.  Our goal is to take the `:password` field defined with the `attr_accessor` encrypt the password (with a generated salt) and then save both the encrypted password and salt.  The final methods will allow us to authenticate users from our controller.


```
class User
  include HyperMapper::Document
  
  …
  
  before_save :encrypt_password, if: "!password.nil?"
  
  def encrypt_password
    self.salt ||= Digest::SHA256.hexdigest("#{Time.now.to_s}-#{username}")
    self.hashed_password = encrypt(password)
  end

  def encrypt(raw_password)
    Digest::SHA256.hexdigest("-#{salt}-#{raw_password}")
  end
  
  def has_password?(raw_password)
    hashed_password == encrypt(raw_password)
  end

  def self.authenticate(username, plain_text_password)
    user = User.where(username: username)[0]
    return nil unless user && user.has_password?(plain_text_password)
    user
  end
end
```

## Authentication
We'll use these functions, in `app/helpers/session_helper.rb` to help us log users in and out.

#### Helpers
```
module SessionHelper
  
  # Create a new session id for the given user and save it both on the user object,
  # and in a cookie
  def sign_in(user)
    user.session_id = SecureRandom.hex(16)
    user.save
    cookies[:session_id] = user.session_id
    self.current_user = user
  end

  # delete the stored session cookie for this user
  def sign_out_user(user)
    user.session_id = ''
    user.save
    cookies.delete :session_id
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  # if their is a session_id cookie, then attempt to retrieve that user from
  # HyperDex and return them.
  def current_user
    if cookies[:session_id]
      @current_user ||= User.where(session_id: cookies[:session_id])[0]
    else
      nil
    end
  end

  # return true if there is a currently authenticated user
  def signed_in?
    !current_user.nil?
  end
  
  # redirect to the home page with a flash notice
  # unless there is an authenticated user
  def redirect_unless_signed_in
    unless signed_in?
      flash[:notice] = "You must be logged in to access #{request.fullpath}"
      redirect_to users_path
    end
  end  
end
```

And we'll need to include our helper in our base controller, `app/controllers/application_controller`.  

```
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionHelper
end
```


#### Controller

Here's what we'll need for the session_controller


```
class SessionsController < ApplicationController
  
  def new
  end

  def create
  	user = User.authenticate(params[:session][:username], 
                             params[:session][:password])
  	if user
  	  sign_in(user)
  	  flash[:notice] = "Welcome, #{user.username}!"
  	  redirect_to user
  	else
  	  flash[:error] = "Invalid email/password combination"
  	  redirect_to new_session_path
  	end
  end

  def destroy
    flash[:notice] = "Logged out #{current_user.username}"
	  sign_out_user
	  redirect_to users_path
  end

end
```


#### Form

And the login form at `app/views/sessions/new.html.erb`  


```
  <h1>Login</h1>

  <%= form_for(:session, url: sessions_path) do |f| %>

  <div class="field">
    <%= f.label :username %><br />
    <%= f.text_field :username %>
  </div>
  
  <div class="field">
    <%= f.label :password %><br />
    <%= f.password_field :password %>
  </div>
  
  <div class="actions">
    <%= f.submit "Login" %>
  </div>

  <% end %>
```

#### Routes

Finally, after adding the session resource to our routes file we will be able to login at `/sessions/new`.


```
HyperBlog::Application.routes.draw do
	…
	resources :sessions, only: [:new, :create, :destroy]
	… 
end
```

At this point you can log in and log out, but you don't see much visual feedback.  Let's add this simple snippet to `application.html.erb` so we have some idea of when we are logged in or not.  

`app/views/layouts/application.html.erb`

```
<body>

<% if signed_in? %>
  <%= link_to 'Sign out', session_path(current_user), method: :delete %>
<% else %>
  <%= link_to 'Sign in', new_session_path %>
<% end %>

<%= yield %>

</body>
```

## Posts

We'll choose to implement our Post class as a separate entity.  A User will likely have many different posts,  which together could consitutute a reasonable amount of data that we don't want to load every time we want to load a User.

And the Rails scaffold generator will be a good place to start again:

```
rails generate scaffold Post title:string user_id:string content:text
```

And, again, we create our Post model including HyperMapper::Document.

```
class Post
  include HyperMapper::Document

  attr_accessible :title, :content, :user_id
  
  autogenerate_id
  attribute :title
  attribute :content
  attribute :user_id
  
  timestamps

  validates :title, presence: true
  validates :user_id, presence: true
  validates :content, presence: true

  belongs_to :user
  
  # we won't use this yet, but we want to generate this field
  # when we create the new space, so we'll add it now
  embeds_many :comments
end
```

In addition, we can add the corresponding relationship to our User model.

```
class User
  include HyperMapper::Document
  …
  has_many :posts
  … 
end
```

As we did with our User model, we'll create the new space ourselves via `rails c`.

Comments are coming in the next section, but in order to run the new create_space command without complaint, you'll need to create a stubbed out Comment model

`app/models/comment.rb` 

```
class Comment
  include HyperMapper::Document
end
```

And now we can run the create_space command

```
~/# rails c
1.9.3p392 :001 > Post.create_space
```


Let's also head over the the `PostController` and ensure that Users who are creating and editing posts are authenticated, as well as assigning those posts to the current_user.

```
class PostsController < ApplicationController
  
  before_filter :redirect_unless_signed_in, 
                only: [:edit, :update, :new, :create, :destroy]
  …
  # GET /posts/1/edit
  def edit
    @post = current_user.posts.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(params[:post])
	…
  end
  
  # PUT /posts/1.json
  def update
    @post = current_user.posts.find(params[:id])
	… 
  end
  
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    …
  end
  
  …
end  
```

There we go! Now we have ensured users are only editing, updating, destroying their own posts.  We should also remove the `:user_id` field from `app/views/posts/_form.html.erb` since we aren't using it.

## Comments

Comments make a good case for embedding (depending on the quantity we expect to see). Even if they constitute a decent amount of data, it's likely we will always want to load the comments with the post object. 

We are already set to handle Comments from our previous work with Posts, since we included the `map(string, string) comments` data type on Posts.

The scaffolding seems abusive here, so let's do this one by hand. Starting with our Comment model:

```
class Comment
  include HyperMapper::Document

  attr_accessible :text, :user_id

  autogenerate_id
  attribute :text
  attribute :user_id
	
  timestamps
	
  belongs_to :user
  embedded_in :post
end
```

We'll create a `CommentsController` with the following code

```
class CommentsController < ApplicationController
  
  before_filter :redirect_unless_signed_in
  
  def create
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.build text: params[:comment][:text],
                                    user_id: current_user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post }
        format.json { render json: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.find(params[:id])
  	@comment.destroy if @comment
  	
    respond_to do |format|
      format.html { redirect_to @post }
      format.json { head :no_content }
    end
  end
end
```

Now once we add a form to the post page at `app/views/posts/show.html.erb` we will be able to create comments from the post page. We'll also add an (excruciatingly crude) list of comments on this post.

```
<% if signed_in? %>

  <% if current_user.id == @post.user_id %>
    <%= link_to 'Edit', edit_post_path(@post) %>
  <% end %>

  <%= form_for(:comment, url: post_comments_path(@post)) do |f| %>
    <%= f.text_field :text, autocomplete: :off %><br/>
    <%= f.hidden_field :post_id, value: @post.id %>
    <%= f.submit "Comment" %>
  <% end %>
  
<% end %>

<% @post.comments.each do |comment| %>
  <%= comment.text %> <br/>
<% end %>

```

## Tags

Since a tag may have many posts, and a post may have many tags, we will need 
two spaces to store the data for this relationship.  Both a `tags` space and a 
`post_tags` space (think of it as a join table).

We'll create the following 2 models:

```
class Tag
  include HyperMapper::Document

  attr_accessible :name

  autogenerate_id
  attribute :name
  
  has_and_belongs_to_many :posts, through: :post_tags
end
```

```
class PostTag
  include HyperMapper::Document

  attr_accessible :tag_id, :post_id

  autogenerate_id
  attribute :tag_id
  attribute :post_id

end
```

And we can add the `has_and_belongs_to_many` relationship to the Post class as well

```
has_and_belongs_to_many :tags, through: :post_tags
```

As before, we will create the spaces with `rails c`

```
~/# rails c
1.9.3p392 :001 > Tag.create_space
1.9.3p392 :002 > PostTag.create_space
```

In order to facilitate creating tags, we'll add a text field to the post form, which accepts a comma delimted list of tags.

`app/views/posts/_form.html.erb`

```
  <div class="field">
    <%= f.label :tag_string, "Comma delimited tags" %><br />
    <%= f.text_field :tag_string, value: @post.tags_as_string %>
  </div> 
```

We'll add the formatted tags to our post view as well:

```app/views/posts/show.html.erb```

```
  <p>
    <b>Content:</b>
    <%= @post.tags_as_string %>
  </p>
```

And whenever we save a Post object, we will look at the `:tag_string`, parse out the tags, 
and adjust the Post model to reflect those tags.

Here are the necessary changes to the Post class:

```
class Post
  … 
  
  # Create a field in memory to store the tag string
  attr_accessor :tag_string
  
  # Add :tag_string to attr_accessible
  attr_accessible :title, :content, :user_id, :tag_string
  …
   
  # before we save a post, we'll do our tag updates 
  before_save :update_tags
  …
  
  # and the function to update the tags
  def update_tags
    return unless tag_string
    new_tag_names = tag_string.split(",").map { |t| t.strip.downcase }
    current_tag_names = tags.collect(&:name)
    new_tag_names.each do |tag_name| 
      unless current_tag_names.include? tag_name
        tag = Tag.where(name: tag_name)[0]
        tag = Tag.create! name: tag_name unless tag
        self.tags << tag 
      end
    end
    tags.each { |t| (tags.remove t) unless (new_tag_names.include? t.name) }
  end
  
  def tags_as_string
  	tags.collect(&:name).join(', ')
  end
end
```
