require "spec_helper"

describe 'HyperMapper::Persistence' do

  before do
    @client = stub_client
  end

  describe "create!" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      @client.should_receive(:put)
             .with('users', 
                   'goggin',
                   {email: 'matt@example.com', posts: '[]'})
      User.create! username: 'goggin',
                   email: 'matt@example.com'
    end
  end
 
  describe "create" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      @client.should_receive(:put)
             .with('users', 
                   'goggin',
                   {email: 'matt@example.com', posts: '[]'})
      User.create username: 'goggin',
                  email: 'matt@example.com'
    end

    it "should populate errors on the returned object" do 
       user = User.create email: 'matt@example.com'
       user.errors.full_messages[0].should == "Username can't be blank"
    end
  end
end
