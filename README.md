# HyperMapper	

## Overview

HyperMapper is an Ruby Object Document Mapper for [HyperDex](http://hyperdex.org/), a new NoSQL store from Cornell University.  It has been tested in Ruby 1.9.3, and plays nicely with Rails 3.2.x.

## Examples
```
class User
  include HyperMapper::Document
  
  attr_accessor :password

  key :username
  attribute :username
  timestamps

  
  has_many :posts
end

class Post
  include HyperMapper::Document

  attr_accessor :tag_string
  
  autogenerate_id
  attribute :title
  attribute :content
  attribute :user_id
  timestamps

  belongs_to :user

  embeds_many :comments  
end

class Comment
	include HyperMapper::Document
	
	autogenerate_id
	attribute :text
	attribute :user_id
	
	timestamps
	
	belongs_to :user
	embedded_in :post
end

user = User.create! username: 'goggin13', 
                    email: 'goggin13@gmail.com'

user.posts.create! title: 'My new post', content: 'more great content'
```


## Document API
### Validations
### Callbacks
### Querying
## Relationships
### Querying
### To Embed or Not To Embed

