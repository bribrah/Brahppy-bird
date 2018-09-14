--My version of flappy bird made using love2D
push = require "push"

Class = require "class"

require "Bird"

require "Pipe"

require "PipePair"


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--loading in the backgorund and ground image files
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipePairs = {}

--spawn timer for spawning pipes
local spawnTimer = 0

--initialize last recorded Y value for gap placement to base other gaps on
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle("brahppy bird")

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	vsync = true,
	fullscreen = false,
	resizable = true

})
		math.randomseed(os.time())
		love.keyboard.keysPressed = {}
end

function love.resize(w, h)
	push:resize(w, h)
	-- body
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
	if key == 'escape' then
		love.event.quit()
	end 
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.update(dt)
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		% BACKGROUND_LOOPING_POINT

	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
		% VIRTUAL_WIDTH

	--spawns a new PipePair if timer goes is past 2 seconds
	spawnTimer = spawnTimer + dt
		if spawnTimer > 2 then
			--[[
			modify last Y coord we placed so pipe gaps arent too far apart
			no higher than 10 pixels below the top edge of the screen
			and lower than a gap length of 90pixels from the bottom\
			--]]
			local y = math.max(-PIPE_HEIGHT + 10)
				math.min(lastY + math.random(20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)
			lastY = y

			table.insert(pipePairs, PipePair(y))
			spawnTimer = 0
	end

	--update bird for input and gravity
	bird:update(dt)

	--for every pipe in the scene...
	for k, pipe in pairs(pipePairs) do
		pipe:update(dt)
	end
		--remove and flagged pipes
		--need second loop rather than deleting in the previous loop because
		--modifting the table in-place without explicit keys will result in
		--skipping the next pipe, since all impicit keys (numerical indices) are
		--automatically down after a table removal
	for k, pipe in pairs(pipePairs) do
		if pipe.remove then
			table.remove(pipePairs, k)
		end
	end

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()
	love.graphics.draw(background, -backgroundScroll, 0)

	for k, pair in pairs(pipePairs) do
		pair:render()
	end

	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	bird:render()

	
	push:finish()
end
