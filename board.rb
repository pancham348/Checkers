require_relative 'piece'
class Board
  
  attr_reader :grid
	def initialize(add_pieces = true)
		@grid = Array.new(8) { Array.new(8) }
    set_board if add_pieces
	end
  
  def set_board
    set_red_pieces
    set_black_pieces
    @grid
  end
  
  def dup
    dup_board = Board.new(false)
    @grid.flatten.each do |piece|
      next if piece.nil?
      color = piece.color
      pos = piece.pos
      board = dup_board
      dup_board[pos] =  Piece.new(color, pos, board) 
    end
    dup_board
  end
  
  def set_red_pieces
    (5..7).each do |row|
      (0..7).each do |col|
        if row.odd? && col.even?
          @grid[row][col] = Piece.new(:red, [row, col], self)
        elsif row.even? && col.odd?
          @grid[row][col] = Piece.new(:red, [row, col], self)
        end
      end
    end
  end
  
  def set_black_pieces
    (0..2).each do |row|
      (0..7).each do |col|
        if row.odd? && col.even?
          @grid[row][col] = Piece.new(:black, [row, col], self)
        elsif row.even? && col.odd?
          @grid[row][col] = Piece.new(:black, [row, col], self)
        end
      end
    end 
  end
  
  def display
    (0..7).each do |row|
      row_str = "#{row}".rjust(3)
      (0..7).each do |col|
        if @grid[row][col].nil?
          row_str += "-".rjust(3)
        else
          row_str += @grid[row][col].to_s.rjust(3)
        end
      end
      puts row_str
    end
    puts footer
  end
  
  # def move(pos1, pos2)
  #   diff = (pos2[0] - pos1[0]).abs
  #   if diff == 1
  #     self[pos1].perform_slide(pos2, self)
  #   else
  #     self[pos1].perform_jump(pos2, self)
  #   end
    
  #end
  
  def [](pos)
    row, col = pos[0], pos[1]
    @grid[row][col]
  end
 
  def []= (pos, piece)
    row, col = pos[0], pos[1]
    @grid[row][col] = piece
  end
  
  def footer
    row_str = "".rjust(3)
    (0..7).each {|i| row_str += i.to_s.rjust(3)}
    row_str
  end
end

b  = Board.new
b.display
#p b[[2,3]].possible_slides 
#p b[[2,3]].perform_jump([3,4]) || b[[2,3]].perform_slide([3,4])

# p b[[5,0]].possible_jumps
#p b[[2,3]].perform_slide([3,4])
#p b[[2,3]].perform_jump([3,4])
#p b[[2,3]].valid_move_seq?([[3,4]])
#b.display
b[[2,3]].perform_moves([[3,4]])
b[[5,6]].perform_moves([[4,7]])
b[[5,2]].perform_moves([[4,1]])
b[[6,3]].perform_moves([[5,2]])
b[[5,4]].perform_moves([[4,5]])
b[[7,4]].perform_moves([[6,3]])
b.display
puts
#p b[[2,3]]
p b[[3,4]].perform_moves!([[5,6],[7,4]])
puts
b.display
puts "DjkhfsjKD"







