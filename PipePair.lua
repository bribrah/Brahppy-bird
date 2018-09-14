--used to reprent a pair of pipes that stick together for the player
--to jump through in order to score

PipePair = Class{}

--size of gap
local GAP_HEIGHT = 100

function PipePair:init(y)
	--initialize pipes past the end of screen
	self.x = VIRTUAL_WIDTH + 32

	--y value is for the topmost pipe
	self.y = y

	-- instantiate two pipes that belong to this pair
	self.pipes = {
		['upper'] = Pipe('top', self.y),
		['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
	}

	--whether this pipe pair is ready to be removed
	self.remove = false
end

function PipePair:update(dt)
	--remove the pipe if it goes beyond left edge of screen
	--else move it right to left
	if self.x > -PIPE_WIDTH then
		self.x = self.x - PIPE_SPEED * dt
		self.pipes['lower'].x = self.x
		self.pipes['upper'].x = self.x
	else
	end
end
function PipePair:render()
	for k, pipe in pairs(self.pipes) do
		pipe:render()
	end
end

