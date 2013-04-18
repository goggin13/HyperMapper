require 'spec_helper'

describe 'HyperMapper::Document::HasAndBelongsToMany' do
  
  before do
    @client = stub_client
    @attrs = {name: "tagName"}
    @tag = Tag.new @attrs
    @article_attrs = {id: 'autoid', title: 'test'}
    @article = Article.new @article_attrs
  end

  describe "has_and_belongs_to_many" do

    it "should be a method on the class" do
      Tag.should respond_to :has_and_belongs_to_many
    end
    
    it "should add a plural function name to the parent object" do
      @tag.should respond_to :articles
    end
    
    it "should raise an error if :through is not specified" do
      expect {
        Tag.has_and_belongs_to_many :stuffs
      }.to raise_error HyperMapper::Exceptions::MissingArgumentError
    end

    describe "with children" do

      before do
        stub_search 'article_tags', {'tag_name' => @tag.name}, [
          {'tag_name' => @tag.name, 'article_id' => 1},
          {'tag_name' => @tag.name, 'article_id' => 2},
          {'tag_name' => @tag.name, 'article_id' => 3}
        ]
      end

      it "should return all the child ids" do
        @tag.articles.child_ids.should == [1, 2, 3]
      end
      
      describe "find'" do

        it "should offer a find method" do
          stub_get 'articles', 2, {title: 'Goodbye world', id: 2}
          article = @tag.articles.find(2)
          article.title.should == 'Goodbye world'
          article.id.should == 2
          article.persisted.should be_true
        end
        
        it "should return nil if there isn't a join record" do
          article = @tag.articles.find(4).should be_nil
        end
      end

      describe "collection" do
          
        before do
          stub_multi_get 'articles', [1, 2, 3], [
            {title: 'Hello world', user_id: 1, id: 1},
            {title: 'Goodbye world', user_id: 2, id: 2}
          ]
        end
        
        it "returns all the child objects" do
          @tag.articles[0].title.should == 'Hello world'
          @tag.articles[1].title.should == 'Goodbye world'
        end

        it "supports enumerable methods" do
          @tag.articles.map { |a| a.title }.should == ['Hello world', 'Goodbye world']
        end

        it "should return the first item" do
          @tag.articles.first.title.should == 'Hello world'
        end
      end
    end

    it "should be able to be added to" do
      post = Article.new title: 'test', id: 'id'
      stub_auto_id_put 'article_tags', {article_id: 'id', tag_name: @tag.name}
      @tag.articles << post
    end
    
    it "should offer a create method" do
      stub_auto_id_put 'articles', {title: 'test'}
      @client.should_receive(:put) do |space, id, args|
        space.should == 'article_tags'
        args[:article_id].should_not be_nil
        args[:tag_name].should == @tag.name
      end

      article = @tag.articles.create! title: "test"
      article.id.should_not be_nil
      article.title.should == 'test'
    end
  end
end
