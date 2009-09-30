require File.dirname(__FILE__) + '/spec_helper'

describe ActsAsNormalized do
  it "should add #acts_as_normalized class method to ActiveRecord::Base" do
    ActiveRecord::Base.respond_to?(:acts_as_normalized).should be_true
  end
end

describe "#acts_as_normalized" do
  before :all do
    setup_db :examples, :first => :string, :second => :string
  end
  
  describe "without block and with default options" do
    before :all do
      Object.send(:remove_const, :Example) if defined?(Example)
      class Example < ActiveRecord::Base
        acts_as_normalized :first
      end
    end
  
    it "should normalize string with spaces and tabs" do
      example = Example.create(:first => "\t test ").reload
      example.first.should == 'test'
    end
  
    it "should not nilify empty string" do
      example = Example.create(:first => '  ').reload
      example.first.should == ''
    end
  
    it "should not normalize other attributes" do
      example = Example.create(:second => ' spaces ').reload
      example.second.should == ' spaces '
    end
  
    it "should pass nil value" do
      example = Example.create(:first => nil).reload
      example.first.should == nil
    end
  
    it "should pass non-string value" do
      example = Example.create(:first => 123).reload
      example.first.should == '123'
    end
  end
  
  describe "without block and with nilify set to true" do
    before :all do
      Object.send(:remove_const, :Example) if defined?(Example)
      class Example < ActiveRecord::Base
        acts_as_normalized :first, :nilify => true
      end
    end
    
    it "should nilify empty string" do
      example = Example.create(:first => '  ').reload
      example.first.should == nil
    end
    
    it "should pass nil value" do
      example = Example.create(:first => nil).reload
      example.first.should == nil
    end
  end
  
  describe "with block and default options" do
    before :all do
      Object.send(:remove_const, :Example) if defined?(Example)
      class Example < ActiveRecord::Base
        acts_as_normalized :first do |value|
          value.is_a?(String) ? value.upcase : (value.is_a?(Fixnum) ? 456 : value)
        end
      end
    end
    
    it "should normalize value calling block" do
      example = Example.create(:first => 'test').reload
      example.first.should == 'TEST'
    end
    
    it "should strip spaces before calling block" do
      example = Example.create(:first => ' spaces ').reload
      example.first.should == 'SPACES'
    end
    
    it "should not nilify empty string" do
      example = Example.create(:first => '  ').reload
      example.first.should == ''
    end
    
    it "should pass non-string value to block" do
      example = Example.create(:first => 123).reload
      example.first.should == '456'
    end
  end
  
  describe "with block nilify set to true" do
    before :all do
      Object.send(:remove_const, :Example) if defined?(Example)
      class Example < ActiveRecord::Base
        acts_as_normalized :first, :nilify => true do |value|
          value.is_a?(String) ? value.upcase : value
        end
      end
    end
    
    it "should nilify empty string" do
      example = Example.create(:first => '  ').reload
      example.first.should == nil
    end
    
    it "should pass nil value" do
      example = Example.create(:first => nil).reload
      example.first.should == nil
    end
  end
  
  after :all do
    teardown_db
  end
end
