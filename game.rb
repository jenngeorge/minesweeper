require_relative 'board'
require 'byebug'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def run
  end

  def play_turn
    move_type = get_move_type
  end

  def lost?
    @board.hit_bomb?
    render_board(true)
  end

  def won?
    @board.solved?
  end

  def get_move_type
    puts "Would you like to flag or step (f / s)?"
    move_type = gets.chomp[0].downcase
    valid_type = ["f", "s"]
    get_move_type unless valid_type.include?(move_type)
    move_type
  end

  def flag(pos)
    @board.flag_tile(*pos)
    puts "You have placed #{flag_count} flags."
  end

  def flag_count
    @board.flags
  end

  def step
  end
end
