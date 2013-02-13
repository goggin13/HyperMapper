require "spec_helper"

describe 'HyperMapper::Document::Attribute' do
  
  before :all do
    class FinderTestClass
      include HyperMapper::Document

      attribute :field_1, key: true
      attribute :field_2
    end
    @instance = FinderTestClass.create! field_1: "test",
                                        field_2: "hello"
  end

  after :all do
    Object.send(:remove_const, :FinderTestClass)
  end
  
  describe "where" do

    it "should return an array containing existing instances" do

    end

    it "should return an empty array" do

    end
  end
end
