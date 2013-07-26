require 'spec_helper'

describe 'HyperMapper::Document::Equality' do

  before do
    @attrs = {username: 'goggin13', email: 'goggin13@example.com'}
    @user = User.new @attrs
  end

  describe "==" do
    it "returns false if the classes do not match" do
      (@user == Post.new).should be_false
    end

    it "returns false if the ids do not match" do
      (@user == User.new(username: "user_2_id")).should be_false
    end

    it "returns true if the ids match" do
      (@user == User.new(username: "goggin13")).should be_true
    end
  end
end
