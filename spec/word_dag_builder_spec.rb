# encoding: utf-8

require 'rubygems'
require 'thailang4r/dict.rb'
require 'thailang4r/word_dag_builder.rb'

describe "WordDagBuilder" do
  before :each do
    @dict = ThaiLang::Dict.new "./data/test_dict.txt"
    @builder = ThaiLang::WordDagBuilder.new @dict
  end
  
  it "should build dag containing one word" do
    dag = @builder.build("ก", 1)
    dag.should == [[0, 1, :DICT]]
  end
  
  it "should build dag containing two words" do
    dag = @builder.build("ขก", 2)
    dag.should == [[0,1, :DICT], [1,2,  :DICT]]
  end
  
  it "should build dag with ambiguity" do
    dag = @builder.build("ขจก", 3)
    dag.should == [[0,1, :DICT], [0,2, :DICT], [1,3, :DICT], [2,3, :DICT]]
  end
end
