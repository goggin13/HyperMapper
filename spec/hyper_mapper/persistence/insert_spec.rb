require "spec_helper"

describe HyperMapper::Persistence do

  let(:model) { User }
  
  before do
    @client = double(HyperDex::Client)
    HyperMapper::Config.stub(:client).and_return(@client)
  end

  describe "create!" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      User.create! :username => "goggin",
                   :email => "matt@example.com"
      @client.should_recieve(:put)
             .with('users', 
                   'goggin',
                   {email: 'matt@example.com'})
    end
  end
end

