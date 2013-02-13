# encoding: utf-8

require 'rubygems'
require 'thailang4r'

describe "chlevel" do
  it "return 1 for ก" do
    ThaiLang::chlevel("ก").should eq(1)
  end
  
  it "return -1 for ู" do
    ThaiLang::chlevel("ู").should eq(-1)
  end
  
  it "return 2 for ี" do
    ThaiLang::chlevel("ี").should eq(2)
  end
  
  it "return nil for a" do
    ThaiLang::chlevel("a").should eq(nil)
  end

  it "return 3 for ๋" do
    ThaiLang::chlevel("๋").should eq(3)
  end
  
end

describe "string_chlevel" do
  it "return [nil, 1]" do
    ThaiLang::string_chlevel("xป").should eq([nil, 1])
  end
end

describe "exclude_thai_lower_upper" do
  it "return กปa" do
    ThaiLang::exclude_thai_lower_upper("กี่ปู่a").should eq("กปa")
  end
end