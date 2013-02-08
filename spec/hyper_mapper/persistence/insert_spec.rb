require "spec_helper"

describe 'HyperMapper::Persistence' do

  before do
    @client = double('client')
    HyperMapper::Config.client = @client
  end

  describe "create!" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      @client.should_receive(:put)
             .with('users', 
                   'goggin',
                   {email: 'matt@example.com'})
      User.create! username: 'goggin',
                   email: 'matt@example.com'
    end
  end

  describe "space" do

    before do
      class AttributeTestClass
        include HyperMapper::Document
      end
    end
  
    after do
      Object.send(:remove_const, :AttributeTestClass)
    end

    it "should default to the plural class name" do
      AttributeTestClass.space_name.should == 'attribute_test_classes'
    end
    
    it "should respect and overriden value" do
      AttributeTestClass.space_name = 'overriden'
      AttributeTestClass.space_name.should == 'overriden'
    end
  end
end


