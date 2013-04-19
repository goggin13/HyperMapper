require 'spec_helper'

describe HyperMapper::Document::HasAndBelongsToManyCollection do
  
  before do
    @collection = Article.new(title: 'Test Title').tags
  end
  
  it "should respond to all the required methods" do
    verify_collection_interface @collection
  end
  
  describe "find" do
    
    it "should return an item if one exists"
    it "should return null if none exists"
  end
  
  describe "where" do
    
    it "should return an array of matches"
    
  end
  
  describe "remove" do
    
    it "should the item from the collection"
  end
  
  describe "<<" do
    
    it "should add an item to the collection"
  end
  
  describe "each" do
    
    it "should iterate the collection"
  end
  
  describe "length" do
    
    it "should return the number of items in the collection"
  end
  
  describe "all" do
    
    it "should return all the elements in the collection"
  end
  
  describe "create" do
    
    it "should create a new item and add it to the collection"
    it "should not raise an error on validation failures"
  end
  
  describe "create!" do
    
    it "should create a new item and add it to the collection"
    it "should raise an error on validation failures"    
  end
  
  describe "build" do
    
    it "should return a non persisted new item with the foriegn key set"
  end
end