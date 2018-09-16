--[[countdown state to count the player down to beginning the game
so the player can et ready. transitions to play state at countdown = 0]]

CountDownState = Class{__includes = BaseState}

--takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountDownState:init()
	self.count = 3
	self.timer = 0
end


function CountDownState:update(dt)
	self.timer = self.timer + dt

	if self.timer > COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.count = self.count - 1

		if self.count == 0 then
			gStateMachine:change('play')
		end
	end
end

function CountDownState:render()
	love.graphics.setFont(hugeFont)
	love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end

