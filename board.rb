require_relative "tile"
require "colorize"

class Board

  attr_reader :grid

  def initialize(size=8, bomb_count=12)
    @size = size
    @bomb_count = bomb_count
    @grid = Array.new(size) {Array.new(size, Tile.new)}
  end

  def set_bombs
    flat_grid = @grid.flatten
    until @bomb_count == 0
      random_tile = flat_grid.sample
      unless random_tile.bomb?
        random_tile.bomb = true
        @bomb_count -= 1
      end
    end
  end

  def render_board
    grid.each do | row |
      row.each do | tile |
        if tile.hidden?
          print "   ".colorize(:background => :light_blue)
        elsif tile.fringe_value == 0
          print "   ".colorize(:background => :white)
        else
          print " #{tile.fringe_value} ".colorize(:background => :white)
        end
      end
      print "\n"
    end
  end
end


board = Board.new()
board.render_board
