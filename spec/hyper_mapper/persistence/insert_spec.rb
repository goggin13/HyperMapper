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

    xit "should raise an error for invalid input" do
      expect {
        User.create! email: 'matt@example.com'
      }.should raise_error HyperMapper::Exceptions::NullKeyException
    end
  end
end


