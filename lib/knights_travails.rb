# frozen_string_literal: true

BOARD_SIZE = 7
POSSIBLE_MOVES = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]].freeze

$end_flag = false

# node class
class Node
  attr_reader :position
  attr_accessor :moves
  def initialize(position)
    @position = position
    @moves = []
  end
end

def valid_move(move)
  move[0].between?(0, BOARD_SIZE) && move[1].between?(0, BOARD_SIZE)
end

def print_shortest_path(base_move, end_position); end

def check_for_end_position(current_position, end_position)
  return unless current_position - end_position == []

  $end_flag = true
  true
end

def move_knight(base_move, end_position, start_position)
  return if $end_flag

  basemove_pos = base_move.position
  return if check_for_end_position(basemove_pos, end_position)

  POSSIBLE_MOVES.each do |possible_move|
    # https://stackoverflow.com/questions/1009280/how-do-i-perform-vector-addition-in-ruby
    move_attempt = possible_move.zip(basemove_pos).map { |x1, x2| x1 + x2 }
    next unless valid_move(move_attempt) || move_attempt == basemove_pos || move_attempt == start_position

    new_move = Node.new(move_attempt)
    base_move.moves.push(new_move)
    move_knight(new_move, end_position, start_position)
  end
end

def knight_moves(start_position, end_position)
  return 'Not valid start/end position' unless valid_move(start_position) && valid_move(end_position)

  base_move = Node.new(start_position)

  move_knight(base_move, end_position, start_position)
  pass
end

# puts valid_move([0, 7])
knight_moves([0, 0], [1, 2])
