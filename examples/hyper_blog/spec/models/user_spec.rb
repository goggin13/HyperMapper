require 'spec_helper'

describe User do

	before do
		@valid_attrs = {
			username: 'matt',
			password: 'password'
		}
	end

	describe "hashed_password" do
		it "should be set after saving the user" do
			user = User.new(@valid_attrs)
			user.hashed_password.should be_nil
			user.save!
			user.hashed_password.should_not be_nil
		end
	end
end