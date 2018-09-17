--My version of flappy bird made using love2D
push = require "push"

Class = require "class"

require "Bird"

require "Pipe"

require "PipePair"

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/GameOverState'
require 'states/ScoreState'
require 'states/CountDownState'



WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--loading in the backgorund and ground image files
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 40
local GROUND_SCROLL_SPEED = 80

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipePairs = {}

--spawn timer for spawning pipes
local spawnTimer = 0

--way to pause the scrolling activity
local scrolling = true

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle("brahppy bird")

	--initializing fonts
	smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	vsync = true,
	fullscreen = false,
	resizable = true

})
	--Iinitialize all sounds
	sounds = {
	['jump'] = love.audio.newSource('jump.wav', 'static'),
	['explosion'] = love.audio.newSource('explosion.wav', 'static'),
	['hurt'] = love.audio.newSource('hurt.wav', 'static'),
	['score'] = love.audio.newSource('score.wav', 'static'),
	['music'] = love.audio.newSource('music.mp3', 'static')
}
	sounds['music']:setLooping(true)
	sounds['music']:play()
	--initialize state machine
	gStateMachine = StateMachine{
	['gameover'] = function() return GameOverState() end,
	['play'] = function() return PlayState() end,
	['score'] = function() return ScoreState() end,
	['countdown'] = function() return CountDownState() end
}
	--start state at title screen
	gStateMachine:change('gameover')

	math.randomseed(os.time())
	love.keyboard.keysPressed = {}
	love.mouse.buttonsPressed = {}
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

function love.mousepressed(x, y, button) 
	love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
end

function love.update(dt)
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
	% BACKGROUND_LOOPING_POINT

	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
	% VIRTUAL_WIDTH
	
	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}
	love.mouse.buttonsPressed = {}
end

function love.draw()
	push:start()
	love.graphics.draw(background, -backgroundScroll, 0)
	gStateMachine:render()
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	push:finish()
end