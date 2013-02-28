require 'spec_helper'

describe 'HyperMapper::Document::Embed' do
  
  before do
    @client = stub_client
    @user = User.new username: 'goggin13', 
                     email: 'goggin13@example.com',
                     posts: [
                       {title: 'Hello world', id: 1},
                       {title: 'Goodbye world', id: 2}
                     ]
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

    it "should persist the parent object" do
      @post.title = 'a new title'
      @user.email = 'new@example.com'
      @client.should_receive(:put)
             .with('users', 'goggin13',
                   {email: 'new@example.com',
                    posts: [
                     {title: 'a new title', id: 1},
                     {title: 'Goodbye world', id: 2}
                   ]})
      @post.save
    end
  end  
end
