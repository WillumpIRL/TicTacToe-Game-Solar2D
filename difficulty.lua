-- Created by William James 
--Final Product Created 4th of October 2024

-- Import Composer for scene management
local composer = require("composer")
local scene = composer.newScene()

-- Variable to store the target scene (not used here but can be extended)
local targetScene

-- Function to start the Player vs Computer game with "Easy" difficulty
local function onEasyTap()
    -- Navigate to the whoGoesFirst scene and pass "PvC" as the target scene for Easy mode
    composer.gotoScene("whoGoesFirst", {params = {targetScene = "PvC"}, effect = "fade", time = 200})
end

-- Function to start the Player vs Computer game with "Hard" difficulty
local function onHardTap()
    -- Navigate to the whoGoesFirst scene and pass "PvC_Hard" as the target scene for Hard mode
    composer.gotoScene("whoGoesFirst", {params = {targetScene = "PvC_Hard"}, effect = "fade", time = 200})
end

-- Function to handle Back button tap event
local function onBackTap()
    -- Navigate back to the menu screen
    composer.gotoScene("menu", {effect = "fade", time = 200})
end

-- Scene creation function (called when the scene is created)
function scene:create(event)
    local sceneGroup = self.view -- Group for inserting all display objects

    -- Variable to store the target scene (currently set to nil)
    local targetScene = nil

    -- Add title text at the top of the screen
    local title =
        display.newText(
        sceneGroup,
        "Select Difficulty", -- Title text
        display.contentCenterX, -- Center the text horizontally
        display.contentHeight * 0.3, -- Position the text at 30% of the screen height
        native.systemFontBold, -- Use bold system font
        40 -- Font size
    )
    title:setFillColor(1, 0.968, 0.941) -- Set the title color

    -- Easy button to select the Easy difficulty
    local easyBtn =
        display.newText(
        sceneGroup,
        "Easy", -- Button label
        display.contentCenterX, -- Center the button horizontally
        display.contentHeight * 0.5, -- Position the button at 50% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    easyBtn:setFillColor(0.847, 0.823, 0.76) -- Set button color
    easyBtn:addEventListener("tap", onEasyTap) -- Add event listener for Easy mode selection

    -- Hard button to select the Hard difficulty
    local hardBtn =
        display.newText(
        sceneGroup,
        "Hard", -- Button label
        display.contentCenterX, -- Center the button horizontally
        display.contentHeight * 0.6, -- Position the button at 60% of the screen height
        native.systemFontBold, -- Use bold system font
        30 -- Font size
    )
    hardBtn:setFillColor(0.694, 0.454, 0.341) -- Set button color
    hardBtn:addEventListener("tap", onHardTap) -- Add event listener for Hard mode selection

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
    backBtn:setFillColor(0.29, 0.286, 0.278) -- Set button color
    backBtn:addEventListener("tap", onBackTap) -- Add event listener to go back to the menu
end

-- Add event listener for scene creation
scene:addEventListener("create", scene)

-- Return the scene to be used by Composer
return scene