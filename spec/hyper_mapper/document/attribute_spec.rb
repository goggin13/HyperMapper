require "spec_helper"

describe 'HyperMapper::Document::Attribute' do
  
  before do
    class AttributeTestClass
      include HyperMapper::Document
    end
  end

  after do
    Object.send(:remove_const, :AttributeTestClass)
  end

  describe "attribute" do
    
    before do
      class AttributeTestClass
        attribute :field_name
      end
      @instance = AttributeTestClass.new
    end
    
    describe "setter" do

      it "should create a setter on an instance" do
        @instance.should respond_to(:field_name=)
      end

      it "should set the fields value" do
        @instance.field_name = "a string"
        @instance.field_name.should == "a string"
      end

      it "should overwrite an existing value" do
        @instance.field_name = "a string"
        @instance.field_name = "a second string"
        @instance.field_name.should == "a second string"
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
end



