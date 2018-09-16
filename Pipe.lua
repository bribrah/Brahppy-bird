Pipe = Class{}

--image of pipe
local PIPE_IMAGE = love.graphics.newImage("pipe.png")


function Pipe:init(orientation, y)
	self.x = VIRTUAL_WIDTH
	self.y = y

	self.width = PIPE_WIDTH
	self.height = PIPE_HEIGHT

	self.orientation = orientation
end
function Pipe:update(dt)
end

function Pipe:render()
	love.graphics.draw(PIPE_IMAGE, self.x, 
		(self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
		0, -- roatation
		1, -- x scale
		self.orientation == 'top' and -1 or 1) --y scale

end
 