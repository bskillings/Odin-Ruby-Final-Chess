require_relative "player"
require_relative "chesspiece"
require_relative "chessboard"
require_relative "chessio"
require_relative "chessgame"


start = ChessIO.new

#there is a lot of repeated code between find_rook_move, find_bishop_move, and find_queen_move

#to do:

#decide if moves should be under game, board, pieces, or what

#decide how to get error messages to players, you don't own that piece, etc