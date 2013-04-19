require 'spec_helper'

describe 'HyperMapper::Document::Embed' do
  
  before do
    @client = stub_client
    @attrs = {username: 'goggin13', 
              email: 'goggin13@example.com',
              posts: [
                       {title: 'Hello world', id: 1},
                       {title: 'Goodbye world', id: 2}
                     ]}
    @user = User.new @attrs
  end

  describe "embeds_many" do
    
    it "should be a method on the class" do
      User.should respond_to :embeds_many
    end
    
    it "embedded? should return false" do
      User.embedded?.should be_false
    end    

    it "should add a plural function name to the parent object" do
      @user.should respond_to :posts
    end

    it "should return the relevant posts" do
      @user.posts[0].should be_a Post
      @user.posts[1].should be_a Post
      @user.posts[0].title.should == 'Hello world'
      @user.posts[1].title.should == 'Goodbye world'
      @user.posts[0].id.should == 1
      @user.posts[1].id.should == 2
    end
    
    it "should not mark the returned posts from new as persisted" do
      @user.posts[0].should_not be_persisted
    end
    
    describe "from find" do

      before do
        attrs = {
            posts: {'1' => {title: 'Hello world'}.to_json,
                    '2' => {title: 'Goodbye world'}.to_json}
          }
        stub_get 'users', 'goggin13', attrs
        @user = User.find 'goggin13'
      end

      it "should mark the returned posts as persisted if retrieved via find" do
        @user.posts[0].should be_persisted
      end

      it "should set the id on the child objects" do
         @user.posts[0].id.should == '1'
         @user.posts[1].id.should == '2'
      end
    end

    it "should be able to be added to" do
      post = Post.new id: 3, title: "test"
      @user.posts << post
      @user.posts.length.should == 3
      @user.posts.find(3).user.username.should == @user.username
    end

    it "should return the first item" do
      @user.posts.first.title.should == 'Hello world'
    end

    it "should offer a find method" do
      @user.posts.find(2).title.should == 'Goodbye world'
    end
    
    it "should return an empty array if no key for posts is returned" do
      stub_get 'users', 'test', {username: 'test', posts: ''}
      (User.find 'test').posts.length.should == 0
    end

    it "should offer a create method" do
      @user.posts.should respond_to :create
    end
    
    it "should create 2 posts for two subsequent create calls" do
      stub_any_put 'users', 'goggin13'
      @user.save
      stub_map_add 'users', 'goggin13', {
        'posts' => { "4" => "{\"title\":\"test4\"}" }
      }
      @user.posts.create! title: 'test4', id: "4"
      stub_map_add 'users', 'goggin13', {
        'posts' => { "5" => "{\"title\":\"test5\"}" }
      }
      @user.posts.create! title: 'test5', id: "5"
    end
  end

  describe "embedded_in" do
    
    before do
      @post = @user.posts[0]
    end

    it "should be a method on the class" do
      Post.should respond_to :embedded_in
    end

    it "embedded? should return true" do
      Post.embedded?.should be_true
    end
      
    it "should add a singular function name to the child object" do
      @post.should respond_to :user
    end

    it "should add a parent functionto the child object" do
      @post.should respond_to :parent
    end    

    it "should return the relevant user" do
      user = @post.user
      user.should be_a User
      user.username.should == 'goggin13'
      user.email.should == 'goggin13@example.com'
    end

    it "should return the relevant user" do
      user = @post.parent
      user.should be_a User
      user.username.should == 'goggin13'
      user.email.should == 'goggin13@example.com'
    end

    it "should set an autogenerated id on the child" do
      user = User.new(username: 'goggin13')
      stub_any_put 'users', 'goggin13'
      user.save
      stub_auto_id_map_add 'users', user.username, "{\"title\":\"test\"}"
      post = user.posts.create! title: 'test22'
      post.should be_persisted
    end
    
    it "should save the parent" do
      user = User.new(username: 'goggin13')
      stub_any_put 'users', 'goggin13'
      user.save
      user.should be_persisted
    end

    describe "destroy" do

      before do
        stub_put 'users', @user.username, {
          email: "goggin13@example.com", 
          posts: {"2"=>"{\"title\":\"Goodbye world\"}"}
        }
      end

      it "should remove the post" do
        expect {
          @user.posts[0].destroy
        }.to change(@user.posts, :length).by(-1)
      end
    end
  end  
end
