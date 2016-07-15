require_relative "tile"
require 'byebug'
require "colorize"

class Board

  attr_reader :grid, :flags

  def initialize(size=8, bomb_count=12)
    @size = size
    @bomb_count = bomb_count
    @grid = Array.new(size) {Array.new(size) {Tile.new}}
    @flags = 0
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
    nil
  end

  def render_board(game_over=false)
    grid.each do | row |
      row.each do | tile |
        #show all the bombs at end
        if game_over && tile.bomb
          print " ! ".colorize(:color => :black, :background => :red)
        #not hidden, has fringe value
        elsif !tile.hidden && tile.fringe_value != 0
          print " #{tile.fringe_value} ".colorize(:color => :black, :background => :white)
        #hidden, flag
        elsif tile.hidden && tile.flag
          print " f ".colorize(:color => :black, :background => :light_blue)
        #not hidden, no fringes
        elsif !tile.hidden
          print "   ".colorize(:background => :white)
        #hidden
        else
          print "   ".colorize(:background => :light_blue)
        end

      end
      print "\n"
    end
    nil
  end


  def set_fringes
    @grid.each_with_index do | row, row_index |
      row.each_with_index do | tile, tile_index |
        tile.fringe_value = find_near_bombs(row_index, tile_index)
      end
    end
    nil
  end

  def find_near_bombs(*pos)
    x, y = pos
    current_tile = self[x, y]
    bombs = 0
    (-1..1).each do |add_x|
      (-1..1).each do |add_y|
        x, y = pos
        x, y = x + add_x, y+add_y
        next if add_x == 0 && add_y == 0
        next if !valid_pos?([x, y])
        bombs +=1 if self[x, y].bomb
      end
    end
    bombs
  end

  def valid_pos?(pos)
    pos[0].between?(0, @size-1) && pos[1].between?(0, @size-1)
  end

  def [](*pos)
    x, y = pos
    @grid[x][y]
  end

  def solved?
    flat_grid = @grid.flatten
    flat_grid.each do | tile |
      return false if tile.bomb != tile.flag
    end
    true
  end

  def hit_bomb?
    flat_grid = @grid.flatten
    flat_grid.any? { | tile | !tile.hidden && tile.bomb }
  end

  def flag_tile(*pos)
    x, y = pos
    if self[x, y].flag
      self[x, y].flag = false
      @flags -= 1
    else
      self[x, y].flag = true
      @flags += 1
    end
  end

  def step_tile(*pos)

    x, y = pos
    self[x, y].reveal
    return if self[x,y].bomb
    (-1..1).each do |add_x|
      (-1..1).each do |add_y|
        x, y = pos
        x, y = x + add_x, y + add_y
        next if add_x == 0 && add_y == 0
        unhide_until_fringe(x, y)
      end
    end
  end
end

def unhide_until_fringe(*pos)
  x, y = pos
  return nil unless valid_pos?([x, y])
  return nil unless self[x,y].hidden

  self[x, y].reveal unless self[x,y].bomb

  return nil if find_near_bombs(x, y) > 0

  (-1..1).each do |add_x|
    (-1..1).each do |add_y|
      x, y = pos
      x, y = x + add_x, y + add_y
      next if add_x == 0 && add_y == 0

      unhide_until_fringe(x, y)
    end
  end
end

# board = Board.new()
#board.render_board
