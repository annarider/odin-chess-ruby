# odin-chess-ruby
The Odin Project's capstone Chess project

Let's plan and outline the project before writing code.

Chess has many layers: 
1. setting up a board, placing pieces
2. displaying the board and different colors
3. basic movement for one piece
- generating all possible moves
- validating the moves
4. expanding to all pieces and movements for all pieces
5. adding check and checkmate (includes win & game over)
6. adding exotic moves, e.g. castling

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

## StateManager
Purpose: Tracks state of the game and board 
Instance Method:
- tracks state of board
- manages saving the game state
- loads new games

## Board class
Purpose: Manages game rules, delegates to helpers
Instance variable:
- 2D array chess board
Instance methods:
- Move validation
- Move execution (store result of move)
- Updating board
Instance variables:
Instance methods:
TBD

## Interface module
Purpose: Controls IO and delegates to helpers
Instance methods:
- Request player name
- Get's player move input
- Displays board
- Displays win & game over announcements

### BoardArtist
Purpose: Helps Display board and pieces
- Job to make the board look user friendly

### DataQualityAnalyst
- Validates & cleanses inputs


## PathFinder
TODO

# Inheritance Pieces

## PlayerManager class
Purpose: Creates a new player and color
Instance variables:
- @name
- @color
Instance methods:
- Sets the player name
- Sets the player color

## King class
Constants: Valid moves in array


## Queen class (child)
Constants: Valid moves in array

## Rook class (child)
Constants: Valid moves in array

## Bishop class (child)
Constants: Valid moves in array

## Knight class (child)
Constants: Valid moves in array

## Pawns class (child)
Constants: Valid moves in array

# Value Objects

## Position 

## Move

# Interaction Stories

## Display a new game board
A new Game begins. The Game asks the Interface to 
display the current board. The Interface displays
the Board. It shows all Pieces in the correct 
beginning Positions. No Piece has yet made any Moves.

## Player makes a move
When a player wants to make a move, Interface
accepts the player's move request. Game asks 
Board to check if the move is valid. If valid,
Game asks State to update the game state.
State make sure the Piece is now moved to the
new Position. State saves the game state. Game 
asks Interface to display the updated Game.
Game needs to check for check or checkmate. If
the game isn't over, Game switches which 
player's turn it is. 
