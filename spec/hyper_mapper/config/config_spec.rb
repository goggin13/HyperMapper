require "spec_helper"

describe HyperMapper::Config do

  let(:config) do
    HyperMapper::Config
  end

  describe "defaults" do

    it "returns the default options" do
      config.defaults.should_not be_empty
    end

    it "returns 127.0.0.1 for the host" do
      config.defaults['host'].should == '127.0.0.1'
    end

    it "returns 1982 for the port" do
      config.defaults['port'].should == 1982
    end
  end
end
