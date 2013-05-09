# HyperMapper	

## Overview

HyperMapper is an Ruby Object Document Mapper for [HyperDex](http://hyperdex.org/), a new NoSQL store from Cornell University.  It has been tested in Ruby 1.9.3, and plays nicely with Rails 3.2.x. 

HyperMapper, like HyperDex itself is a work in progress and is not (yet) well vetted in production.  Please, I welcome any feedback, pull-requests, issues, etc.., either here on Github, or find me at [goggin13@gmail.com](mailto:goggin13@gmail.com).

## Examples
```
class User
  include HyperMapper::Document
  
  attr_accessor :password

  key :username
  attribute :email
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
  has_and_belongs_to_many :tags, through: :post_tags
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

class Tag
  include HyperMapper::Document

  attr_accessible :name

  autogenerate_id
  attribute :name
  
  has_and_belongs_to_many :posts, through: :post_tags
end

class PostTag
  include HyperMapper::Document

  attr_accessible :tag_id, :post_id

  autogenerate_id
  attribute :tag_id
  attribute :post_id

end

user = User.create! username: 'goggin13', 
                    email: 'goggin13@gmail.com'

post = user.posts.create! title: 'My new post', content: 'more great content'
post.tags.create! :name "TestTag"
comment = post.comments.create! text: "hello world", user_id: user.id
```


## Document API

### HyperDocument

#### Queries

These query operators **are not** defined for embedded objects. 

##### :: where(predicate={})
Returns a Ruby array of objects which match the given predicate.

```
User.where(age: 25)
```

##### :: count(predicate={})
Returns the number of objects in the space that match the given predicate.

~> only defined for Documents, and not embedded objects. 

```
User.count(age: 25)
```

##### :: all
Return a Ruby array of all of the objects in a given space.  Consider against ever using this if you have a non-trivial number of objects in your space.

```
User.all
```

##### :: find(id)
Issues a HyperDex get request to locate a given object by it's defined key.

```
user = User.find("goggin13")
```

##### :: find_all(ids)
Issues a series of HyperDex get request to locate a set of given objects by their keys.  The requests are issued in parallel, but the function call will only return when all the objects have been returned.

```
users = User.find_all(["goggin13", "rescrv"])
```

#### Creating Objects
##### :: new(attributes)
Creates a new object with the given attributes, but does not persist it.

```
user = User.new(username: "goggin13", email: "goggin13@gmail.com")
```

##### :: create(attributes)
Create and persist a new object with the given attributes.  On failures, `.valid?` will return false, and `.errors` will be populated.  Any key in `attributes` must have been listed in a call to `attr_accessible`, otherwise a `HyperMapper::Exceptions::MassAssignmentException` is thrown.

```
user = User.create! username: "goggin13", email: "goggin13@gmail.com"
if user.valid?
  puts "success"
else
  user.errrors.full_messages.each { |err| puts err }
end
```

##### :: create!(attributes)
Identical to `create`, except `create!` will raise `HyperMapper::Exceptions::ValidationException` On validation errors.

#### Defining Attributes
##### :: attribute(name, options={})
Define an attribute for the given model, which you can then read, write, and persist.

`options` is an optional hash which currently only supports defining the datatype, which defaults to :string.  Other available datatypes are  

* int
* float
* datetime

```
class User
  attribute :name
  attribute :age, type: :int
end
```

##### :: attr_accessible(attributes=[])
Defines the attributes that may be modified via mass assignment (through calls to `new`, `create`, or `update_attributes`). 
	
##### :: key(name)
Defines the attribute that will serve as this objects key attribute.  Either this or `autogenerate_id` is required to be defined. 

```
class User
  key :username
end
```

##### :: autogenerate_id
Defines an `id` attribute that will be automatically populated with a unique ID on every new insert.

```
class User
  autogenerate_id
end
```

##### :: timestamps
Defines two new datetime attributes `updated_at` and `created_at`, which HyperMapper will maintain automatically on inserts and updates to the object.

```
class User
  timestamps
end
```

#### Defining Relationships
##### :: has_many(child_classes)
Creates a has many relationship between the parent and child class.  This method presumes that there is an attribute on the child class of the form parent_class_name_id.

```
class User
  # Here it is assumed every post object has a user_id attribute
  has_many :posts
end
```

This creates a new function, `.posts` for a user.  `user.posts` will return a `HyperMapperCollection` which can be queried and manipulated.  

##### :: belongs_to(parent_class)
The converse of `has_many`; defines a function on this class to retrieve it's parent object.  Presumes this class has an attribute of the form parent_class_name_id.

```
class Post
  attribute :user_id
  belongs_to :user
end
```

Now, `post.user` will retrieve the relevant `User` object.

##### :: embeds_many(child_classes)
Declares that this class maintains an embedded field which contains a collection of the child class.

```
class Post
  embeds_many :comments
end
```

Now, `post.comments` returns a `HyperMapperCollection` which can be queried, manipulated and added to.   

##### :: embedded_in(parent_class_name)
The converse of `embeds_many`, defines a singular method on the child to retrieve the parent object.  An embedded object does not occupy a HyperDex space, but exists only as an element of a field on it's parent.

```
class Comment
  embedded_in :post
end
```

Now, `comment.post` will return the parent item, and the comment object itself will be serialized and persisted on the parent `Post` object.  

##### :: has_and_belongs_to_many(class_name, options)
This creates a many to many relationship between two classes.  The final result is similar to `has_many`, but the mechanics are a bit more involved as a intermediate space is required.  `options` is required, and must contain the name of the intermediate class.

```
class Post
  has_and_belongs_to_many :tags, through: :post_tags
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

Now, `post.tags` returns a `HyperMapperCollection` which supports the methods described further below.  

#### Callbacks
##### :: before_create(function_name)
##### :: after_create(function_name)
##### :: around_create(function_name)
Name a function that will be called (before|after|around) an object's creation.  

##### :: before_save(function_name)
##### :: after_save(function_name)
##### :: around_save(function_name)
Name a function that will be called (before|after|around) the saving of an object.

#### Instance Methods
##### \# save
Persist an object to HyperDex, returning true if the put was successful. On failures, `valid?` will return false, and `.errors` will contain information about the validation failure.

```
user = User.new username: "goggin13"
if user.save 
  puts "success"
else
  user.errors.full_messages.each { |err| puts err }
end
```

##### \# save!
Identical to `save`, but `save!` will raise `HyperMapper::Exceptions::ValidationException` On validation errors.

##### \# update_attributes(attributes={})
Sets the given attributes to the passed values; any key in `attributes` must have been listed in a call to `attr_accessible`, otherwise a `HyperMapper::Exceptions::MassAssignmentException` is thrown.  Returns true on success, and false on validation failures.

```
user.update_attributes! username: "mg343", email: "mg343@cornell.edu"
```

##### \# update_attributes!(attributes={})
Identical to `update_attributes`, but `update_attributes!` will raise `HyperMapper::Exceptions::ValidationException` On validation errors.

##### \# destroy
Remove this object from HyperDex.  

##### \# persisted?
Returns true if the given object has been persisted.  

### HyperMapperCollection

These functions represent the API provided for relationships in HyperMapper; namely, a `HyperMapperCollection` is returned from calls to a child class defined via `has_many`, `embeds_many` or `has_and_belongs_to_many`, and offers the API defined below.

`HyperMapperCollection` also supports the [Ruby Enumerable API](http://ruby-doc.org/core-2.0/Enumerable.html) (but not the enumerable comparator features, e.g. `#max`, `#sort`, etc).

##### \# find(id)
Returns an element of the child collection with the given ID.

```
post = user.posts.find(4)
```

##### \# where(predicate)
Returns an array of the child collection that matches the given predicate.  

*where is not supported on embedded collections*

```
posts = user.posts.where(title: "hello world")
```

##### \# remove(item)
Removes the given item from this collection; in the case of an embedded object this deletes it from HyperDex.

```
post = user.posts.find(4)
user.posts.remove(post)
```

##### \# <<(item)
Adds a new item to this collection.

```
post = Post.new(title: "test", content: "content")
user.posts << post
```

##### \# each(&block)
Iterates the collection and calls the given block for each item.

```
user.posts.each do |post|
  puts post.title, post.content
end
```

##### \# length
The number of elements in the child collection.

```
user.posts.length
```

##### \# all
Returns an array of all the objects in the child collection.

##### \# create(attributes)
Create and persist a new object with the given attributes, and assign it to this collection. On failures, `.valid?` will return false, and `.errors` will be populated.  Any key in `attributes` must have been listed in a call to `attr_accessible`, otherwise a `HyperMapper::Exceptions::MassAssignmentException` is thrown.  

post = user.posts.create(title: "test", content: "content")
if post.valid? 
  puts "success"
else
  post.errors.full_messages.each { |err| puts err }
end

##### \# create!(attributes)
Identical to `HyperMapperCollection#create`, but `create!` will raise `HyperMapper::Exceptions::ValidationException` On validation errors.

##### \# build(attributes)
Returns a non-persisted child item belonging to this collection.

```
post = user.posts.build.create(title: "test", content: "content")
if post.save 
  puts "success"
else
  post.errors.full_messages.each { |err| puts err }
end
```