require 'spec_helper'

=begin
tag article id=2 with tag id=1
  query for tag_to_article(2, 1)
    return if exists
    else insert it

displaying tag cloud
  query tag_to_articles
  with results...?
    iterate and query tag to get name?

instead of join table should tag have a list of article ids on it?
  no, because how would an article get its tags
=end

describe 'HyperMapper::Document::HasAndBelongsToMany' do
  
  before do
    @client = stub_client
    @attrs = {name: "tagName"}
    @tag = Tag.new @attrs
  end

  describe "has_and_belongs_to_many" do

    it "should be a method on the class" do
      Tag.should respond_to :has_and_belongs_to_many
    end
    
    it "should add a plural function name to the parent object" do
      @tag.should respond_to :articles
    end
    
    xit "should be able to be added to" do
      post = Article.new title: "test"
      stub_auto_id_put 'articles', {user_id: @user.username, title: 'test'}
      @tag.articles << post
    end

    xit "should return the first item" do
      stub_search 'articles', 
                  {'user_id' => 'goggin13'}, 
                  [{title: 'Goodbye world', user_id: @user.username, id: 2}]      
      @user.articles.first.title.should == 'Goodbye world'
    end

    xit "should offer a find method" do
      stub_search 'articles', 
                  {'user_id' => 'goggin13', 'id' => 2}, 
                  [{title: 'Goodbye world', id: 2}]
      article = @user.articles.find(2)
      article.title.should == 'Goodbye world'
      article.id.should == 2
      article.persisted.should be_true
    end
    
    xit "should offer a create method" do
      stub_auto_id_put 'articles', {title: 'test', user_id: @user.username}
      article = @user.articles.create! title: "test"
      article.user_id.should == @user.username
      article.id.should_not be_nil
      article.id.length.should == 32
      article.title.should == 'test'
    end
  end
end
