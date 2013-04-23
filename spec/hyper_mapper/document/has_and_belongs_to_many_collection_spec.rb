require 'spec_helper'

describe HyperMapper::Document::HasAndBelongsToManyCollection do
  
  before do
    @client = stub_client
    stub_any_put 'articles'
    @article = Article.create!(title: 'Test Title')
    @collection = @article.tags
  end
  
  it "should respond to all the required methods" do
    verify_collection_interface @collection
  end
  
  describe "find" do
    
    it "should return an item if one exists" do
      stub_search 'article_tags', {'article_id' => @article.id}, [
        {'article_id' => @article_id, 'tag_name' => 'programming'},
        {'article_id' => @article_id, 'tag_name' => 'cycling'}
      ]
      stub_get 'tags', 'programming', description: 'writing awesome code'
      tag = @collection.find('programming')
      tag.name.should == 'programming'
      tag.description.should == 'writing awesome code'
    end
    
    it "should return null if none exists" do
      stub_search 'article_tags', {'article_id' => @article.id}, []
      @collection.find('gardening').should be_nil
    end
  end
  
  describe "where" do
    
    it "should return an array of matches" do
      stub_search 'article_tags', {'article_id' => @article.id}, [
        {'article_id' => @article_id, 'tag_name' => 'programming'},
        {'article_id' => @article_id, 'tag_name' => 'cycling'}
      ]
      stub_search 'tags', {
        name: ['programming', 'cycling'], 
        description: 'writing awesome code'
      }, [ 
        {name: 'programming', description: 'writing awesome code'}
      ]
      results = @collection.where description: 'writing awesome code'
      results[0].name.should == 'programming'
      results[0].description.should == 'writing awesome code'
    end
  end
  
  describe "remove" do
    
    it "should the item from the collection" do
      stub_search 'article_tags', {'article_id' => @article.id, 'tag_name' => 'cycling'}, [
        {id: '2', article_id: @article_id, tag_name: 'cycling'}
      ]
      stub_delete 'article_tags', '2'
      @collection.remove Tag.new(name: 'cycling')
    end
  end
  
  describe "<<" do
    
    xit "should add an item to the collection" do
      
    end
  end
  
  describe "each" do
    
    it "should iterate the collection" do
      stub_search 'article_tags', {'article_id' => @article.id}, [
        {'article_id' => @article_id, 'tag_name' => 'programming'},
        {'article_id' => @article_id, 'tag_name' => 'cycling'}
      ]
      stub_multi_get 'tags', ['programming', 'cycling'], [ 
        {name: 'programming', description: 'writing awesome code'},
        {name: 'cycling', description: 'two wheeled fun'}
      ]
      iterations = 0
      @collection.each do |tag|
        (tag.name == 'programming' || tag.name == 'cycling').should be_true
        iterations += 1
      end
      iterations.should == 2
    end
  end
  
  describe "length" do
    
    it "should return the number of items in the collection" do
      stub_search 'article_tags', {'article_id' => @article.id}, [
        {'article_id' => @article_id, 'tag_name' => 'programming'},
        {'article_id' => @article_id, 'tag_name' => 'cycling'}
      ]
      @collection.length.should == 2
    end
  end
  
  describe "all" do
    
    it "should return all the elements in the collection" do
      stub_search 'article_tags', {'article_id' => @article.id}, [
        {'article_id' => @article_id, 'tag_name' => 'programming'},
        {'article_id' => @article_id, 'tag_name' => 'cycling'}
      ]
      stub_search 'tags', {name: ['programming', 'cycling']}, [ 
        {name: 'programming', description: 'writing awesome code'},
        {name: 'cycling', description: 'two wheeled fun'}
      ]
      results = @collection.all
      results.length.should == 2
      results[0].name.should == 'programming'
      results[1].name.should == 'cycling'
    end
  end
  
  describe "create" do
    
    it "should create a new item and add it to the collection" do
      stub_put 'tags', 'newtag', {description: 'new tag desc'}
      stub_auto_id_put 'article_tags', {'article_id' => @article_id, 'tag_name' => 'newtag'}
      @collection.create name: 'newtag', description: 'new tag desc'
    end
    
    it "should not raise an error on validation failures" do
      tag = @collection.create description: 'new tag desc'
      tag.errors.full_messages.length.should == 1
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
      tag = @collection.build name: 'newtag', description: 'new tag desc'
      tag.name.should == 'newtag'
      tag.description.should == 'new tag desc'
      tag.should_not be_persisted
    end
  end
end