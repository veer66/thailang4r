require 'rubygems'
require 'thailang4r/ranges_builder.rb'

describe 'RangesBuilder' do
  before :each do
    @builder = ThaiLang::RangesBuilder.new
  end

  it 'should build one word' do
    ranges = @builder.build_from_dag([[0, 5, :DICT]], 5)
    ranges.should == [[0, 5, :DICT]]
  end

  it 'should build two words' do
    ranges = @builder.build_from_dag([[0,3,:DICT], [3,10,:DICT]], 10)
    ranges.should == [[0, 3, :DICT], [3,10, :DICT]]
  end

  it 'should build from simple ambiguity' do
    ranges = @builder.build_from_dag([[0, 3, :DICT], [0, 5, :DICT], [3, 10, :DICT]], 10)
    ranges.should == [[0, 3, :DICT], [3, 10, :DICT]]
  end

  it 'should build without known word' do
    ranges = @builder.build_from_dag([], 10)
    ranges.should == [[0,10, :UNK]]
  end

  it 'should build by unknown on the rightest' do
    ranges = @builder.build_from_dag([[0,7,:DICT]], 10)
    ranges.should == [[0,7, :DICT], [7,10, :UNK]]
  end

  it 'should build by unknown on the leftest' do
    ranges = @builder.build_from_dag([[7,10, :DICT]], 10)
    ranges.should == [[0,7, :UNK], [7,10, :DICT]]
  end

  it 'should build by known island' do
    ranges = @builder.build_from_dag([[3, 5, :DICT]], 10)
    ranges.should == [[0,3, :UNK], [3,5, :DICT], [5,10, :UNK]]
  end
end
