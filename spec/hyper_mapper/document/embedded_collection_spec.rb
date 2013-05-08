require 'spec_helper'

describe HyperMapper::Document::EmbeddedCollection do
  
  before do
    @attrs = {email: 'goggin13@example.com',
              posts: [
                       {title: 'Hello world', id: '1'},
                       {title: 'Goodbye world', id: '2'}
                     ]}
                    
    @client = stub_client
    stub_get 'users', 'goggin13', @attrs
    
    @user = User.find('goggin13')
    @collection = @user.posts
  end
  
  it "should respond to all the required methods" do
    verify_collection_interface @collection
  end
  
  describe "find" do

    it "should return an xitem if one exists" do
      post = @collection.find('1')
      post.user.username.should == 'goggin13'
      post.id.should == '1'
    end
    
    it "should return null if none exists" do
      @collection.find('3').should be_nil
    end
  end
  
  describe "where" do
    
    it "should raise a not supported error" do
      expect {
        @collection.where title: 'hello'
      }.to raise_error HyperMapper::Exceptions::NotSupportedException
    end
  end
  
  describe "remove" do
    
    it "should remove the item from the collection and return it" do
      stub_map_remove 'users', 'goggin13', {'posts' => {'1' => 'dummy'}}
      post = @collection.first
      item = @collection.remove post
      item.id.should == post.id
    end
  end
  
  describe "<<" do
    
    before do
      stub_map_add 'users', 'goggin13', {
        'posts' => {'3' => {title: 'hello'}.to_json}
      }
    end
    
    it "should add an item to the collection" do
      post = Post.new id: '3', title: 'hello'
      @collection << post
      @collection.find('3').should == post
      post.should be_persisted
    end
  end
  
  describe "each" do
    
    it "should iterate the collection" do
      iterations = 0
      @collection.each do |post|
        post.user.username.should == 'goggin13'
        iterations += 1
      end
      iterations.should == 2
    end
  end
  
  describe "length" do
    
    it "should return the number of xitems in the collection" do
      @collection.length.should == 2
    end
  end
  
  describe "all" do
    
    it "should return all the elements in the collection" do
      results = @collection.all
      results.length.should == 2
      (0..1).each do |i|
        results[i].user.username.should == "goggin13"
      end
    end
  end
  
  describe "create" do
    
    before do
      @attrs = {title: 'hello'}
    end
    
    it "should create a new item and add it to the collection" do
      stub_auto_id_map_add 'users', 'goggin13', 'posts', @attrs.to_json
      post = @collection.create @attrs
      post.title.should == 'hello'
      puts post.errors.full_messages
      post.should be_persisted
    end
    
    it "should return an object with the validation errors" do
      article = @collection.create({})
      article.errors.full_messages.length.should == 1
      article.should_not be_persisted
    end

    describe "!" do
      it "should raise an error on validation failures" do
        expect {
          @collection.create!({}) 
        }.to raise_error HyperMapper::Exceptions::ValidationException
      end
    end
  end
  
  describe "build" do
    
    it "should return a non persisted new xitem with the foriegn key set" do
      post = @collection.build title: 'hello'
      post.title.should == 'hello'
      post.user.username.should == 'goggin13'
      post.should_not be_persisted
    end
  end

  describe "dirty" do

    it "should not be marked as dirty when retrieved from a find" do
      @user.attribute_values_map[:posts].should_not be_dirty
    end
  end
end