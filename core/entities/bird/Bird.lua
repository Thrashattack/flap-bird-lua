--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local function center_xy (xy)
    return xy / 2 - 8
end

function Bird:init()
    self.image = love.graphics.newImage('assets/bird.png')
    self.x = center_xy(Config.defaults.VIRTUAL_WIDTH)
    self.y = center_xy(Config.defaults.VIRTUAL_HEIGHT)

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = Config.level.DY
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + Config.level.LEFT_TOP_OFFSET_TOLLERANCE) +
        (self.width - Config.level.RIGHT_BOTTOM_OFFSET_TOLLERANCE) >= pipe.x and self.x + Config.level.LEFT_TOP_OFFSET_TOLLERANCE <= pipe.x + Config.pipe.PIPE_WIDTH then
            if (self.y + Config.level.LEFT_TOP_OFFSET_TOLLERANCE) +
                (self.height - Config.level.RIGHT_BOTTOM_OFFSET_TOLLERANCE) >= pipe.y and self.y + Config.level.LEFT_TOP_OFFSET_TOLLERANCE <= pipe.y + Config.pipe.PIPE_HEIGHT then
                    return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + Config.level.GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = Config.bird.BIRD_JUMP_RATIO
        Sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end