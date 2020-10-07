class Board
  attr_accessor :board
  attr_accessor :column_fill
  attr_accessor :filled

  def initialize
    @board = generate_board
    @column_fill = {
      'c1' => 0,
      'c2' => 0,
      'c3' => 0,
      'c4' => 0,
      'c5' => 0,
      'c6' => 0,
      'c7' => 0
    }
    @filled = 0
  end

  def generate_board
    board = []
    6.times { board.push([' ', ' ', ' ', ' ', ' ', ' ', ' ']) }
    board
  end

  def display_board
    (0...6).each do |i|
      print '|'
      (0...7).each do |j|
        print " #{board[i][j]}"
        print ' ' if board[i][j] == ' '
        print '|'
      end
      puts
      puts '+---+---+---+---+---+---+---+'
    end
    puts '  1   2   3   4   5   6   7 '
  end

  def add_piece(piece, space)
    board[space[0]][space[1]] = piece
    @filled += 1
  end

  # rubocop: disable Metrics/AbcSize

  def adjacent_lines(space)
    row = space[0]
    col = space[1]
    adjacent = {
      'v-u' => [[row - 1, col], [row - 2, col], [row - 3, col]],
      'v-d' => [[row + 1, col], [row + 2, col], [row + 3, col]],
      'h-l' => [[row, col - 1], [row, col - 2], [row, col - 3]],
      'h-r' => [[row, col + 1], [row, col + 2], [row, col + 3]],
      'di-ul' => [[row - 1, col - 1], [row - 2, col - 2], [row - 3, col - 3]],
      'di-ur' => [[row - 1, col + 1], [row - 2, col + 2], [row - 3, col + 3]],
      'di-dl' => [[row + 1, col - 1], [row + 2, col - 2], [row + 3, col - 3]],
      'di-dr' => [[row + 1, col + 1], [row + 2, col + 2], [row + 3, col + 3]]
    }
    adjacent.each_key do |line|
      adjacent[line] = adjacent[line].select do |square|
        square[0].between?(0, 5) && square[1].between?(0, 6)
      end
    end
    adjacent
  end

  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity

  def check_win(player)
    board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        next if square == ' ' || square != player.piece

        adjacent = adjacent_lines([i, j])
        adjacent.each_key do |line|
          next if adjacent[line].nil?

          connected = 1
          adjacent[line].each do |spot|
            connected += 1 if board[spot[0]][spot[1]] == player.piece
          end

          return true if connected == 4
        end
      end
    end
    false
  end

  # rubocop: enable Metrics/PerceivedComplexity
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/AbcSize
end

class Player
  attr_accessor :piece
  attr_accessor :color

  def initialize(color)
    @color = color
    @piece = color == 'Black' ? "\u26aa" : "\u26ab"
  end
end

class Game
  def game_menu
    selection = -1

    loop do
      print "1. New Game\n2. Exit\nPlease make a selection: "
      begin
        selection = gets.chomp.to_i
      rescue TypeError
        puts 'Invalid input'
      else
        break if [1, 2].include?(selection)

        puts 'Invalid selection'
      end
    end

    selection
  end

  def play_game
    board = Board.new
    player1 = Player.new('White')
    player2 = Player.new('Black')
    current = player1
    board.display_board

    loop do
      puts "#{current.color}'s turn"
      space = get_move(board)
      board.add_piece(current.piece, space)
      board.display_board
      win = board.check_win(current)
      if win
        puts "#{current.color} wins!"
        break
      elsif board.filled == 42
        puts "It's a draw!"
      else
        current = current == player1 ? player2 : player1
      end
    end
  end

  def get_move(board)
    loop do
      print 'Select a column from 1 to 7: '
      col = gets.chomp.to_i
      unless [1, 2, 3, 4, 5, 6, 7].include?(col)
        puts 'Not a valid selection!'
        next
      end
      current_fill = board.column_fill["c#{col}"]
      if current_fill == 5
        puts 'Column is full! Please select another'
        next
      else
        board.column_fill["c#{col}"] += 1
        return [5 - current_fill, col - 1]
      end
    end
  end
end

game = Game.new
loop do
  break if game.game_menu == 2

  game.play_game
end
