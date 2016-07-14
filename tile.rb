class Tile

  attr_accessor :fringe_value, :hidden, :bomb

  def initialize
    @hidden = true
    @bomb = false
    @fringe_value = 0
    @flag = false
  end

  def reveal
    @hidden = false
  end

  def flag_space
    @flag = true
  end
end
