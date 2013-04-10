require 'spec_helper'

describe 'HyperMapper::Document::Timestamps' do
  
  before do
    @client = stub_client
    @attrs = {email: 'matt@example.com'}
    @user = UserWithTimestamp.new @attrs.merge(username: 'matt')
  end
 
  it "should add a timestamps method to the class" do
    UserWithTimestamp.should respond_to :timestamps
  end

  describe "timestamps" do
    
    before do
      @attrs.merge! created_at: Time.now.to_i, updated_at: Time.now.to_i
    end

    it "should add a created_at attribute" do
      @user.should respond_to :created_at
    end
    
    it "should add an updated_at attribute" do
      @user.should respond_to :updated_at
    end
    
    it "should return a time for created_at" do
      @user.created_at = 1
      @user.created_at.should == Time.at(1)
      @user.created_at.should be_a Time
    end

    it "should return a time for updated_at" do
      @user.updated_at = 1
      @user.updated_at.should == Time.at(1)
      @user.updated_at.should be_a Time
    end

    it "should send created_at and updated_at on initial create" do
      stub_put 'user_with_timestamps', 'matt', @attrs
      @user.save
    end

    it "should only send updated_at on subsequent saves" do
      stub_put 'user_with_timestamps', 'matt', @attrs
      @user.save
      @user.email = 'matt@example2.com'
      @attrs.delete :created_at
      @attrs[:email] = 'matt@example2.com'
      @attrs[:updated_at] = Time.now.to_i
      stub_put 'user_with_timestamps', 'matt', @attrs
      @user.save
    end
  end
end
