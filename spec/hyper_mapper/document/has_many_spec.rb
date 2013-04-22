require 'spec_helper'

describe 'HyperMapper::Document::HasMany' do
  
  before do
    @client = stub_client
    @attrs = {username: 'goggin13', 
              email: 'goggin13@example.com'}
    @user = User.new @attrs
  end

  describe "has_many" do
    
    it "should be a method on the class" do
      User.should respond_to :has_many
    end
    
    it "should add a plural function name to the parent object" do
      @user.should respond_to :articles
    end
    
    it "should return a collection whos foreign key returns user_username" do
      @user.articles.foreign_key.should == 'user_username'
    end

    it "should be able to be added to" do
      post = Article.new title: "test"
      stub_auto_id_put 'articles', {user_username: @user.username, title: 'test'}
      @user.articles << post
    end

    it "should return the first item" do
      stub_search 'articles', 
                  {'user_username' => 'goggin13'}, 
                  [{title: 'Goodbye world', user_username: @user.username, id: 2}]      
      @user.articles.first.title.should == 'Goodbye world'
    end

    it "should offer a find method" do
      stub_search 'articles', 
                  {'user_username' => 'goggin13', 'id' => 2}, 
                  [{title: 'Goodbye world', id: 2}]
      article = @user.articles.find(2)
      article.title.should == 'Goodbye world'
      article.id.should == 2
      article.persisted.should be_true
    end
    
    it "should offer a create method" do
      stub_auto_id_put 'articles', {title: 'test', user_username: @user.username}
      article = @user.articles.create! title: "test"
      article.user_username.should == @user.username
      article.id.should_not be_nil
      article.id.length.should == 47
      article.title.should == 'test'
    end
  end

  describe "belongs_to" do
    
    before do
      @article = Article.new title: 'hello', id: 1, user_username: 'goggin13'
    end

    it "should add a singular function name to the child object" do
      @article.should respond_to :user
    end

    it "should return the relevant user" do
      stub_search 'users', 
                 {username: 'goggin13'},
                 [{username: 'goggin13', 
                   email: 'goggin13@example.com'}]
      user = @article.user
      user.should be_a User
      user.username.should == 'goggin13'
      user.email.should == 'goggin13@example.com'
    end
  end  
end
