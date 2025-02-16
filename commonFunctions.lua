-- Created by William James 
--Final Product Created 4th of October 2024

-- Import the Composer library to manage scenes
local C = {} -- Create a table to hold common functions and variables
local composer = require("composer") -- Require the composer module for scene management
local statsFile = system.pathForFile("game_stats.txt", system.DocumentsDirectory) -- Define the path for the game statistics file

-- Create a table to store move history
C.moveHistory = {}

-- Define display variables and board dimensions based on screen size
local d = display
C.w20 = d.contentWidth * 0.2 -- 20% of screen width
C.h20 = d.contentHeight * 0.2 -- 20% of screen height
C.w40 = d.contentWidth * 0.4 -- 40% of screen width
C.h40 = d.contentHeight * 0.4 -- 40% of screen height
C.w60 = d.contentWidth * 0.6 -- 60% of screen width
C.h60 = d.contentHeight * 0.6 -- 60% of screen height
C.w80 = d.contentWidth * 0.8 -- 80% of screen width
C.h80 = d.contentHeight * 0.8 -- 80% of screen height

-- Game variable definitions for empty and player marks
C.EMPTY, C.X, C.O = 0, 1, 2

-- Function to create the game board
function C.createBoard(boardGroup)
    -- Initialize the board with positions, coordinates, and empty status
    local board = {
        {"tl", 1, C.w20, C.h40, C.w40, C.h20, C.EMPTY},
        {"tm", 2, C.w40, C.h40, C.w60, C.h20, C.EMPTY},
        {"tr", 3, C.w60, C.h40, C.w80, C.h20, C.EMPTY},
        {"ml", 4, C.w20, C.h60, C.w40, C.h40, C.EMPTY},
        {"mm", 5, C.w40, C.h60, C.w60, C.h40, C.EMPTY},
        {"mr", 6, C.w60, C.h60, C.w80, C.h40, C.EMPTY},
        {"bl", 7, C.w20, C.h80, C.w40, C.h60, C.EMPTY},
        {"bm", 8, C.w40, C.h80, C.w60, C.h60, C.EMPTY},
        {"br", 9, C.w60, C.h80, C.w80, C.h60, C.EMPTY}
    }

    -- Draw the horizontal lines of the game board
    local obj = display.newLine(boardGroup, C.w20, C.h40, C.w80, C.h40)
    obj.strokeWidth = 5 -- Set line thickness
    obj = display.newLine(boardGroup, C.w20, C.h60, C.w80, C.h60)
    obj.strokeWidth = 5

    -- Draw the vertical lines of the game board
    obj = display.newLine(boardGroup, C.w40, C.h20, C.w40, C.h80)
    obj.strokeWidth = 5
    obj = display.newLine(boardGroup, C.w60, C.h20, C.w60, C.h80)
    obj.strokeWidth = 5

    return board -- Return the created board
end

-- Function to draw lines for the board (for further customization)
function C.drawLines(boardGroup)
    -- Draw vertical lines
    local obj = display.newLine(boardGroup, C.w40, C.h20, C.w40, C.h80)
    obj.strokeWidth = 5
    obj = display.newLine(boardGroup, C.w60, C.h20, C.w60, C.h80)
    obj.strokeWidth = 5

    -- Draw horizontal lines
    obj = display.newLine(boardGroup, C.w20, C.h40, C.w80, C.h40)
    obj.strokeWidth = 5
    obj = display.newLine(boardGroup, C.w20, C.h60, C.w80, C.h60)
    obj.strokeWidth = 5
end

-- Function to check for a winner
function C.checkWin(board, player)
    -- Define all possible winning patterns
    local winPatterns = {
        {1, 2, 3}, -- Horizontal rows
        {4, 5, 6},
        {7, 8, 9},
        {1, 4, 7}, -- Vertical columns
        {2, 5, 8},
        {3, 6, 9},
        {1, 5, 9}, -- Diagonal patterns
        {3, 5, 7}
    }

    -- Check each winning pattern against the player's moves
    for i = 1, #winPatterns do
        local a, b, c = winPatterns[i][1], winPatterns[i][2], winPatterns[i][3]
        if board[a][7] == player and board[b][7] == player and board[c][7] == player then
            return true -- Return true if a winning pattern is found
        end
    end
    return false -- Return false if no winning pattern is found
