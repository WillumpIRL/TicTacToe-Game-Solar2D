-- Created by William James 
--Final Product Created 4th of October 2024

-- Import Composer for scene management
local composer = require("composer")
local scene = composer.newScene()
local C = require("commonFunctions") -- Import common functions module

-- Function to select who goes first and navigate to the appropriate scene
local function onPlayerSelected(startPlayer, targetScene)
    -- Check if targetScene is valid (non-nil)
    if targetScene then
        -- Transition to the target scene with parameters (startPlayer and targetScene)
        composer.gotoScene(
            targetScene,
            {params = {startPlayer = startPlayer, targetScene = targetScene}, effect = "fade", time = 200}
        )
    end
end

-- Function to handle the Back button tap event
local function onBackTap()
    -- Navigate back to the menu screen
    composer.gotoScene("menu", {effect = "fade", time = 200})
end

-- Scene creation function (called when the scene is created)
function scene:create(event)
    local sceneGroup = self.view -- Group for inserting all display objects

    -- Retrieve parameters passed to the scene (e.g., target scene)
    local params = event.params or {}
    local targetScene = params.targetScene or "None" -- Default to "None" if no scene is passed

    -- Title text for choosing the player who goes first
    local title =
        display.newText(
        sceneGroup,
        "Player X Goes:", -- Display the title indicating the first player
        display.contentCenterX, -- Center the text horizontally
        display.contentHeight * 0.3, -- Position the text at 30% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    title:setFillColor(1, 0.968, 0.941) -- Set the color of the text

    -- Button for selecting Player X to go first
    local playerXButton =
        display.newText(
        sceneGroup,
        "First", -- Button label
        display.contentCenterX, -- Center the button horizontally
        display.contentHeight * 0.4, -- Position the button at 40% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    playerXButton:setFillColor(0.847, 0.823, 0.76) -- Set the button color
    playerXButton:addEventListener(
        "tap",
        function()
            onPlayerSelected(C.X, targetScene) -- Player X selected, move to target scene
        end
    )

    -- Button for selecting Player O to go second
    local playerOButton =
        display.newText(
        sceneGroup,
        "Second", -- Button label
        display.contentCenterX, -- Center the button horizontally
        display.contentHeight * 0.5, -- Position the button at 50% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    playerOButton:setFillColor(0.694, 0.454, 0.341) -- Set the button color
    playerOButton:addEventListener(
        "tap",
        function()
            onPlayerSelected(C.O, targetScene) -- Player O selected, move to target scene
        end
    )

    -- Back button to return to the menu
    local backBtn =
        display.newText(
        sceneGroup,
        "Back", -- Button label
        display.contentCenterX, -- Center the button horizontally
        display.contentHeight * 0.8, -- Position the button at 80% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    backBtn:setFillColor(0.29, 0.286, 0.278) -- Set the button color
    backBtn:addEventListener("tap", onBackTap) -- Add event listener to go back to the menu
end

-- Add event listener for scene creation
scene:addEventListener("create", scene)

-- Return the scene to be used by Composer
return scene