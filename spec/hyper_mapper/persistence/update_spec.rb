require 'spec_helper'

describe 'HyperMapper::Persistence::Update' do

  before do
    @client = stub_client
  end
  
  before :all do
    class TestClass
      include HyperMapper::Document
      attr_accessible :username, :email, :age
      key :username
      attribute :email
      attribute :age
    end
  end

  after :all do
    Object.send(:remove_const, :TestClass)
  end

  describe 'update_attributes' do
    
    before do
      @attrs = {email: 'matt@example.com', age: '37'}
      stub_get 'test_classes', 'goggin13', @attrs
      @user = TestClass.find 'goggin13'
    end

    it "should set the given attributes" do
      new_attrs = {email: 'new@example.com', age: '52'}
      stub_put 'test_classes', 'goggin13', new_attrs
      @user.update_attributes new_attrs
      @user.email.should == new_attrs[:email]
      @user.age.should == new_attrs[:age]
    end

    it "should only set the given attributes" do
      new_attrs = {email: 'new@example.com'}
      stub_put 'test_classes', 'goggin13', new_attrs
      @user.update_attributes new_attrs
      @user.email.should == new_attrs[:email]
      @user.age.should == @attrs[:age]
    end
  end
end
