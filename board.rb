require_relative "tile"
require 'byebug'
require "colorize"

class Board

  attr_reader :grid

  def initialize(size=8, bomb_count=12)
    @size = size
    @bomb_count = bomb_count
    @grid = Array.new(size) {Array.new(size) {Tile.new}}
    set_bombs
    set_fringes
  end

  def set_bombs
    flat_grid = @grid.flatten
    until @bomb_count == 0
      random_tile = flat_grid.sample
      unless random_tile.bomb
        random_tile.bomb = true
        @bomb_count -= 1
      end
    end
  end

  def render_board
    grid.each do | row |
      row.each do | tile |
        if tile.hidden
          print "   ".colorize(:background => :light_blue)
        elsif tile.fringe_value == 0
          print "   ".colorize(:background => :white)
        else
          print " #{tile.fringe_value} ".colorize(:color => :black, :background => :white)
        end
      end
      print "\n"
    end
  end

  def set_fringes
    @grid.each_with_index do | row, row_index |
      row.each_with_index do | tile, tile_index |
        tile.fringe_value = find_near_bombs(row_index, tile_index)
      end
    end
  end

  def find_near_bombs(*pos)
    x, y = pos
    current_tile = self[x, y]
    bombs = 0
    (-1..1).each do |add_x|
      (-1..1).each do |add_y|
        x, y = x + add_x, y+add_y
        next if add_x == 0 && add_y == 0
        next if !valid_pos?(x, y)
        bombs +=1 if self[x, y].bomb
      end
    end
    bombs
  end

  def valid_pos?(*pos)
    x, y = pos
    x.between?(0, @size-1) && y.between?(0, @size-1)
  end

  def [](*pos)
    x, y = pos
    @grid[x][y]
  end

end


board = Board.new()
board.render_board
