Bird = Class{}

local GRAVITY = 8.3
local JUMP = -2.8

function Bird:init()
	self.image = love.graphics.newImage('bird.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
	self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

	self.dy = 0
end

--AABB collision that expects a pipe, has X Y  and references globala pipe width and height
function Bird:collides(pipe)
	--contains some offsets of hitbox to make game a littttleeee easier
	--both offsets are used to shrink the bounding box to
	--give players so leeway on collision
	if (self.x ) + (self.width - 3) >= pipe.x and self.x + 4 <= pipe.x + PIPE_WIDTH then
		if (self.y ) + (self.height - 3) >= pipe.y and self.y + 4 <= pipe.y + PIPE_HEIGHT then
			return true
		end
	else
		return false
	end
end


function Bird:update(dt)
	self.dy = self.dy + GRAVITY * dt

	if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
		self.dy = JUMP
		sounds['jump']:play()
	end

	self.y = self.y + self.dy
end


function Bird:render()
	love.graphics.draw(self.image, self.x, self.y)
end
