# frozen_string_literal: true

BOARD_SIZE = 7
POSSIBLE_MOVES = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]].freeze

$end_flag = false

# node class
class Node
  attr_reader :position
  attr_accessor :moves
  def initialize(position, parent = nil)
    @parent = parent
    @position = position
    @moves = []
  end
end

def valid_move(move)
  move[0].between?(0, BOARD_SIZE) && move[1].between?(0, BOARD_SIZE)
end

def print_shortest_path(base_move, end_position); end

def check_for_end_position(current_position, end_position)
  return unless current_position == end_position # == []

  $end_flag = true
  true
end

def generate_knight_moves(base_move, end_position, start_position, found_end)
  # return if $end_flag

  basemove_pos = base_move.position
  # return if check_for_end_position(basemove_pos, end_position)

  POSSIBLE_MOVES.each do |possible_move|
    # https://stackoverflow.com/questions/1009280/how-do-i-perform-vector-addition-in-ruby
    move_attempt = possible_move.zip(basemove_pos).map { |x1, x2| x1 + x2 }
    next unless valid_move(move_attempt) || move_attempt == basemove_pos || move_attempt == start_position

    new_move = Node.new(move_attempt, base_move)
    base_move.moves.push(new_move)
    next unless check_for_end_position(new_move.position, end_position)

    found_end.append(new_move) # unless found_end != []
    return true
    # move_knight(new_move, end_position, start_position)
  end
  nil
end

def knight_recurser(base_node, end_position, start_position, found_end)
  return if $end_flag

  base_node.moves.each do |move|
    unless generate_knight_moves(move, end_position, start_position, found_end)
      knight_recurser(move, end_position, start_position, found_end)
    end
  end
end

def knight_moves(start_position, end_position)
  return 'Not valid start/end position' unless valid_move(start_position) && valid_move(end_position)

  base_move = Node.new(start_position)

  found_end = []
  unless generate_knight_moves(base_move, end_position, start_position, found_end)
    knight_recurser(base_move, end_position, start_position, found_end)
  end
  # move_array = base_move
  # until found_end
  #   move_array.moves.each do |move|
  #     found_end = generate_knight_moves(move, end_position, start_position)
  #     break if found_end
  #   end
  # end
  pass
end

# puts valid_move([0, 7])
knight_moves([3, 3], [4, 3])
