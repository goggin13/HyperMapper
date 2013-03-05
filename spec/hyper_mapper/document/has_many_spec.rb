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
    
    it "should return a collection whos foreign key returns user_id" do
      @user.articles.foreign_key.should == 'user_id'
    end

    it "should return the relevant articles" do
      @user.articles[0].should be_a Article
      @user.articles[1].should be_a Article
      @user.articles[0].title.should == 'Hello world'
      @user.articles[1].title.should == 'Goodbye world'
      @user.articles[0].id.should == 1
      @user.articles[1].id.should == 2
    end
    
    it "should not mark the returned posts from new as persisted" do
      @user.articles[0].should_not be_persisted
    end

    it "should be able to be added to" do
      post = Article.new id: 3, title: "test"
      @user.articles << post
      @user.articles.length.should == 3
      @user.articles.find(3).user.username.should == @user.username
    end

    it "should return the first item" do
      @user.articles.first.title.should == 'Hello world'
    end

    it "should offer a find method" do
      stub_search 'articles', 
                  {'user_id' => 'goggin13', 'id' => 2}, 
                  [{title: 'Goodbye world', id: 2}]
      article = @user.articles.find(2)
      article.title.should == 'Goodbye world'
      article.id.should == 2
    end
    
    it "should offer a create method" do
      @user.articles.create! title: "test"
    end
  end

  describe "belongs_to" do
    
    before do
      @article = @user.article[0]
    end

    it "should add a singular function name to the child object" do
      @article.should respond_to :user
    end

    it "should add a parent functionto the child object" do
      @article.should respond_to :parent
    end    

    it "should return the relevant user" do
      user = @article.user
      user.should be_a User
      user.username.should == 'goggin13'
      user.email.should == 'goggin13@example.com'
    end
  end  
end
