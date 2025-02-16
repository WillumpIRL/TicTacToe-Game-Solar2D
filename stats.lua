-- Created by William James 
--Final Product Created 4th of October 2024

-- Import the Composer library to manage scenes
local composer = require("composer")
local scene = composer.newScene()
local C = require("commonFunctions") -- Import common functions (used for loading/saving stats)

-- Function to create the scene
function scene:create()
    local sceneGroup = self.view -- Scene group to insert display objects

    -- Load game statistics using the common function
    local stats = C.loadGameStats()

    -- Create and display the title text
    local titleText =
        display.newText(
        "Player X Game Statistics", -- Title text
        display.contentCenterX, -- Center horizontally
        display.contentHeight * 0.1, -- Position at 10% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    titleText:setFillColor(1, 0.843, 0) -- Set text color (gold-like color)
    sceneGroup:insert(titleText) -- Insert title into the scene group

    -- Create and display the game statistics text
    local statsText =
        display.newText(
        "Wins: " ..
            tostring(stats.wins) .. "\nLosses: " .. tostring(stats.losses) .. "\nDraws: " .. tostring(stats.draws),
        display.contentCenterX, -- Center horizontally
        display.contentHeight * 0.4, -- Position at 40% of the screen height
        native.systemFontBold, -- Use bold system font
        35 -- Font size
    )
    statsText:setFillColor(1, 1, 1) -- Set text color to white
    sceneGroup:insert(statsText) -- Insert stats text into the scene group

    -- Create and display the "Return to Menu" button
    local returnButton =
        display.newText(
        "Return to Menu", -- Button label
        display.contentCenterX, -- Center horizontally
        display.contentHeight * 0.7, -- Position at 70% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    returnButton:setFillColor(0.694, 0.454, 0.341) -- Set button color (brownish)
    sceneGroup:insert(returnButton) -- Insert return button into the scene group

    -- Add event listener to the return button to go back to the menu
    returnButton:addEventListener(
        "tap",
        function()
            composer.removeScene("menu") -- Remove the menu scene to refresh when returning
            composer.removeScene("stats") -- Remove the stats scene
            composer.gotoScene("menu", {effect = "fade", time = 200}) -- Navigate back to the menu
        end
    )

    -- Create and display the "Reset Stats" button
    local resetButton =
        display.newText(
        "Reset Stats", -- Button label
        display.contentCenterX, -- Center horizontally
        display.contentHeight * 0.6, -- Position at 60% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    resetButton:setFillColor(1, 0, 0) -- Set button color to red
    sceneGroup:insert(resetButton) -- Insert reset button into the scene group

    -- Add event listener to the reset button to reset game statistics
    resetButton:addEventListener(
        "tap",
        function()
            -- Reset stats to zero
            stats.wins = 0
            stats.losses = 0
            stats.draws = 0

            -- Save the reset statistics using the common function
            C.saveGameStats(stats)

            -- Update the stats text to reflect the reset stats
            statsText.text =
                "Wins: " ..
                tostring(stats.wins) .. "\nLosses: " .. tostring(stats.losses) .. "\nDraws: " .. tostring(stats.draws)
        end
    )
end

-- Add event listener for scene creation
scene:addEventListener("create", scene)

-- Return the scene
return scene