-- Created by William James 10578252
-- On Campus Joondalup ECU
-- Professor Mike Johnstone
-- Due Date Due Friday 4th of October 2024 14:00

-- Import Composer for scene management
local composer = require("composer")

-- Initialize the global board variable as nil, which will later hold the game board state
board = nil

-- Hide the device's status bar for a full-screen experience
display.setStatusBar(display.HiddenStatusBar)

-- Create and display the background image, adjusting its size to fit the screen
local background = display.newImageRect("background.png", display.contentWidth, display.contentHeight)
background.x = display.contentCenterX -- Position the background at the center of the screen (X-axis)
background.y = display.contentCenterY -- Position the background at the center of the screen (Y-axis)

-- Ensure the background is rendered behind other display objects
background:toBack()

-- Navigate to the "menu" scene using Composer to start the game
composer.gotoScene("menu")
