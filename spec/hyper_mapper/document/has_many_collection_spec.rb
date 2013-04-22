require 'spec_helper'

describe HyperMapper::Document::HasManyCollection do
  
  before do
    @collection = User.new(username: 'goggin13').articles
    @client = stub_client
  end
  
  it "should respond to all the required methods" do
    verify_collection_interface @collection
  end
  
  describe "find" do
    
    it "should return an item if one exists" do
      stub_search 'articles', {'user_username' => 'goggin13', 'id' => 'generated_id'}, [
        {user_username: 'goggin13', title: 'hello', id: 'generated_id'}
      ]
      article = @collection.find('generated_id')
      article.user_username.should == 'goggin13'
      article.id.should == 'generated_id'
      article.title.should == 'hello'
    end
    
    it "should return null if none exists" do
      stub_get 'users', 'goggin13', nil
      User.find('goggin13').should be_nil
    end
  end
  
  describe "where" do
    
    it "should return an array of matches" do
      stub_search 'articles', {'user_username' => 'goggin13', 'title' => 'hello'}, [
        {user_username: 'goggin13', title: 'hello', id: 'auto_id_0'},
        {user_username: 'goggin13', title: 'hello', id: 'auto_id_1'},
        {user_username: 'goggin13', title: 'hello', id: 'auto_id_2'}
      ]
      articles = @collection.where 'title' => 'hello'
      articles.length.should == 3
      (0..2).each do |i|
        articles[i].user_username.should == 'goggin13'
        articles[i].title.should == "hello"
        articles[i].id.should == "auto_id_#{i}"
      end
    end
  end
  
  describe "remove" do
    
    before do
      stub_put 'articles', 'auto_id_1', {title: 'hello'}
      @article = Article.create! id: 'auto_id_1', title: 'hello'
      stub_put 'articles', 'auto_id_1', {user_username: nil}
    end
    
    it "should remove the item from the collection and return it" do
      item = @collection.remove @article
      item.id.should == @article.id
      item.user_username.should be_nil
    end
  end
  
  describe "<<" do
    
    before do
      stub_put 'articles', 'auto_id_1', {title: 'hello'}
      @article = Article.create! id: 'auto_id_1', title: 'hello'      
    end
    
    it "should add an item to the collection" do
      stub_put 'articles', 'auto_id_1', {user_username: 'goggin13'}
      @collection << @article
    end
  end
  
  describe "each" do
    
    before do 
      stub_search 'articles', {'user_username' => 'goggin13'}, [
        {user_username: 'goggin13', title: 'hello', id: 'auto_id_0'},
        {user_username: 'goggin13', title: 'hello', id: 'auto_id_1'},
        {user_username: 'goggin13', title: 'hello', id: 'auto_id_2'}
      ]
    end
    
    it "should iterate the collection" do
      iterations = 0
      @collection.each do |article|
        article.user_username.should == 'goggin13'
        article.title.should == 'hello'
        iterations += 1
      end
      iterations.should == 3
    end
  end
  
  describe "length" do
    
    it "should return the number of items in the collection" do
      stub_count 'articles', {'user_username' => 'goggin13'}, 5
      @collection.length.should == 5
    end
  end
  
  describe "all" do
    
    before do
      stub_search 'articles', {'user_username' => 'goggin13'}, [
        {user_username: 'goggin13', title: 'hello_0', id: 'auto_id_0'},
        {user_username: 'goggin13', title: 'hello_1', id: 'auto_id_1'},
        {user_username: 'goggin13', title: 'hello_2', id: 'auto_id_2'}
      ]      
    end
    
    it "should return all the elements in the collection" do
      results = @collection.all
      results.length.should == 3
      (0..2).each do |i|
        results[i].title.should == "hello_#{i}"
      end
    end
  end
  
  describe "create" do
    
    before do
      @attrs = {title: 'hello'}
    end
    
    it "should create a new item and add it to the collection" do
      stub_auto_id_put 'articles', title: 'hello', user_username: 'goggin13'
      article = @collection.create @attrs
      article.title.should == 'hello'
      article.should be_persisted
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
    
    it "should return a non persisted new item with the foriegn key set" do
      article = @collection.build title: 'hello'
      article.title.should == 'hello'
      article.user_username.should == 'goggin13'
      article.should_not be_persisted
    end
  end
end