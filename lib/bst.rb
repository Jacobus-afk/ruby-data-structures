# frozen_string_literal: true

require_relative 'mergersort.rb'

# node class
class Node
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

# tree class
class Tree
  def initialize(arr)
    @root = build_tree mergesort arr
  end

  def build_tree(arr)
    puts arr
  end
end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
