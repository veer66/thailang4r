# encoding: utf-8

require 'rubygems'
require 'thailang4r/dict.rb'
require 'thailang4r/word_dag_builder.rb'
require 'thailang4r/word_breaker.rb'

describe "WordBreaker" do
  before :each do
    @word_breaker = ThaiLang::WordBreaker.new "./data/test_dict.txt"
  end
  
  it "should break simple words" do
    @word_breaker.break_into_words("กกตขจ").should == ["กกต", "ขจ"]
  end
  
  it "should break unkown word" do
    @word_breaker.break_into_words("กกตศรรมขจ").should == ["กกต", "ศรรม", "ขจ"]
  end
end