# frozen_string_literal: true

# functions to handle different tree operations
module TreeOperations
  def _find(value, node)
    return node if node.nil? || node.data.nil? || node.data == value

    return _find(value, node.right) if value > node.data

    _find(value, node.left)
  end

  def _insert(new_node, parent_node)
    if new_node.data > parent_node.data
      return parent_node.right = new_node if parent_node.right.nil?

      _insert(new_node, parent_node.right)
    else
      return parent_node.left = new_node if parent_node.left.nil?

      _insert(new_node, parent_node.left)
    end
  end

  def _delete(value, parent_node)
    return parent_node if parent_node.nil?

    parent_node.right = _delete(value, parent_node.right) if value > parent_node.data
    parent_node.left = _delete(value, parent_node.left) if value < parent_node.data
    return _delete_children(parent_node) if value == parent_node.data

    parent_node
  end

  def _inorder(node, arr)
    _inorder(node.left, arr) unless node.left.nil?
    arr.push(node.data)
    _inorder(node.right, arr) unless node.right.nil?
    arr
  end

  def _preorder(node, arr)
    arr.push(node.data)
    _preorder(node.left, arr) unless node.left.nil?
    _preorder(node.right, arr) unless node.right.nil?
    arr
  end

  def _postorder(node, arr)
    _postorder(node.left, arr) unless node.left.nil?
    _postorder(node.right, arr) unless node.right.nil?
    arr.push(node.data)
    arr
  end

  private

  def _delete_children(node)
    return node.left if node.right.nil?

    return node.right if node.left.nil?

    temp_data = _node_min_value(node.right).data
    node.data = temp_data
    node.right = _delete(temp_data, node.right)
  end
end

# node class
class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

# class to pass height objects in method
class Height
  attr_accessor :height
  def initialize
    @height = -1
  end
end

# tree class
class Tree
  include TreeOperations
  def initialize(arr = [])
    arr.sort!.uniq!
    @root = build_tree(arr, 0, arr.length)
  end

  def build_tree(arr, start, stop)
    return nil if start > stop || start == arr.length

    middle = (start + stop) / 2
    node = Node.new(arr[middle])
    node.left = build_tree(arr, start, middle - 1)
    node.right = build_tree(arr, middle + 1, stop)
    node
  end

  def find(value)
    _find(value, @root)
    # return node if node.nil? || node.data.nil? || node.data == value

    # return find(value, node.right) if value > node.data

    # find(value, node.left)
  end

  def insert(value)
    node = Node.new(value)
    return @root = node if @root.data.nil?

    _insert(node, @root)
  end

  def delete(value)
    # return parent_node if parent_node.nil?

    # parent_node.right = delete(value, parent_node.right) if value > parent_node.data
    # parent_node.left = delete(value, parent_node.left) if value < parent_node.data
    # return _delete_children(parent_node) if value == parent_node.data

    # parent_node
    _delete(value, @root)
  end

  def height(node = @root)
    return -1 if node.nil?

    # left_height = height(node.left)
    # right_height = height(node.right)

    # return left_height + 1 if left_height > right_height

    # right_height + 1
    [height(node.left), height(node.right)].max + 1
  end

  def depth(node_search)
    search_val = node_search.data
    node = @root
    depth_val = 0
    until node.data == search_val || node.nil?
      node = node.left if search_val < node.data
      node = node.right if search_val > node.data
      depth_val += 1
    end
    return depth_val unless node.nil?
  end

  def level_order
    queue = [@root]
    level_order_arr = []
    until queue.empty?
      temp = queue.shift
      level_order_arr.push(temp.data)
      queue.push(temp.left) unless temp.left.nil?
      queue.push(temp.right) unless temp.right.nil?
    end
    level_order_arr
  end

  def inorder
    _inorder(@root, [])
  end

  def preorder
    _preorder(@root, [])
  end

  def postorder
    _postorder(@root, [])
  end

  # https://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/
  def balanced?(node = @root, height = Height.new)
    return true if node.nil?

    left_height = Height.new
    right_height = Height.new

    left_node = balanced?(node.left, left_height)
    right_node = balanced?(node.right, right_height)

    height.height = [left_height.height, right_height.height].max + 1

    return left_node && right_node if (left_height.height - right_height.height).abs <= 1

    false
  end

  def rebalance
    level_order_arr = level_order
    @root = build_tree(level_order_arr, 0, level_order_arr.length)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  # def _depth(search_val, node)
  #   return 0 if search_val == node.data
  # end

  # def _inorder(node, arr)
  #   _inorder(node.left, arr) unless node.left.nil?
  #   arr.push(node.data)
  #   _inorder(node.right, arr) unless node.right.nil?
  #   arr
  # end

  # def _preorder(node, arr)
  #   arr.push(node.data)
  #   _preorder(node.left, arr) unless node.left.nil?
  #   _preorder(node.right, arr) unless node.right.nil?
  #   arr
  # end

  # def _postorder(node, arr)
  #   _postorder(node.left, arr) unless node.left.nil?
  #   _postorder(node.right, arr) unless node.right.nil?
  #   arr.push(node.data)
  #   arr
  # end

  # def _insert(new_node, parent_node = @root)
  #   if new_node.data > parent_node.data
  #     return parent_node.right = new_node if parent_node.right.nil?

  #     _insert(new_node, parent_node.right)
  #   else
  #     return parent_node.left = new_node if parent_node.left.nil?

  #     _insert(new_node, parent_node.left)
  #   end
  # end

  # def _delete_children(node)
  #   return node.left if node.right.nil?

  #   return node.right if node.left.nil?

  #   temp_data = _node_min_value(node.right).data
  #   node.data = temp_data
  #   node.right = delete(temp_data, node.right)
  # end

  def _node_min_value(node)
    current_node = node
    current_node = current_node.left until current_node.left.nil?
    current_node
  end
end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# test = Tree.new
p_node = test.find(6345)
puts p_node

test.insert(11)

test.pretty_print
p test.level_order
p test.inorder
p test.preorder
p test.postorder

puts test.depth(p_node)
puts test.height
puts test.balanced?

test.delete(7)
test.delete(1)
test.delete(3)
test.delete(5)

test.pretty_print
puts test.balanced?

test.rebalance
puts test.balanced?
test.pretty_print
