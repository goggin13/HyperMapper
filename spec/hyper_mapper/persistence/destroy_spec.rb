require "spec_helper"

describe 'HyperMapper::Persistence.destroy' do

  before do
    @client = stub_client
    @instance = User.new username: 'goggin', email: 'matt@example.com'
  end

  describe "destroy" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      @client.should_receive(:delete).with('users', 'goggin')
      @instance.destroy
    end
  end
end

