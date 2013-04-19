require "spec_helper"

describe "datatypes" do

  before do
    @client = stub_client
  end

  describe "embedded" do

  end

  describe "not embedded" do
    
    before do
      @user = UserAttribute.new username: 'goggin13'
    end

    describe "strings" do

      it "should be saved as a string" do
        @user.test_string = 'hello'
        stub_put 'user_attributes', 'goggin13', test_string: 'hello'
        @user.save
      end

      it "should be loaded as a string" do
        stub_get 'user_attributes', 'goggin13', {username: 'goggin13', test_string: 'hello'}
        (UserAttribute.find 'goggin13').test_string.should == 'hello'
      end
    end

    describe "ints" do
      
      it "should be saved as an int" do
        @user.test_int = 1
        stub_put 'user_attributes', 'goggin13', test_int: 1
        @user.save
      end

      it "should convert a string to an int" do
        @user.test_int = '1'
        @user.test_int.should == 1
        stub_put 'user_attributes', 'goggin13', test_int: 1
        @user.save
      end

      it "should be loaded as an int" do
        stub_get 'user_attributes', 'goggin13', {username: 'goggin13', test_int: 1}
        (UserAttribute.find 'goggin13').test_int.should == 1
      end
    end
    
    describe "floats" do
      
      it "should be saved as a float" do
        @user.test_float = 1.0
        stub_put 'user_attributes', 'goggin13', test_float: 1.0
        @user.save
      end

      it "should convert a string to a float" do
        @user.test_float = '1.0'
        @user.test_float.should == 1.0
        stub_put 'user_attributes', 'goggin13', test_float: 1.0
        @user.save
      end

      it "should be loaded as a float" do
        stub_get 'user_attributes', 'goggin13', {username: 'goggin13', test_float: 1.0}
        (UserAttribute.find 'goggin13').test_float.should == 1
      end
    end  

    describe "datetime" do
      
      before do
        @time = Time.now
      end
      
      it "should be saved as an int" do
        @user.test_datetime = @time
        stub_put 'user_attributes', 'goggin13', test_datetime: @time.to_i
        @user.save
      end

      it "should convert an int to a datetime" do
        @user.test_datetime = @time.to_i
        @user.test_datetime.should be_a Time
        @user.test_datetime.to_i.should == @time.to_i
        stub_put 'user_attributes', 'goggin13', test_datetime: @time.to_i
        @user.save
      end

      it "should be loaded as a float" do
        stub_get 'user_attributes', 'goggin13', {username: 'goggin13', test_datetime: @time.to_i}
        @user = UserAttribute.find 'goggin13'
        @user.test_datetime.should be_a Time
        @user.test_datetime.to_i.should == @time.to_i
      end
    end      
  end
end
