require "spec_helper"

describe 'HyperMapper::Document::Serialization' do

  before do
    @user_attrs = {username: 'goggin13', email: 'matt@example.com'}
    @user = User.new @user_attrs
  end

  describe "serializable_hash" do
    
    it "should return an objects attributes" do
      @user.serializable_hash.should == @user_attrs
    end
  end

  describe "to_json" do
    it "should return a JSON representation" do
      user_json = "{\"user\":{\"email\":\"matt@example.com\",\"username\":\"goggin13\"}}"
      @user.to_json.should == user_json
    end
  end

  describe "to_xml" do
    it "should return an xml representation" do
      user_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<user>\n  <email>matt@example.com</email>\n  <username>goggin13</username>\n</user>\n"
      @user.to_xml.should == user_xml
    end
  end
end

