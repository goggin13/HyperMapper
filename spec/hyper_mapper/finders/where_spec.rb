require "spec_helper"

describe 'HyperMapper::Document::Finders' do
  
  before :all do
    class FinderTestClass
      include HyperMapper::Document
      attribute :field_1, key: true
      attribute :field_2
    end
  end

  after :all do
    Object.send(:remove_const, :FinderTestClass)
  end
  
  before do
    @client = stub_client
  end

  describe "where" do
    
    describe "with results" do
      
      before do
        @client.should_receive(:search)
               .with('finder_test_classes', {field_2: 'hello'})
               .and_return([{field_1: "test", field_2: "hello"}])
      end

      it "should return a collection of length 1" do
        (FinderTestClass.where field_2: "hello").length.should == 1
      end

      it "should return a collection containing existing instances" do
        results = FinderTestClass.where field_2: "hello"
        results[0].should be_a FinderTestClass
        results[0].field_1.should == "test"
        results[0].field_2.should == "hello"
      end      
    end

    describe "sorted" do

      before do
        @client.should_receive(:search)
               .with('finder_test_classes', {field_2: 'hello'})
               .and_return([
                 {field_1: "c", field_2: "hello"},
                 {field_1: "a", field_2: "hello"},
                 {field_1: "b", field_2: "hello"}
               ])
      end

      it "should sort the results ascending by default if requested" do
        results = FinderTestClass.where field_2: "hello", order: :field_1
        results[0].field_1.should == 'a'
        results[1].field_1.should == 'b'
        results[2].field_1.should == 'c'
      end

      it "should sort the results desc if requested" do
        results = FinderTestClass.where field_2: "hello", order: :field_1, sort: :desc
        results[2].field_1.should == 'a'
        results[1].field_1.should == 'b'
        results[0].field_1.should == 'c'
      end
    end

    describe "without results" do

      it "should return an empty array" do
        @client.should_receive(:search)
               .with('finder_test_classes', {field_2: 'hello'})
               .and_return([])      
        results = FinderTestClass.where field_2: "hello"
        results.should == []
      end
    end
  end

  describe "find" do

    describe "with results" do
      
      it "should return the matching object" do
        @client.should_receive(:get)
               .with('finder_test_classes', 'test')
               .and_return({field_2: "hello"})
        result = FinderTestClass.find('test')
        result.should be_a FinderTestClass
        result.field_1.should == 'test'
        result.field_2.should == 'hello'
      end
    end

    describe "without results" do

      it "should return nil" do
        @client.should_receive(:get)
               .with('finder_test_classes', 'test')      
               .and_return(nil)
        result = FinderTestClass.find('test')
        result.should be_nil
      end
    end
  end
end
