require "spec_helper"

describe 'HyperMapper::Persistence' do

  before do
    @client = stub_client
  end

  describe "save" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      @client.should_receive(:put)
             .with('users', 'goggin', {email: 'matt@example.com'})
      user = User.new username: 'goggin', email: 'matt@example.com'
      user.save
    end

    it "should update attributes after they are loaded" do
      @client.should_receive(:get)
             .with('users', 'goggin')
             .and_return({username: 'goggin', email: 'matt@example.com'})
      user = User.find('goggin')
      user.email = 'george@example.com'
      @client.should_receive(:put)
             .with('users', 'goggin', {email: 'george@example.com'})
      user.save
      user.email.should == 'george@example.com'
    end
  end
end
