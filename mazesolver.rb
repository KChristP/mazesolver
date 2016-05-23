class Maze
  def initialize
    @lines = File.readlines(ARGV[0]).map {|line| line.split("")}
    @splits = []
    @trail = []
    @unmark = []
  end

  def find_character(char)
    @lines.each_with_index do |line, line_idx|
      line.each_with_index do |character, col_idx|
        return [line_idx, col_idx] if character == char
      end
    end
  end

  def find_start
    find_character("S")
  end

  def find_end
    find_character("E")
  end

  def up(pos)
    [pos[0] + 1, pos[1]]
  end

  def down(pos)
    [pos[0] - 1, pos[1]]
  end

  def left(pos)
    [pos[0], pos[1] - 1]
  end

  def right(pos)
    [pos[0], pos[1] + 1]
  end

  def search_adjacent(pos, character)
    spaces = []
    spaces << up(pos) if @lines[up(pos)[0]][up(pos)[1]] == character
    spaces << right(pos) if @lines[right(pos)[0]][right(pos)[1]] == character
    spaces << down(pos) if @lines[down(pos)[0]][down(pos)[1]] == character
    spaces << left(pos) if @lines[left(pos)[0]][left(pos)[1]] == character
    spaces
  end

  def get_move(pos)
    ending = search_adjacent(pos, "E")
    openings = search_adjacent(pos, " ").select {|pos| !@trail.include?(pos)}
    @splits << pos if openings.length > 1
    @trail << pos
    if ending != []
      ending[0]
    else
      openings[0]
    end
  end

  def crawler
    current_position = find_start
    final_position = find_end
    i = 0
    loop do
      next_position = get_move(current_position)
      if current_position == final_position
        winner
        break
      elsif next_position == nil#need to find out what actually comes out when it hits a wall
        current_position = @splits.pop
        backtrack_idx = @trail.index(current_position) + 1
        @unmark += @trail[backtrack_idx..-1]
      else
        current_position = next_position
      end
      i += 1
    end
  end

  def winner
    @trail -= @unmark
    @trail.each do |pos|
      @lines[pos[0]][pos[1]] = "X"
    end
    puts @lines.map {|line| line.join}
  end
end

game = Maze.new
game.crawler
