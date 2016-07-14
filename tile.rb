class Tile
  def initialize
    @hidden = true
    @bomb = false
    @fringe_value = 0
  end

  def bomb?
    @bomb
  end

  def hidden?
    @hidden
  end

end
