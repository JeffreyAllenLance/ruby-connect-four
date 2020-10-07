# frozen_string_literal: true

require 'connect_four'

# rubocop: disable Metrics/BlockLength

describe Board do
  let(:board) { Board.new }

  describe '#generate_board' do
    let(:expected_board) do
      [[' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ']]
    end
    context 'when generating a board' do
      it { expect(board.generate_board).to eql(expected_board) }
    end
  end

  describe '#add_piece' do
    context 'when adding a black piece' do
      let(:player) { Player.new('Black') }
      it {
        expect do
          board.add_piece(player.piece, [0, 0])
        end.to(change { board.board[0][0] }.from(' ').to("\u26aa"))
      }
    end

    context 'when adding a white piece' do
      let(:player) { Player.new('White') }
      it {
        expect do
          board.add_piece(player.piece, [0, 0])
        end.to(change { board.board[0][0] }.from(' ').to("\u26ab"))
      }
    end
  end

  describe '#adjacent_lines' do
    context 'when space is in center' do
      let(:adjacent) do
        {
          'v-u' => [[2, 3], [1, 3], [0, 3]],
          'v-d' => [[4, 3], [5, 3]],
          'h-l' => [[3, 2], [3, 1], [3, 0]],
          'h-r' => [[3, 4], [3, 5], [3, 6]],
          'di-ul' => [[2, 2], [1, 1], [0, 0]],
          'di-ur' => [[2, 4], [1, 5], [0, 6]],
          'di-dl' => [[4, 2], [5, 1]],
          'di-dr' => [[4, 4], [5, 5]]
        }
      end
      it { expect(board.adjacent_lines([3, 3])).to eql(adjacent) }
    end

    context 'when space is in corner' do
      let(:adjacent) do
        {
          'v-u' => [],
          'v-d' => [[1, 0], [2, 0], [3, 0]],
          'h-l' => [],
          'h-r' => [[0, 1], [0, 2], [0, 3]],
          'di-ul' => [],
          'di-ur' => [],
          'di-dl' => [],
          'di-dr' => [[1, 1], [2, 2], [3, 3]]
        }
      end
      it { expect(board.adjacent_lines([0, 0])).to eql(adjacent) }
    end
  end

  describe 'check_win' do
    let(:player1) { Player.new('Black') }
    let(:player2) { Player.new('White')}
    context 'when player wins vertically' do
      it do
        board.add_piece(player1.piece, [5, 0])
        board.add_piece(player1.piece, [4, 0])
        board.add_piece(player1.piece, [3, 0])
        board.add_piece(player1.piece, [2, 0])
        expect(board.check_win(player1)).to eql(true)
      end
    end
    
    context 'when player wins diagonally' do
      it do
        board.add_piece(player1.piece, [0, 0])
        board.add_piece(player1.piece, [1, 1])
        board.add_piece(player1.piece, [2, 2])
        board.add_piece(player1.piece, [3, 3])
        expect(board.check_win(player1)).to eql(true)
      end
    end

    context 'when player has 4 not in a row' do
      it do
        board.add_piece(player1.piece, [0, 0])
        board.add_piece(player1.piece, [1, 3])
        board.add_piece(player1.piece, [5, 2])
        board.add_piece(player1.piece, [3, 3])
        expect(board.check_win(player1)).to eql(false)
      end
    end

    context 'when there are 4 in a row of different colors' do
      it do
        board.add_piece(player1.piece, [0, 0])
        board.add_piece(player2.piece, [1, 1])
        board.add_piece(player1.piece, [2, 2])
        board.add_piece(player2.piece, [3, 3])
        expect(board.check_win(player1)).to eql(false)
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength
