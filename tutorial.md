## HyperMapper in Rails

This tutorial will walk through the construction of a basic application using HyperDex, HyperMapper and Rails.  Like any good Hello World demo, we'll be building a very basic blogging application. 

You can see the finished application in the [example source code](https://github.com/goggin13/HyperMapper/tree/master/examples/hyper_blog).

### Prerequisites

We'll start presuming you have Ruby >= 1.9.3, Rails 3.2.x and HyperDex 1.0. 

If don't feel like meddling with set up tasks, you may wish to do the tutorial on an EC2 instance.  We have provided an AMI with all of the requisite software (TODO INSERT AMI ID).

## Creating the Application

We'll start with a new blank Rails app.  

```
~/# rails new HyperMapperDemo
```

Add the HyperMapper gem to your Gemfile

```
gem 'HyperMapper'
```

And run 

```
bundle install
```


## Users

Generating migrations is not yet supported, so we'll have to create the User space ourselves.  This HyperDex command will do the trick:

```
~/# hyperdex add-space <<EOF
space users 
key id 
attributes 
  username,
  bio, 
  int created_at,
  int updated_at
subspace username, bio, created_at, updated_at
tolerate 2 failures
EOF
```

Now we can start with the standard Rails generate command.

```
rails generate scaffold User username:string bio:text
```

We'll start with our User model. Instead of inheriting from ActiveRecord, we will include the HyperMapper::Document module.

```
class User
  include HyperMapper::Document
  
  attr_accessor :password
  
  # HyperMapper will generate a unique ID the first time this 
  # User is saved
  autogenerate_id
  
  # Create two attributes, :username, and :bio
  attribute :username
  attribute :bio  
  
  # Maintain :created_at and :updated_at timestamps
  timestamps
end
```

That's all it takes to start! If you fire up your Rails server you should be able to CRUD in HyperDex all the users you desire.  We aimed to support as much querying and creation functionality that you will be familiar with from using ActiveRecord in Rails.  You can call ```User.create!```, or ```User.new(username: "Matt", bio: "Hello world")```, or ```User.find('some_user_id')```.  Check out [the docs](TODO INSERT LINK) for the rest of the Document API. But for now, you don't need to touch anything, as all the code from the scaffold generator will work as is.


## Posts

We'll choose to implement our Post class as a separate entity.  A User will likely have many different posts,  which together could consitutute a reasonable amount of data that we don't want to load every time we want a User.

As we did with our User model, we'll need to create the new space ourselves.

```
hyperdex add-space <<EOF
space posts 
key id 
attributes 
  title,
  content,
  user_id,
  int created_at,
  int updated_at,
  map(string, string) comments
subspace title, content
tolerate 2 failures
EOF
```

Note that we need a ```(string, string)``` map for any ```embeds_many``` relationships we will want to support (Comments are up next).

And the Rails scaffold generator will be a good place to start again:

```
rails generate scaffold Post title:string user_id:string content:text
```

And, again, we modify the generated Post model to include HyperMapper::Document.

```
class Post
  include HyperMapper::Document

  attr_accessor :tag_string
  
  autogenerate_id
  attribute :title
  attribute :content
  attribute :user_id
  
  timestamps

  validates :title, presence: true
  validates :user_id, presence: true
  validates :content, presence: true

  belongs_to :user
end
```

In addition, we can add the corresponding relationship to our User model.

```
class User
  include HyperMapper::Document
  
  # previous code
  # ...
  
  has_many :posts
end
```

Your CRUD operations will work now on Posts; though currently you have to manually enter the id of the User the post belongs to, as we have no concept of authentication or a current user yet.

## Comments

Comments make a good case for embedding (depending on the quantity we expect to see). Even if they constitute a decent amount of data, it's likely we will always want to load the comments with the post object. 

We are already set to handle Comments from our previous work with Posts, since we included the `map(string, string) comments` data type on Posts.

The scaffolding seems abusive here, so let's do this one by hand. Starting with our Comment model:

```
class Comment
  include HyperMapper::Document
	
  autogenerate_id
  attribute :text
  attribute :user_id
	
  timestamps
	
  belongs_to :user
  embedded_in :post
end
```

We'll create a form for creating comments at `app/views/comments/_form.html.erb`:

```
<%= form_for(:comment, url: post_comments_path(@post), remote: true) do |f| %>
    <%= f.user_id :text %><br/>
    <%= f.text_field :text, autocomplete: :off %><br/>
    <%= f.hidden_field :post_id, value: @post.id %>
    <%= f.submit "Comment" %>
  <% end %>
<% end %>
```

Again, we are for now stuck entering the :user_id by hand until we have an authentication system in place.

## Tags

## Searching

## Authentication

