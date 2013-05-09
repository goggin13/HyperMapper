require "spec_helper"

describe 'HyperMapper::Persistence' do

  before do
    @client = stub_client
  end

  describe "create!" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      stub_put 'users', 'goggin', {email: 'matt@example.com'}
      User.create! username: 'goggin',
                   email: 'matt@example.com'
    end
  end
 
  describe "create" do
    
    it "should pass the correct arguments to the hyperdex-client" do
      stub_put 'users', 'goggin', {email: 'matt@example.com'}
      User.create username: 'goggin',
                  email: 'matt@example.com'
    end

    it "should populate errors on the returned object" do 
       user = User.create email: 'matt@example.com'
       user.errors.full_messages[0].should == "Username can't be blank"
    end
  end

  describe "create_space" do

    it "should generate the add-space command" do
      command = <<EOF
space users 
key username
attributes email, map(string, string) posts
subspace username, email, posts
tolerate 2 failures
EOF
      @client.should_receive(:add_space).with(command)
      User.create_space
    end

    it "should include the right data types" do
      command = <<EOF
space user_attributes 
key username
attributes test_string, int test_int, float test_float, int test_datetime
subspace username, test_string, test_int, test_float, test_datetime
tolerate 2 failures
EOF

      @client.should_receive(:add_space).with(command)
      UserAttribute.create_space
    end    
  end

  describe "destroy_space" do

    it "should generate the rm-space command" do
      @client.should_receive(:rm_space).with('users')
      User.destroy_space
    end
  end
end
