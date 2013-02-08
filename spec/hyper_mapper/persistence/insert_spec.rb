require "spec_helper"

describe 'HyperMapper::Persistence' do

  context "create!" do
    
    before do
      @client = double('client')
      HyperMapper::Config.client = @client
    end

    it "should pass the correct arguments to the hyperdex-client" do
      @client.should_receive(:put)
             .with('users', 
                   'goggin',
                   {email: 'matt@example.com'})
      User.create! username: 'goggin',
                   email: 'matt@example.com'
    end
  end
end