end

-- Function to check for a draw
function C.checkDraw(board)
    -- Check if all squares are filled
    for t = 1, 9 do
        if board[t][7] == C.EMPTY then
            return false -- Return false if any square is empty
        end
    end
    return true -- Return true if all squares are filled (draw)
end

-- Function to check if the center square is free
function C.isCenterFree(board)
    return board[5][7] == C.EMPTY -- Return true if the center is empty
end

-- Function to check if there is a corner occupied by the opponent
function C.isOpponentInCorner(board, opponent)
    local corners = {1, 3, 7, 9} -- Define the corner positions
    for _, corner in ipairs(corners) do
        if board[corner][7] == opponent then
            return corner -- Return the occupied corner position
        end
    end
    return nil -- Return nil if no corner is occupied by the opponent
end

-- Function to get the opposite corner position
function C.getOppositeCorner(corner)
    return 10 - corner -- Return the opposite corner
end

-- Function to create two lines of two for potential winning moves
function C.createTwoLinesOfTwo(board, computerMark)
    local bestMove = nil -- Initialize variable to store the best move

    -- Loop through all empty squares on the board
    for i = 1, 9 do
        if board[i][7] == C.EMPTY then -- Check for empty square
            local count = 0 -- Initialize count for potential lines of two

            -- Check the row for potential two in a row
            for j = 1, 3 do -- Loop through the row (adjust based on board structure)
                if (board[i][j] == computerMark or board[i][j] == C.EMPTY) then
                    count = count + 1 -- Increment count for matching marks or empty squares
                end
            end

            -- Check if this move creates two in a row in the row
            if count >= 2 then
                local rowCount = 0
                for j = 1, 3 do
                    if board[i][j] == computerMark then
                        rowCount = rowCount + 1 -- Count the computer's marks in the row
                    end
                end
                if rowCount == 2 then
                    count = count - 1 -- Adjust count to avoid false positives
                end
            end

            -- Check the column for potential two in a row
            count = 0 -- Reset count for column check
            for j = 1, 3 do -- Loop through the column
                if (board[j][i] == computerMark or board[j][i] == C.EMPTY) then
                    count = count + 1 -- Increment count for matching marks or empty squares
                end
            end

            -- Check if this move creates two in a row in the column
            if count >= 2 then
                local colCount = 0
                for j = 1, 3 do
                    if board[j][i] == computerMark then
                        colCount = colCount + 1 -- Count the computer's marks in the column
                    end
                end
                if colCount == 2 then
                    count = count - 1 -- Adjust count to avoid false positives
                end
            end

            -- Check for diagonal conditions
            if i == 1 or i == 3 or i == 7 or i == 9 then -- Main diagonal check
                count = 0 -- Reset count
                for j = 1, 3 do
                    if (board[j][j] == computerMark or board[j][j] == C.EMPTY) then
                        count = count + 1 -- Increment count for matching marks or empty squares
                    end
                end
                if count >= 2 then
                    bestMove = i -- Store best move if two in a row is possible
                    return bestMove -- Return best move immediately
                end
            end

            if i == 3 or i == 5 or i == 7 then -- Anti-diagonal check
                count = 0 -- Reset count
                for j = 1, 3 do
                    if (board[j][4 - j] == computerMark or board[j][4 - j] == C.EMPTY) then
                        count = count + 1 -- Increment count for matching marks or empty squares
                    end
                end
                if count >= 2 then
                    bestMove = i -- Store best move if two in a row is possible
                    return bestMove -- Return best move immediately
                end
            end
        end
    end
    return bestMove -- Return the best move if found
end

-- Function to find a winning move for a given player
function C.findWinningMove(board, player)
    -- Iterate over all cells on the board
    for i = 1, 9 do
        -- Check if the cell is empty
        if board[i][7] == C.EMPTY then
            -- Temporarily make the move for the player
            board[i][7] = player
            -- Check if this move results in a win
            if C.checkWin(board, player) then
                -- Undo the move and return this position as a winning move
                board[i][7] = C.EMPTY
                return i
            end
            -- Undo the move if it did not result in a win
            board[i][7] = C.EMPTY
        end
    end
    return nil -- Return nil if no winning move is found
