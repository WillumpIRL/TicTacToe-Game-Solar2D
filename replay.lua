-- Created by William James 
--Final Product Created 4th of October 2024

-- Import the Composer library to manage scenes
local composer = require("composer") -- Import composer for scene management
local scene = composer.newScene() -- Create a new scene
local C = require("commonFunctions") -- Import common functions for game logic

function scene:create(event)
    local sceneGroup = self.view -- Create a group for the scene

    -- Create a group for replay objects
    local replayGroup = display.newGroup() -- Create a new group for replay-specific elements
    sceneGroup:insert(replayGroup) -- Insert the replay group into the scene group

    -- Create the game board
    local boardGroup = display.newGroup() -- Create a group for the game board
    sceneGroup:insert(boardGroup) -- Insert the board group into the scene
    local board = C.createBoard(boardGroup) -- Create the game board using a common function

    -- Load game moves and determine the starting player
    local gameMoves = C.moveHistory -- Retrieve the list of moves from the common module
    local startPlayer = event.params.startPlayer -- Get the starting player from event parameters

    -- Determine the symbols for player 1 (X) and player 2 (O)
    local player1Symbol, player2Symbol
    if startPlayer == C.X then
        player1Symbol = "X" -- Player 1 is X
        player2Symbol = "O" -- Player 2 is O
    else
        player1Symbol = "X" -- Player 1 is still X
        player2Symbol = "O" -- Player 2 is O
    end

    -- Replay the game moves
    local moveIndex = 1 -- Initialize the index for game moves
    local function replayMove()
        -- Check if there are moves left to replay
        if moveIndex <= #gameMoves then
            local move = gameMoves[moveIndex] -- Get the current move
            local boardPosition = move.position -- Extract the board position from the move
            local player = move.player -- Get the player who made the move
            local text  -- Variable to hold the text symbol (X or O)

            -- Determine which symbol to display based on the player
            if player == 1 then
                text = player1Symbol -- Player 1's symbol
            else
                text = player2Symbol -- Player 2's symbol
            end

            -- Find the correct board position to place the move
            for i = 1, #board do
                if board[i][2] == boardPosition then -- Check if the position matches
                    -- Create a text object to display the player's move
                    local newText =
                        display.newText(
                        boardGroup,
                        text, -- Symbol to display (X or O)
                        board[i][3] + C.w20 / 2, -- X position of the text
                        board[i][6] + C.h20 / 2, -- Y position of the text
                        native.systemFontBold, -- Use bold system font
                        40 -- Font size
                    )
                    -- Set text color based on the player
                    if player == C.X then
                        newText:setFillColor(0.694, 0.454, 0.341) -- Color for Player X
                    else
                        newText:setFillColor(0.847, 0.823, 0.76) -- Color for Player O
                    end
                    break -- Exit the loop after placing the move
                end
            end

            moveIndex = moveIndex + 1 -- Move to the next move
            timer.performWithDelay(500, replayMove) -- Call replayMove again after 500 ms
        else
            -- Game replay finished, clear the move history and return to the stats scene
            C.clearMoveHistory() -- Clear move history for future games
            composer.removeScene("replay") -- Remove the replay scene from the memory
            composer.removeScene("whoGoesFirst") -- Remove the replay scene from the whoGoesFirst
            composer.gotoScene("menu", {effect = "fade", time = 200}) -- Transition to the menu scene
        end
    end

    -- Start the replay of moves
    replayMove() -- Call the function to start replaying moves
end

-- Add the scene event listener for 'create'
scene:addEventListener("create", scene)

-- Return the scene object for external access
return scene