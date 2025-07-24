# odin-chess-ruby
The Odin Project's capstone Chess project

Let's plan and outline the project before writing code.

Chess has many layers: 
1. setting up a board, placing pieces - DONE
2. displaying the board and different colors - DONE
- Chess Notation - DONE
- FEN Notation - DONE
3. basic movement for one piece - DONE
- generating all possible moves - DONE
- validating the moves
  1. possible move? - DONE
  2. validate destination? - DONE
  -- either empty square - DONE
  -- or capturing enemy piece - DONE
  -- path is clear
  3. castling_available?
  -- have castle & rook moved?
  -- empty squares in between?
  -- king in check?
  4. en_passant_allowed?
  5. legal_pawn_moves?
  -- 2 square forward if not moved
  -- diagonal capture
  -- en passant
  -- promotion
  6. check & checkmate - leave_king_in_check?
4. expanding to all pieces and movements for all pieces - DONE
4a. expanding validation checks to all pieces
5. game state management 
- switching turns
- adding check and checkmate (includes win & game over)
6. saving game state
- export & load game state 
7. adding advanced moves, e.g. castling, en passant, promotion

# Composed Systems 

## main.rb
Purpose: Entry point and main execution
- Creates a new Game
- Sets up game loop and repeat play if player chooses y
Instance variables: None
Instance method:
- Scripted loop
-- Create new game
-- Start
-- play

## Game
Purpose: Game flow controller
- It tells collaborators to take actions
- It tells collaborators to check things  
Instance Method:
- tracks state of board - whose turn is it?
- checks check & checkmate 
- delegates to saving the game state
- loads new games

## Board class
Purpose: Manages game rules, delegates to helpers
Instance variable:
- 2D array chess board
Instance methods:
- Move execution (store result of move)
- Updating board
Instance variables:
Instance methods:
TBD

## Rules Engine module
Purpose: Calculate all valid moves
- generates all moves
- discards invalid moves


## Interface module
Purpose: Controls IO and delegates to helpers
Instance methods:
- Request player name
- Get's player move input
- Displays board
- Displays win & game over announcements

### Display module
Purpose: Helps Display board and pieces
- Job to make the board look user friendly

### DataValidator
- Validates & cleanses inputs

### ChessNotation

## MoveFinder
Purpose: Find all possible moves, including
validating en passant, castling, and promotion
possibilities for every player's turn

# Value Objects

## Position
Purpose: Holds x, y coordinates, or row & column

## Move

# Interaction Stories

## Display a new game board
A new Game begins. The Game asks the Interface to 
display the current board. The Interface displays
the Board. It shows all Pieces in the correct 
beginning Positions. No Piece has yet made any Moves.

## Player makes a move
When a player wants to make a move, Interface asks &
accepts the player's move request. Game tells 
Board to make the move. Board tells MoveFinder to discover
all possible moves. Board tells MoveValidator to 
validate if the move is legal. If legal,
Game tells Board to update its state. Board clears the
"from" position and updates the "to" position with the 
moved Piece. Board updates relevant flags.
Game saves the game state. Game 
asks Interface to display the updated Game.
Game needs to check for check or checkmate. If
the game isn't over, Game switches which 
player's turn it is. 

If illegal, Game tells Interface to ask Player to
provide another move.