end

-- Function for the computer to make a random move
function C.computerMove(board, boardGroup, textObjects)
    local availableCells = {} -- Table to store available cells
    -- Identify available cells on the board
    for i = 1, 9 do
        if board[i][7] == C.EMPTY then
            table.insert(availableCells, i) -- Add empty cell to available cells
        end
    end

    -- If there are available cells, choose one randomly
    if #availableCells > 0 then
        local randomIndex = math.random(#availableCells) -- Select a random index
        local move = availableCells[randomIndex] -- Get the corresponding move
        board[move][7] = C.O -- Make the move for the computer
        -- Create and display the text for the move
        local text =
            display.newText(
            boardGroup,
            "O",
            board[move][3] + C.w20 / 2,
            board[move][6] + C.h20 / 2,
            native.systemFontBold,
            40
        )
        text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
        textObjects[move] = text -- Store the text object
        print("Computer played: " .. board[move][1]) -- Print the computer's move

        -- Track the computer's move
        C.trackMove(C.O, move)
    end
end

-- Function for the computer to make a hard move
function C.hardComputerMove(board, boardGroup, textObjects)
    -- Check for a winning move for the computer
    local winningMove = C.findWinningMove(board, C.O)
    if winningMove then
        board[winningMove][7] = C.O -- Make the winning move
        -- Create and display the text for the move
        local text =
            display.newText(
            boardGroup,
            "O",
            board[winningMove][3] + C.w20 / 2,
            board[winningMove][6] + C.h20 / 2,
            native.systemFontBold,
            40
        )
        text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
        textObjects[winningMove] = text -- Store the text object
        print("Computer played1: " .. board[winningMove][1]) -- Print the computer's move
        -- Track the computer's move
        C.trackMove(C.O, winningMove)
        return -- Exit function after making the winning move
    end

    -- Check for a blocking move to prevent the opponent from winning
    local blockingMove = C.findWinningMove(board, C.X)
    if blockingMove then
        board[blockingMove][7] = C.O -- Make the blocking move
        -- Create and display the text for the move
        local text =
            display.newText(
            boardGroup,
            "O",
            board[blockingMove][3] + C.w20 / 2,
            board[blockingMove][6] + C.h20 / 2,
            native.systemFontBold,
            40
        )
        text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
        textObjects[blockingMove] = text -- Store the text object
        print("Computer played2: " .. board[blockingMove][1]) -- Print the computer's move
        -- Track the computer's move
        C.trackMove(C.O, blockingMove)
        return -- Exit function after making the blocking move
    end

    -- Check for creating two lines of two
    local twoLinesMove = C.createTwoLinesOfTwo(board, C.O)
    if twoLinesMove then
        board[twoLinesMove][7] = C.O -- Make the move
        -- Create and display the text for the move
        local text =
            display.newText(
            boardGroup,
            "O",
            board[twoLinesMove][3] + C.w20 / 2,
            board[twoLinesMove][6] + C.h20 / 2,
            native.systemFontBold,
            40
        )
        text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
        textObjects[twoLinesMove] = text -- Store the text object
        print("Computer played3: " .. board[twoLinesMove][1]) -- Print the computer's move
        -- Track the computer's move
        C.trackMove(C.O, twoLinesMove)
        return -- Exit function after making the move
    end

    -- Check if the center cell is free
    if C.isCenterFree(board) then
        board[5][7] = C.O -- Make the move in the center
        -- Create and display the text for the move
        local text =
            display.newText(
            boardGroup,
            "O",
            board[5][3] + C.w20 / 2,
            board[5][6] + C.h20 / 2,
            native.systemFontBold,
            40
        )
        text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
        textObjects[5] = text -- Store the text object
        print("Computer played4: mm") -- Print the computer's move
        -- Track the computer's move
        C.trackMove(C.O, 5)
        return -- Exit function after making the move
    end

    -- Check if the opponent is in a corner
    local opponentCorner = C.isOpponentInCorner(board, C.X)
    if opponentCorner then
        local oppositeCorner = C.getOppositeCorner(opponentCorner) -- Get the opposite corner
        if board[oppositeCorner][7] == C.EMPTY then
            board[oppositeCorner][7] = C.O -- Make the move in the opposite corner
            -- Create and display the text for the move
            local text =
                display.newText(
                boardGroup,
                "O",
                board[oppositeCorner][3] + C.w20 / 2,
                board[oppositeCorner][6] + C.h20 / 2,
                native.systemFontBold,
                40
            )
            text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
            textObjects[oppositeCorner] = text -- Store the text object
            print("Computer played5: " .. board[oppositeCorner][1]) -- Print the computer's move
            -- Track the computer's move
            C.trackMove(C.O, oppositeCorner)
            return -- Exit function after making the move
        end
    end

    -- Check for any free corner
    local corners = {1, 3, 7, 9} -- Define the corners
    for _, corner in ipairs(corners) do
        if board[corner][7] == C.EMPTY then
            board[corner][7] = C.O -- Make the move in the free corner
            -- Create and display the text for the move
            local text =
                display.newText(
                boardGroup,
                "O",
                board[corner][3] + C.w20 / 2,
                board[corner][6] + C.h20 / 2,
                native.systemFontBold,
                40
            )
            text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
            textObjects[corner] = text -- Store the text object
            print("Computer played6: " .. board[corner][1]) -- Print the computer's move
            -- Track the computer's move
            C.trackMove(C.O, corner)
            return -- Exit function after making the move
        end
    end

    -- If no other move is made, play any empty cell
    for i = 1, 9 do
        if board[i][7] == C.EMPTY then
            board[i][7] = C.O -- Make the move
            -- Create and display the text for the move
            local text =
                display.newText(
                boardGroup,
                "O",
                board[i][3] + C.w20 / 2,
                board[i][6] + C.h20 / 2,
                native.systemFontBold,
                40
            )
            text:setFillColor(0.847, 0.823, 0.76) -- Set the text color
            textObjects[i] = text -- Store the text object
            print("Computer played7: " .. board[i][1]) -- Print the computer's move
            -- Track the computer's move
            C.trackMove(C.O, i)
            return -- Exit function after making the move
        end
    end
end
-- Function to track moves
function C.trackMove(player, position)
    -- Store the player's move (player and position) in the move history
    table.insert(C.moveHistory, {player = player, position = position})
    print("Tracking move: player =", player, "position =", position, "Move #", #C.moveHistory) -- Log the move
end

-- Function to clear move history
function C.clearMoveHistory()
    -- Reset the move history table to an empty state
    C.moveHistory = {}
end

-- Function to get move history
function C.getMoveHistory()
    -- Return the current move history
    return C.moveHistory
end

-- Function to undo the last move depending on game mode
function C.undoLastMove(board, boardGroup, textObjects, undoButton, removeBothMoves)
    if removeBothMoves then
        -- If removing both moves (for Player vs Computer mode)
        for i = 1, 2 do
            local lastMove = table.remove(C.moveHistory) -- Remove the last move from history
            if lastMove then
                local player, position = lastMove.player, lastMove.position
                -- Remove the mark from the board display
                if textObjects[position] then
                    textObjects[position]:removeSelf() -- Remove the displayed text for the move
                    textObjects[position] = nil -- Set the text object reference to nil
                end
                -- Reset the board position to empty
                board[position][7] = C.EMPTY
            end
        end
    else
        -- If removing just the last move (for Player vs Player mode)
        local lastMove = table.remove(C.moveHistory) -- Remove the last move from history
        if lastMove then
            local player, position = lastMove.player, lastMove.position
            -- Remove the mark from the board display
            if textObjects[position] then
                textObjects[position]:removeSelf() -- Remove the displayed text for the move
                textObjects[position] = nil -- Set the text object reference to nil
            end
            -- Reset the board position to empty
            board[position][7] = C.EMPTY
            return player -- Return the player who made the last move
        end
    end
end

-- Function to display the game over message
function C.gameOverScreen(result, boardGroup, currentScene, startPlayer)
    -- Update game statistics based on the result
    C.updateGameStats(result)

    -- Display the game over message on the screen
    local gameOverMessage =
        display.newText(result, display.contentCenterX, display.contentHeight * 0.1, native.systemFontBold, 40)
    gameOverMessage:setFillColor(1, 0.843, 0) -- Set the color of the game over message

    -- Create a group to hold the game over screen elements
    local gameOverGroup = display.newGroup()
    gameOverGroup:insert(gameOverMessage) -- Insert the game over message into the group

    -- Create a rematch button
    local rematchButton =
        display.newText("Rematch", display.contentCenterX - 100, display.contentHeight * 0.9, native.systemFontBold, 25)
    rematchButton:setFillColor(0.847, 0.823, 0.76) -- Set the color of the rematch button
    rematchButton:addEventListener(
        "tap",
        function()
            C.clearMoveHistory() -- Clear move history for a new game
            -- Remove the game over screen elements
            gameOverGroup:removeSelf()
            -- Destroy the current scene to reset the game
            composer.removeScene(currentScene)
            -- Compose a new scene, passing the start player
            composer.gotoScene(currentScene, {params = {startPlayer = startPlayer}, effect = "fade", time = 200})
        end
    )
    gameOverGroup:insert(rematchButton) -- Add the rematch button to the group

    -- Create a menu button
    local menuButton =
        display.newText("Menu", display.contentCenterX + 100, display.contentHeight * 0.9, native.systemFontBold, 25)
    menuButton:setFillColor(0.847, 0.823, 0.76) -- Set the color of the menu button
    menuButton:addEventListener(
        "tap",
        function()
            C.clearMoveHistory() -- Clear move history before returning to menu
            -- Remove the game over screen elements
            gameOverGroup:removeSelf()
            -- Destroy the current scene
            composer.removeScene(currentScene) -- Ensure current scene is removed
            composer.removeScene("menu") -- Ensure menu scene is removed
            composer.removeScene("whoGoesFirst") -- Ensure the who goes first scene is removed
            -- Compose the menu scene, passing the current scene as targetScene
            composer.gotoScene("menu", {params = {targetScene = currentScene}, effect = "fade", time = 200})
        end
    )

    -- Create the replay last game button
    local replayButton =
        display.newText(
        "Replay Last Game",
        display.contentCenterX,
        display.contentHeight * 0.85,
        native.systemFontBold,
        25
    )
    replayButton:setFillColor(0.847, 0.823, 0.76) -- Set the color of the replay button
    replayButton:addEventListener(
        "tap",
        function()
            gameOverGroup:removeSelf() -- Remove game over screen
            composer.removeScene(currentScene) -- Remove the current scene
            -- Navigate to replay scene, passing start player
            composer.gotoScene("replay", {effect = "fade", time = 200, params = {startPlayer = startPlayer}})
        end
    )

    -- Add the menu and replay buttons to the game over group
    gameOverGroup:insert(menuButton)
    gameOverGroup:insert(replayButton)
end

-- Function to load game statistics from a file
function C.loadGameStats()
    local file = io.open(statsFile, "r") -- Open the statistics file for reading
    if file then
        local stats = {}
        -- Read each line of the file
        for line in file:lines() do
            local key, value = line:match("([^=]+)=(.+)") -- Match key-value pairs
            stats[key] = tonumber(value) -- Convert value to number and store in stats table
        end
        file:close() -- Close the file
        return stats -- Return the loaded statistics
    else
        -- If file doesn't exist, return default stats
        return {wins = 0, losses = 0, draws = 0}
    end
end

-- Function to save game statistics to a file
function C.saveGameStats(stats)
    local file = io.open(statsFile, "w") -- Open the statistics file for writing
    if file then
        -- Write each statistic to the file
        file:write("wins=" .. tostring(stats.wins) .. "\n")
        file:write("losses=" .. tostring(stats.losses) .. "\n")
        file:write("draws=" .. tostring(stats.draws) .. "\n")
        file:close() -- Close the file
    end
end

-- Function to update game statistics for player X based on game result
function C.updateGameStats(result)
    local stats = C.loadGameStats() -- Load current game statistics
    -- Update statistics based on the game result
    if result == "Player X Wins!" then
        stats.wins = stats.wins + 1 -- Increment wins if player X wins
    elseif result == "Computer Wins!" or result == "Player O Wins!" then
        stats.losses = stats.losses + 1 -- Increment losses if player O wins
    elseif result == "It's a draw!" then
        stats.draws = stats.draws + 1 -- Increment draws if the game is a draw
    end
    C.saveGameStats(stats) -- Save the updated statistics
end

return C -- Return the module for use in other parts of the application