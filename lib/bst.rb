# frozen_string_literal: true

# node class
class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

# tree class
class Tree
  def initialize(arr = [])
    arr.sort!.uniq!
    @root = build_tree(arr, 0, arr.length)
  end

  def build_tree(arr, start, stop)
    return nil if start > stop

    middle = (start + stop) / 2
    node = Node.new(arr[middle])
    node.left = build_tree(arr, start, middle - 1)
    node.right = build_tree(arr, middle + 1, stop)
    node
  end

  def find(value, node = @root)
    return node if node.nil? || node.data.nil? || node.data == value

    return find(value, node.right) if value > node.data

    find(value, node.left)
  end

  def insert(value)
    node = Node.new(value)
    return @root = node if @root.data.nil?

    _insert(node)
  end

  def delete(value, parent_node = @root)
    return parent_node if parent_node.nil?

    parent_node.right = delete(value, parent_node.right) if value > parent_node.data
    parent_node.left = delete(value, parent_node.left) if value < parent_node.data
    return _delete_children(parent_node) if value == parent_node.data

    parent_node
  end

  def height(node = @root)
    return 0 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return left_height + 1 if left_height > right_height

    return right_height + 1 if left_height <= right_height
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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def _insert(new_node, parent_node = @root)
    if new_node.data > parent_node.data
      return parent_node.right = new_node if parent_node.right.nil?

      _insert(new_node, parent_node.right)
    else
      return parent_node.left = new_node if parent_node.left.nil?

      _insert(new_node, parent_node.left)
    end
  end

  def _delete_children(node)
    return node.left if node.right.nil?

    return node.right if node.left.nil?

    temp_data = _node_min_value(node.right).data
    node.data = temp_data
    node.right = delete(temp_data, node.right)
  end

  def _node_min_value(node)
    current_node = node
    current_node = current_node.left until current_node.left.nil?
    current_node
  end
end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# test = Tree.new
p = test.find(67)
puts p

test.pretty_print
puts test.level_order
puts test.height

test.delete(7)
test.pretty_print

test.delete(1)
test.pretty_print

test.delete(8)
test.pretty_print
# test.insert(50)
# test.insert(30)
# test.insert(20)
# test.insert(40)
# test.insert(70)
# test.insert(60)
# test.insert(80)
# test.pretty_print

# test.delete(20)
# test.pretty_print

# test.delete(30)
# test.pretty_print

# test.delete(50)
# test.pretty_print
