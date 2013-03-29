require "spec_helper"

describe 'HyperMapper::Document::Attribute' do
  
  before do
    class AttributeTestClass
      include HyperMapper::Document
      attribute :field_name
      attribute :key_name, key: true
    end
  end

  after do
    Object.send(:remove_const, :AttributeTestClass)
  end

  describe "attribute" do
    
    before do
      @instance = AttributeTestClass.new
    end
    
    describe "setter" do

      it "should create a setter and a getter on an instance" do
        @instance.should respond_to(:field_name=)
        @instance.should respond_to(:field_name)
      end

      it "should set the fields value" do
        @instance.field_name = 'a string'
        @instance.field_name.should == 'a string'
      end

      it "should overwrite an existing value" do
        @instance.field_name = 'a string'
        @instance.field_name = 'a second string'
        @instance.field_name.should == 'a second string'
      end
    end
    
    describe "getter" do

      it "should create a getter on an instance" do
        @instance.should respond_to(:field_name)
      end

      it "should return nil if the field hasn't been set" do
        @instance.field_name.should be_nil
      end
    end
  end

  describe "space_name" do

    it "should default to the plural class name" do
      AttributeTestClass.space_name.should == 'attribute_test_classes'
    end
    
    it "should respect and overriden value" do
      AttributeTestClass.space_name = 'overriden'
      AttributeTestClass.space_name.should == 'overriden'
    end
  end

  describe "key_name" do
    
    it "should equal the attribute denoted as the key" do
      AttributeTestClass.key_name.should == :key_name
    end

    it "should should validate presence of the key" do
      AttributeTestClass.new(field_name: 'test').should_not be_valid
    end

    it "should raise an error if it is modified" do
      @instance = AttributeTestClass.new(field_name: 'test', key_name: 'key')
      @client = stub_client
      stub_any_put 'attribute_test_classes'
      @instance.save
      @instance.key_name = 'new'
      expect {
        @instance.save
      }.to raise_error HyperMapper::Exceptions::IllegalKeyModification
    end
  end
end
