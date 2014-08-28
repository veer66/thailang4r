# encoding: utf-8

require 'rubygems'
require 'thailang4r/dict.rb'

describe 'Dict' do
  before :each do
    @dict = ThaiLang::Dict.new('./data/test_dict.txt')
  end

  it 'should find first index of needle' do
    @dict.find_first_index_of_needle('ก').should == 0
    @dict.find_first_index_of_needle('ข').should == 2
  end

  it 'should find last index of needle' do
    @dict.find_last_index_of_needle('ข').should == 4
  end

  it 'should give dict size' do
    @dict.size.should == 8
  end

  it 'should return a word by index' do
    @dict[3].should == 'ขคทท'
  end
end
