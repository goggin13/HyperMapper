require 'spec_helper'

describe Post do 
	
	before do
		@valid_attrs = {
			title: 'test', 
			content: 'hello world',
			tag_string: 'tagOne, tagTwo'
		}
	end

	describe "tag_string" do

		it "should add tags to a post" do
			post = Post.create! @valid_attrs
			tag_names = post.tags.map { |t| t.name }
			tag_names.should include 'tagone'
			tag_names.should include 'tagtwo'
		end

		it "should remove tags to a post" do
			post = Post.create! @valid_attrs
			post.update_attributes! tag_string: 'tagthree'
			tag_names = post.tags.map { |t| t.name }
			tag_names.should_not include 'tagone'
			tag_names.should_not include 'tagtwo'
			tag_names.should include 'tagthree'
		end		
	end
end