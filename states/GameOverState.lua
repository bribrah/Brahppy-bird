--[[Game state that the game enters when player colldies with pipe
Stops game play until player hits start button, which changes game state back
to the playstate]]

GameOverState = Class{__includes = BaseState}

function GameOverState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end
end

function GameOverState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Brahppy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press enter to start game', 0, 100, VIRTUAL_WIDTH, 'center')
end