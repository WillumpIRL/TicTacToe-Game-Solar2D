# Tic-Tac-Toe Game (Solar2D)

## Overview
This is a Tic-Tac-Toe game developed using Solar2D. It includes multiple game modes such as Player vs Player (PvP), Player vs Computer (PvC) with easy and hard difficulty levels, and a replay system to review past games. The game is managed using the Composer scene manager.

## Files and Their Functions

### 1. **main.lua**
- Entry point of the game.
- Initializes Solar2D and hides the status bar.
- Loads the background image.
- Directs the user to the main menu scene (`menu.lua`).

### 2. **menu.lua**
- Displays the main menu with options:
  - Player vs Player (`PvP.lua`)
  - Player vs Computer (`difficulty.lua` to choose difficulty)
  - View game statistics (`stats.lua`)
- Handles scene transitions based on user selection.

### 3. **difficulty.lua**
- Provides an interface to choose between Easy and Hard difficulty for Player vs Computer mode.
- Redirects to `whoGoesFirst.lua` with the chosen difficulty (`PvC.lua` or `PvC_Hard.lua`).

### 4. **whoGoesFirst.lua**
- Allows the player to choose whether they or the computer starts first.
- Redirects to the selected game mode (PvP, PvC, or PvC_Hard).

### 5. **PvP.lua**
- Implements the Player vs Player game mode.
- Alternates turns between Player X and Player O.
- Checks for winning conditions and displays results.
- Provides an undo function for moves.

### 6. **PvC.lua**
- Implements Player vs Computer mode (Easy difficulty).
- The computer makes random moves.
- Checks for win/draw conditions.
- Allows the player to undo their move.

### 7. **PvC_Hard.lua**
- Implements Player vs Computer mode (Hard difficulty).
- The computer makes strategic moves using predefined logic.
- Checks for win/draw conditions.
- Allows the player to undo their move.

### 8. **replay.lua**
- Replays the last recorded game move by move.
- Retrieves and plays stored moves in sequence.
- Returns to the main menu after replaying the game.

### 9. **stats.lua**
- Loads and displays player game statistics (wins, losses, draws).
- Provides options to reset statistics.
- Returns to the main menu.

### 10. **commonFunctions.lua**
- Contains shared functions used across multiple game modes:
  - Board creation and rendering.
  - Move tracking and undo functionality.
  - Win and draw detection.
  - Computer move logic for Easy and Hard difficulties.
  - Saving and loading game statistics.
  - Displaying the game over screen.

## Running the Game
### Requirements:
- **Solar2D SDK** (Download from [https://solar2d.com/](https://solar2d.com/))
- A system capable of running Solar2D Simulator

### Steps to Run:
1. Install Solar2D on your system.
2. Open the project folder in Solar2D.
3. Run `main.lua` in the Solar2D Simulator.
4. The game will start at the main menu, allowing you to choose a game mode.

### Controls:
- Tap on the buttons to navigate through menus.
- Tap on the board to make a move.
- Use the "Undo" button to reverse your last move (if applicable).
- The game will detect wins and draws automatically.
- At the end of a game, you can choose to replay, start a new game, or return to the menu.

## Notes:
- The game saves statistics locally.
- The replay system allows you to review the previous game step by step.
- The AI in Hard mode plays optimally, making it a more challenging opponent.

Enjoy playing Tic-Tac-Toe!


