require "spec_helper"

describe 'HyperMapper::Finders::Count' do
  
  before do
    @client = stub_client
  end

  it "should add a count function to the Document class" do
    User.should respond_to :count
  end
  
  it "should pass an empty predicate to search" do
    @client.should_receive(:count, {}).and_return 1
    User.count.should == 1
  end

  it "should pass a non empty predicate to search" do
    @client.should_receive(:count, {email: 'goggin13@gmail.com'}).and_return 1
    User.count({email: 'goggin13@gmail.com'}).should == 1
  end
end
