-- Created by William James 
--Final Product Created 4th of October 2024
-- Import the Composer library to manage scenes
local composer = require("composer") -- Import composer for scene management
local scene = composer.newScene() -- Create a new scene
local C = require("commonFunctions") -- Import common functions for game logic
local currentScene = composer.getSceneName("current") -- Get the name of the current scene

-- Game variables
local whichTurn  -- Variable to track whose turn it is (X or O)
local gameOver = false -- Flag to indicate if the game is over
local boardGroup  -- Group to hold the board elements
local moves = {} -- Table to store the history of moves

local textObjects = {} -- Table to store text objects representing moves

local undoButton  -- Variable for the Undo button

-- Function to handle player's move in PvP mode
local function fill(event)
    -- Check if the touch phase has begun and the game is not over
    if event.phase == "began" and not gameOver then
        for i = 1, 9 do -- Loop through the board cells
            -- Check if the touch event is within the bounds of a cell and if it is empty
            if
                event.x > board[i][3] and event.x < board[i][5] and event.y < board[i][4] and event.y > board[i][6] and
                    board[i][7] == C.EMPTY
             then
                board[i][7] = whichTurn -- Mark the board cell with the current player's symbol
                local player = (whichTurn == C.X) and "X" or "O" -- Determine the player's symbol

                -- Create a text object to display the player's symbol on the board
                local text =
                    display.newText(
                    boardGroup,
                    player,
                    board[i][3] + C.w20 / 2,
                    board[i][6] + C.h20 / 2,
                    native.systemFontBold,
                    40
                )

                -- Set the text color based on the player
                if whichTurn == C.X then
                    text:setFillColor(0.694, 0.454, 0.341) -- Color for Player X
                else
                    text:setFillColor(0.847, 0.823, 0.76) -- Color for Player O
                end

                -- Store the text object in the textObjects table
                textObjects[i] = text

                -- Save the move to history
                table.insert(moves, {player = player, position = i, text = text})

                -- Track the move using the common function
                C.trackMove(whichTurn, i)

                -- Check for a win for Player X
                if C.checkWin(board, C.X) then
                    C.gameOverScreen("Player X Wins!", boardGroup, currentScene, startPlayer) -- Show game over screen
                    gameOver = true -- Set the game over flag
                    Runtime:removeEventListener("touch", fill) -- Remove touch listener
                    undoButton:removeSelf() -- Remove the undo button
                    return -- Exit the function
                end

                -- Check for a win for Player O
                if C.checkWin(board, C.O) then
                    C.gameOverScreen("Player O Wins!", boardGroup, currentScene, startPlayer) -- Show game over screen
                    gameOver = true -- Set the game over flag
                    Runtime:removeEventListener("touch", fill) -- Remove touch listener
                    undoButton:removeSelf() -- Remove the undo button
                    return -- Exit the function
                end

                -- Check for a draw
                if C.checkDraw(board) then
                    C.gameOverScreen("It's a draw!", boardGroup, currentScene, startPlayer) -- Show game over screen
                    gameOver = true -- Set the game over flag
                    Runtime:removeEventListener("touch", fill) -- Remove touch listener
                    undoButton:removeSelf() -- Remove the undo button
                    return -- Exit the function
                end

                -- Switch turns
                whichTurn = (whichTurn == C.X) and C.O or C.X
                break -- Exit the loop after a successful move
            end
        end
    end
end

-- Function to create the game board
function createBoard()
    board = C.createBoard(boardGroup) -- Create the board using a common function
    gameOver = false -- Reset the gameOver status
    Runtime:addEventListener("touch", fill) -- Add touch listener for player moves
end

function scene:create(event)
    local sceneGroup = self.view -- Get the scene's view group
    boardGroup = display.newGroup() -- Create a group for the board elements
    sceneGroup:insert(boardGroup) -- Insert the board group into the scene

    -- Retrieve the starting player passed from whoGoesFirst.lua
    local params = event.params or {}
    whichTurn = params.startPlayer -- Set the starting player
    startPlayer = params.startPlayer -- Store the starting player for reference
    print(startPlayer) -- Print the starting player for debugging

    -- Create the game board
    createBoard()

    -- Create Undo button
    undoButton =
        display.newText("Undo", display.contentCenterX, display.contentHeight * 0.95, native.systemFontBold, 30)
    undoButton:setFillColor(1, 0.968, 0.941) -- Set the button color
    undoButton:addEventListener(
        "tap",
        function()
            local lastPlayer = C.undoLastMove(board, boardGroup, textObjects, undoButton, false) -- Undo the last move
            if lastPlayer then
                whichTurn = lastPlayer -- Switch turns back to the last player
            end
        end
    )
end

-- Add the scene event listener for 'create'
scene:addEventListener("create", scene)

-- Return the scene object for external access
return scene