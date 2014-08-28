# encoding: utf-8

require 'rubygems'
require 'thailang4r/dict.rb'

describe 'DictIter' do
  before :each do
    @dict = ThaiLang::Dict.new('./data/test_dict.txt')
    @dict_iter = ThaiLang::DictIter.new(@dict)
  end

  it 'should walk' do
    @dict_iter.walk('ข').should == :ACTIVE_BOUNDARY
  end

  it 'should walk to 1st entry' do
    @dict_iter.walk('ก').should == :ACTIVE_BOUNDARY
  end

  it 'should walk to something which is not found' do
    @dict_iter.walk('ฉ').should == :INVALID
    @dict_iter.walk('ข').should == :INVALID
  end

  it 'should walk to something which is found but not boundary' do
    @dict_iter.walk('จ').should == :ACTIVE
  end


  it 'should walk to something which is not found at 2nd step' do
    @dict_iter.walk('ข').should == :ACTIVE_BOUNDARY
    @dict_iter.walk('ข').should == :INVALID
  end

  it 'should active before active_boundary' do
    @dict_iter.walk('ม').should == :ACTIVE
    @dict_iter.walk('จ').should == :ACTIVE_BOUNDARY
  end
end
