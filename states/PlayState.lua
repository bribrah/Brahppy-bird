--[[play state. State that the game enters that starts motion and gameplay.
When player collides game state should change to game over state ]]

PlayState = Class{__includes = BaseState}
--speed at which pipe scrolls right to left
PIPE_SPEED = 80

--height/width of pipe, globally accessible, values taken from image
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

--height/width of Bird sprite
BIRD_HEIGHT = 24
BIRD_WIDTH = 38

local spawnTimer = 0


function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0

	--initialize last recorded Y value for gap placement to base other gaps on
	self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end
function PlayState:update(dt)
	--spawns a new PipePair if timer goes is past 2 seconds
		self.timer = self.timer + dt
		if self.timer > 2 then
			--[[
			modify last Y coord we placed so pipe gaps arent too far apart
			no higher than 10 pixels below the top edge of the screen
			and lower than a gap length of 90pixels from the bottom\
			--]]
			local y = math.max(-PIPE_HEIGHT + 10,
				math.min(self.lastY + math.random(-30, 30), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
			self.lastY = y

			table.insert(self.pipePairs, PipePair(y))
			self.timer = 0
		end

	--update bird for input and gravity
	self.bird:update(dt)

	--for every pipe in the scene...
	for k, pair in pairs(self.pipePairs) do
		pair:update(dt)

		for l, pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				--pause game to show collision happened
				gStateMachine:change('gameover')
			end
		end
		if pair.x < -PIPE_WIDTH then
			pair.remove = true
		end
	end
	if self.bird.y > VIRTUAL_HEIGHT - 15 then
		gStateMachine:change('gameover')
	end
		--remove and flagged pipes
		--need second loop rather than deleting in the previous loop because
		--modifting the table in-place without explicit keys will result in
		--skipping the next pipe, since all impicit keys (numerical indices) are
		--automatically down after a table removal
	for k, pipe in pairs(self.pipePairs) do
		if pipe.remove then
			table.remove(self.pipePairs, k)
		end
	end

	self.bird:update(dt)


end
function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    self.bird:render()
end