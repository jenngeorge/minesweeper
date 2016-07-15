require_relative 'board'
require 'byebug'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def run
    until won? || lost?
      play_turn
    end
    if won?
      (puts "You found all the bombs.")
    else
      @board.render_board(true)
      (puts "Boom!  Game over")
    end
    exit
  end

  def play_turn
    @board.render_board
    move_type = get_move_type
    if move_type == "f"
      puts "Where would you like to place the flag?"
      position = get_position
      flag(position)
    else
      puts "Where would you like to step?"
      position = get_position
      step(position)
    end
  end

  def lost?
    @board.hit_bomb?
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

  def get_position
    position = gets.chomp.split(',').map{ | pos | Integer(pos) }
    unless @board.valid_pos?(position)
      puts "Invalid position.  Try again."
      get_position
    end
    position
  end

  def flag(pos)
    @board.flag_tile(*pos)
    puts "You have placed #{flag_count} flags."
  end

  def flag_count
    @board.flags
  end

  def step(pos)
    @board.step_tile(*pos)
  end
end

Game.new.run
