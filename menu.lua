-- Created by William James 10578252
-- On Campus Joondalup ECU
-- Professor Mike Johnstone
-- Due Date Due Friday 4th of October 2024 14:00

-- Import Composer for scene management
local composer = require("composer")
local scene = composer.newScene()

-- Function to start the Player vs Player game
local function startPvP()
    -- Transition to the "whoGoesFirst" scene to determine which player starts
    composer.gotoScene(
        "whoGoesFirst",
        {
            params = {
                targetScene = "PvP" -- Specify the target scene as Player vs Player
            },
            effect = "fade", -- Fade transition effect
            time = 200 -- Duration of the transition in milliseconds
        }
    )
end

-- Function to start the Player vs Computer game, navigating to a difficulty selection screen
local function startPvC()
    -- Transition to the "difficulty" scene to choose game difficulty
    composer.gotoScene(
        "difficulty",
        {
            params = {
                targetScene = targetScene -- The scene that will be loaded after difficulty selection
            },
            effect = "fade", -- Fade transition effect
            time = 200 -- Duration of the transition in milliseconds
        }
    )
end

-- Function to navigate to the game statistics scene
local function startStats()
    -- Transition to the "stats" scene to view game statistics (wins/losses/draws)
    composer.gotoScene(
        "stats",
        {
            effect = "fade", -- Fade transition effect
            time = 200 -- Duration of the transition in milliseconds
        }
    )
end

-- Scene creation function (called when the scene is created)
function scene:create(event)
    local sceneGroup = self.view -- Group to which all display objects will be inserted

    -- Retrieve any parameters passed to the scene
    local params = event.params or {}
    local targetScene = params.targetScene -- Get the target scene (optional)

    -- Add the menu background image
    local menuBackground =
        display.newImageRect(sceneGroup, "titlebackground.png", display.contentWidth, display.contentHeight)
    menuBackground.x = display.contentCenterX -- Center the background horizontally
    menuBackground.y = display.contentCenterY -- Center the background vertically
    menuBackground:toFront() -- Ensure the background is in front of other objects

    -- Create and position the Player vs Player button
    local pvpBtn =
        display.newText(
        sceneGroup,
        "Player vs Player",
        display.contentCenterX,
        display.contentHeight * 0.4,
        native.systemFontBold,
        30
    )
    pvpBtn:setFillColor(1, 0.968, 0.941) -- Set the button text color
    pvpBtn:addEventListener("tap", startPvP) -- Add a tap event to start the PvP game

    -- Create and position the Player vs Computer button
    local pvcBtn =
        display.newText(
        sceneGroup,
        "Player vs Computer",
        display.contentCenterX,
        display.contentHeight * 0.5,
        native.systemFontBold,
        30
    )
    pvcBtn:setFillColor(0.847, 0.823, 0.76) -- Set the button text color
    pvcBtn:addEventListener("tap", startPvC) -- Add a tap event to start the PvC game

    -- Create and position a new button to navigate to the statistics screen
    local statsButton =
        display.newText(
        "Game Statistics",
        display.contentCenterX,
        display.contentHeight * 0.6,
        native.systemFontBold,
        30
    )
    statsButton:setFillColor(0.694, 0.454, 0.341) -- Set the button text color
    sceneGroup:insert(statsButton) -- Add the button to the scene group
    statsButton:addEventListener("tap", startStats) -- Add a tap event to view game statistics
end

-- Add the create event listener to the scene
scene:addEventListener("create", scene)

-- Return the scene to be used by Composer
return scene