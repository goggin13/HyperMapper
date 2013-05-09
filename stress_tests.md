## HyperDex/HyperMapper Performance vs Mongo/Mongoid

This post summarizes my findings of some very simple stress tests comparing the performance in Rails of [HyperDex](hyperdex.org) running behind the [HyperMapper Object Document Mapper](https://github.com/goggin13/HyperMapper) with [Mongo](http://www.mongodb.org/) running behing the [Mongoid Object Document Mapper](Mongoid.org).

My tests relied on [httperf](http://www.hpl.hp.com/research/linux/httperf/) to generate and measure HTTP requests against two applications running the relevant code.  

### Setup

These tests were each ran on Amazon EC2 with 4 M1 Medium Instances for each application; 2 instances were dedicated to the storage system (either Mongo or HyperDex), 1 instance ran the sample Rails application, and 1 ran a battery of httperf benchmarks.

Each indvidual test (which are described in detail below) consisted of running this command 5 times  

```
httperf --hog \
        --server PRIVATE_IP_OF_DATASTORE \
        --port PORT_OF_DATA_STORE \
        --uri URI_OF_TEST \
        --num-conns 3000
```

And the averaged results are displayed below along with the details of each test.

### Results

For the full code of each test application, see [here](https://github.com/goggin13/HyperMapperExamples/tree/master/perf_hyper_mapper) for the HyperMapper Rails app and [here](https://github.com/goggin13/HyperMapperExamples/tree/master/perf_mongoid) for the Mongoid Rails app.  The controller code for each app is identical; only the code in the `app/models` directory differs.  

Througout the code samples you will see references to these two functions  
  
```
  MAX_USER_ID = 10000
  MAX_POST_ID = 25
  
  def random_post_id
    Random.rand(MAX_POST_ID) + 1
  end
    
  def random_user_id
    Random.rand(MAX_USER_ID) + 1
  end
```  

### Non-Embedded Results

#### single insert  
This test performed created a single new object, and returns the JSON after the object has been persisted.   

```
  def single_insert
    @user = User.new(params[:user])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
```
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/single_insert.png)  

#### single query  
This test retrieves a single object, chosen at random from a known existing set of objects, and returns the object formatted as JSON.  

```
  def single_query
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      User.find random_user_id
    end
    render :json => results
  end
```  
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/single_query.png)  

#### single query 10  
This test performs the identitcal task of a single query, but loops 10 times to retrieve 10 random objects.  The code is the same as that for the *single query* test, only the URI used for the test adds the GET parameter `?queries=10`.  
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/single_query_10.png)  

#### single update  
This test retrieves a single object from the data store, updates it, and then returns a JSON representation of the updated object.  

```
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
```
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/single_update.png)  

#### single update 10  
This test loops on the same task that *single update* performs, retrieving and updating 10 objects.  The code is the same as that for the *single update* test, only the URI used for the test adds the GET parameter `?queries=10`.   
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/single_update_10.png)  

### Embedded Results

Since the embedded tests rely on an existing parent object, each of these tests begins by retrieving a randomly chosen parent object from the datastore.

#### embedded insert   
This test inserts a new embedded object onto the retrieved parent object, persists the new object and returns a JSON representation of the new embedded object.    

```
  def embedded_insert
    # get a random row from the database, which we know has 10000
    # rows with ids 1 - 10000
    @user = User.find random_user_id
  	@post = @user.posts.build params[:post]
    
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
```

![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/embedded_insert.png)  

#### embedded query  
This test retrieves a random embedded object from the collection of objects belonging to the parent object, and returns the JSON representation of the embedded object.  

```
  def embedded_query
    queries = (params[:queries] || 1).to_i

    results = (1..queries).map do
      # get a random row from the database, which we know has 10000
      # rows with ids 1 - 10000
      User.find(random_user_id).posts.find(random_post_id)
    end
    render :json => results
  end
```
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/embedded_query.png)  

#### embedded query 10
This test performs the identical task of the *embedded query* test, but loops 10 times to retrieve 10 different embedded objects and return them.  The code is the same as that for the *embedded query* test, only the URI used for the test adds the GET parameter `?queries=10`.  
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/embedded_query_10.png)  

#### embedded update
This test retrieves a parent object and updates a random embedded object on it, then returns the JSON representation of the updated object.  

```
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
```
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/embedded_update.png)  

#### embedded update 10
This test performs the identical task of the *embedded update* test, but loops 10 times to retrieve 10 different embedded objects, update them, and return the updated JSON.  The code is the same as that for the *embedded update* test, only the URI used for the test adds the GET parameter `?queries=10`.  
![image](https://s3.amazonaws.com/matt-goggin/random/hyper-mapper/embedded_update_10.png)  
