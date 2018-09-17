--[[
state used to display player score before they go to play state
Transitioned to from from PlayState upon collision]]

ScoreState = Class{__includes = BaseState}

local bronze = love.graphics.newImage('bronze.png')
local poop = love.graphics.newImage('poop.png')
local silver = love.graphics.newImage('silver.png')
local gold = love.graphics.newImage('gold.png')

function ScoreState:enter(params)
	self.score = params.score
end
function ScoreState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('countdown')
	end
end

function ScoreState:render()

	love.graphics.setFont(flappyFont)
	love.graphics.printf('Game Over!', 0, 30, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Score: ' .. tostring(self.score), 0, 60, VIRTUAL_WIDTH, 'center')

	love.graphics.printf('Press enter to Play Again!', 0, 250, VIRTUAL_WIDTH, 'center')

	if self.score < 5 then
		love.graphics.printf('Your Shit!', 0, 85, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(poop, VIRTUAL_WIDTH/2 - 64, 110)
	end

	if self.score >= 5 and self.score < 10 then
		love.graphics.printf('Bronze!', 0, 85, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(bronze, VIRTUAL_WIDTH/2 - 64, 115)
	end

	if self.score >= 10 and self.score < 15 then
		love.graphics.printf('Silver!', 0, 85, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(silver, VIRTUAL_WIDTH/2 - 64, 115)
	end

	if self.score >= 15 then
		love.graphics.printf('Gold! God damn you have patience', 0, 85, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(gold, VIRTUAL_WIDTH/2 - 64, 115)
	end



end



