class Tile

  attr_accessor :fringe_value, :hidden, :bomb

  def initialize
    @hidden = true
    @bomb = false
    @fringe_value = 0
  end

end
