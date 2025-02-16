-- Created by William James 10578252
-- On Campus Joondalup ECU
-- Professor Mike Johnstone
-- Due Date Due Friday 4th of October 2024 14:00

-- Import the Composer library to manage scenes
local composer = require("composer")
local scene = composer.newScene()
local C = require("commonFunctions") -- Import common functions for game logic
local currentScene = composer.getSceneName("current") -- Get the current scene name

-- Game variables
local board  -- Game board matrix
local whichTurn  -- Indicates which player's turn it is (X or O)
local gameOver = false -- Boolean to track if the game has ended
local boardGroup  -- Group for the display objects representing the game board
local startPlayer  -- The player who starts the game (X or O)
local textObjects = {} -- Table to store text objects representing moves on the board
local undoButton  -- Button to undo the last move

-- Function to handle player's move in Player vs Computer mode
local function fill(event)
    -- Check if touch event has started and the game is not over
    if event.phase == "began" and not gameOver then
        -- Loop through each cell of the board
        for i = 1, 9 do
            -- Check if the touch is within the bounds of a board cell and the cell is empty
            if
                event.x > board[i][3] and event.x < board[i][5] and event.y < board[i][4] and event.y > board[i][6] and
                    board[i][7] == C.EMPTY
             then
                -- Player (X) makes a move by marking the cell with X
                board[i][7] = C.X
                -- Display the move as a text object on the board
                local text =
                    display.newText(
                    boardGroup,
                    "X", -- Display 'X' for the player
                    board[i][3] + C.w20 / 2, -- X position of the text
                    board[i][6] + C.h20 / 2, -- Y position of the text
                    native.systemFontBold, -- Use bold system font
                    40 -- Font size
                )
                text:setFillColor(0.694, 0.454, 0.341) -- Set text color to brown
                print("Player X clicked cell: " .. board[i][1]) -- Log the move in the console

                -- Store the text object in the textObjects table for tracking
                textObjects[i] = text

                -- Track the move (for undo functionality, etc.)
                C.trackMove(C.X, i, text)

                -- Check if Player X wins
                if C.checkWin(board, C.X) then
                    -- Display the game over screen with "Player X Wins!" message
                    C.gameOverScreen("Player X Wins!", boardGroup, currentScene, startPlayer)
                    gameOver = true -- Set game over status
                    Runtime:removeEventListener("touch", fill) -- Remove the touch event listener
                    undoButton:removeSelf() -- Remove the undo button since the game is over
                    return
                end

                -- Check for a draw
                if C.checkDraw(board) then
                    -- Display the game over screen with a draw message
                    C.gameOverScreen("It's a draw!", boardGroup, currentScene, startPlayer)
                    gameOver = true -- Set game over status
                    Runtime:removeEventListener("touch", fill) -- Remove the touch event listener
                    undoButton:removeSelf() -- Remove the undo button since the game is over
                    return
                end

                -- Computer (O) makes its move
                C.computerMove(board, boardGroup, textObjects)

                -- Check if the Computer wins
                if C.checkWin(board, C.O) then
                    -- Display the game over screen with "Computer Wins!" message
                    C.gameOverScreen("Computer Wins!", boardGroup, currentScene, startPlayer)
                    gameOver = true -- Set game over status
                    Runtime:removeEventListener("touch", fill) -- Remove the touch event listener
                    undoButton:removeSelf() -- Remove the undo button since the game is over
                    return
                end

                -- Check for a draw after the Computer's move
                if C.checkDraw(board) then
                    -- Display the game over screen with a draw message
                    C.gameOverScreen("It's a draw!", boardGroup, currentScene, startPlayer)
                    gameOver = true -- Set game over status
                    Runtime:removeEventListener("touch", fill) -- Remove the touch event listener
                    undoButton:removeSelf() -- Remove the undo button since the game is over
                    return
                end
                break -- Break out of the loop once a move is made
            end
        end
    end
end

-- Function to create the game board
local function createBoard()
    board = C.createBoard(boardGroup) -- Create the game board using the common function
    gameOver = false -- Reset the gameOver status to start a new game

    -- If the Computer (Player O) starts, make its move first
    if whichTurn == C.O then
        C.computerMove(board, boardGroup, textObjects)
    end
    Runtime:addEventListener("touch", fill) -- Add the touch event listener for player moves
end

-- Scene creation function
function scene:create(event)
    local sceneGroup = self.view -- Create a group for scene objects
    boardGroup = display.newGroup() -- Create a new group for the game board
    sceneGroup:insert(boardGroup) -- Insert the board group into the scene group

    -- Retrieve the starting player from the parameters passed from whoGoesFirst.lua
    local params = event.params or {}
    whichTurn = params.startPlayer -- Set which player's turn it is
    startPlayer = params.startPlayer -- Set the starting player for future reference
    targetScene = params.targetScene -- Set the target scene (PvC or PvC_Hard)

    -- Create the game board
    createBoard()

    -- Create Undo button for undoing the last move
    undoButton =
        display.newText(
        "Undo", -- Button label
        display.contentCenterX, -- Center horizontally
        display.contentHeight * 0.95, -- Position near the bottom of the screen
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    undoButton:setFillColor(1, 0.968, 0.941) -- Set button text color to light
    -- Add event listener for the undo button to undo the last move
    undoButton:addEventListener(
        "tap",
        function()
            C.undoLastMove(board, boardGroup, textObjects, undoButton, true) -- Call common function to undo the move
        end
    )
end

-- Add the scene event listener for 'create'
scene:addEventListener("create", scene)

-- Return the scene object
return scene