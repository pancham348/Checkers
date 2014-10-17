class Piece
  RED_DIRS = [[-1, -1], [-1, 1]]
  BLACK_DIRS = [[1, -1], [1, 1]]
	attr_reader :position, :color, :pos, :king, :captured_pieces
  attr_writer :king

	def initialize(color, pos = [0,0], board)
		@color, @pos, @board, @king = color, pos, board, false
    @captured_pieces = Hash.new{[]}
	end

	class IllegalMoveError < StandardError 
  end

	def perform_slide(new_pos)
    result = true
    if possible_slides.include?(new_pos)
      old_pos = @pos
	    @pos = new_pos if on_board?(new_pos)
      @board[@pos], @board[old_pos] = self, nil
      @king = is_king?
     result = true
    else
     result = false
    end
    result
	end


	def perform_jump(new_pos)
    result = true
    if possible_jumps.include?(new_pos)
      x = (new_pos[0] - @pos[0]) / 2
      y = (new_pos[1] - @pos[1]) / 2
      del_pos = [x + @pos[0], y + @pos[1]]
      old_pos = @pos
		  @pos = new_pos
      @board[@pos], @board[old_pos], @board[del_pos] = self, nil, nil
      @king = is_king?
      result = true
    else
      result = false
    end
    result
	end
  
  def perform_moves(move_seq)
     if valid_move_seq?(move_seq)
       perform_moves!(move_seq)
     else
       raise IllegalMoveError
     end
     
  end
  
  def perform_moves!(move_seq)
    p move_seq.length
      if move_seq.length == 1
        if perform_slide(move_seq[0])
          return true
        else
          raise IllegalMoveError
        end
      
      else
      move_seq.each do |move|
        p @pos
        if perform_jump(move)
          # return true
          true
        else
          raise IllegalMoveError #unless (perform_slide(move) || perform_jump(move))  
        end  
      end
    end
  end
  
  def valid_move_seq?(move_seq)
    begin
      dup_board = @board.dup
      dup_pos = @pos 
      dup_board[dup_pos].perform_moves!(move_seq)
  #     puts
  #     @board.display
     rescue IllegalMoveError => e
       false
     end
    
  end
  
  def on_board?(new_pos)
    (new_pos[0] <= 7 && new_pos[1] <= 7) && (new_pos[0] >= 0 && new_pos[1] >= 0)
  end
  
  def possible_jumps
    directions = (@color == :red ? RED_DIRS : BLACK_DIRS)
    jump_dirs = directions.map { |dir| dir.map { |x| x * 2 } }
    
		moves_arr = []
    
		jump_dirs.each do |dir|
		  new_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
      jumped_pos = [@pos[0] + (dir[0] / 2), @pos[1] + ( dir[1] / 2)]
      
      moves_arr << new_pos if on_board?(new_pos) && @board[new_pos].nil? && 
            enemy?(jumped_pos)
		end
    
    moves_arr
  end
  
  def possible_slides
		directions = @color == :red ? RED_DIRS : BLACK_DIRS
    
		directions.map do |dir|
		  [@pos[0] + dir[0], @pos[1] + dir[1]]
		end.select { |move| on_board?(move) && @board[move].nil? } 
  end
  
  def to_s
    return "O" if @color == :red
    return "X" if @color == :black
  end
  
  def is_king?
    return true if @color == :red && @pos[0] == 0
    return true if @color == :black && @pos[0] == 7
    false
  end
    
  def enemy?(pos)
    @board[pos] && @board[pos].color != @color
  end
  
end
    
