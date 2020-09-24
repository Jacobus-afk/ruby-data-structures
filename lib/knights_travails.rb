# frozen_string_literal: true

BOARD_SIZE = 7
POSSIBLE_MOVES = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]].freeze

$end_flag = false

# node class
class Node
  attr_reader :position, :parent
  attr_accessor :moves
  def initialize(position, parent = nil)
    @parent = parent
    @position = position
    @moves = []
  end
end

def valid_move?(move)
  move[0].between?(0, BOARD_SIZE) && move[1].between?(0, BOARD_SIZE)
end

def check_for_end_position(current, end_position, found_end)
  return unless current.position == end_position

  $end_flag = true
  found_end.append(current) unless found_end != [] # only add first path to end position
end

def generate_knight_moves(base_move, end_position, start_position, found_end)
  basemove_pos = base_move.position

  POSSIBLE_MOVES.each do |possible_move|
    # https://stackoverflow.com/questions/1009280/how-do-i-perform-vector-addition-in-ruby
    move_attempt = possible_move.zip(basemove_pos).map { |x1, x2| x1 + x2 }
    next unless valid_move?(move_attempt) || move_attempt == basemove_pos || move_attempt == start_position

    new_move = Node.new(move_attempt, base_move)
    base_move.moves.push(new_move)
    check_for_end_position(new_move, end_position, found_end)
  end
end

def knight_recurser(base_node, end_position, start_position, found_end)
  return if $end_flag

  base_node.moves.each do |move|
    generate_knight_moves(move, end_position, start_position, found_end)
  end
  # two separate loops so that we can traverse breadth first, otherwise longest path will pop up first
  base_node.moves.each do |move|
    knight_recurser(move, end_position, start_position, found_end)
  end
end

def plot_knight_path(found_end, path_arr = [])
  until found_end.parent.nil?
    path_arr.append(found_end.position)
    found_end = found_end.parent
  end
  path_arr.append(found_end.position)

  puts "You made it in #{path_arr.length - 1} moves! Here's your path:"
  path_arr.reverse.each do |step|
    pp step
  end
end

def knight_moves(start_position, end_position, found_end = [])
  return 'Not valid start/end position' unless valid_move?(start_position) && valid_move?(end_position)

  base_move = Node.new(start_position)
  generate_knight_moves(base_move, end_position, start_position, found_end)
  knight_recurser(base_move, end_position, start_position, found_end)
  plot_knight_path(found_end[0])
end

knight_moves([3, 3], [0, 0])
