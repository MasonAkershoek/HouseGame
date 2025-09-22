Game = {}

Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)
    self:setGlobals()
    self:setup()
    return self
end

function Game:setup()
    bootManager("Starting up", .1)

    -- Canves
    self.drawSpace = love.graphics.newCanvas(_GAME_WIDTH, _GAME_HEIGHT)
    self.pauseSpace = love.graphics.newCanvas(_GAME_WIDTH, _GAME_HEIGHT)

    bootManager("Loading Images", .3)
    self:loadGraphics()

    bootManager("Done!", 1)
end

function Game:loadGraphics()
    self.PLANES = {}
    local planePath = "Assets/planes/"
    for x, folder in ipairs(love.filesystem.getDirectoryItems(planePath)) do
        self.PLANES[x] = {}
        for y, file in ipairs(love.filesystem.getDirectoryItems(planePath .. folder)) do
            self.PLANES[x][y] = love.graphics.newImage(planePath .. folder .. "/" .. file)
        end
    end
end

function Game:update(dt)
    
end

function Game:draw()
    love.graphics.draw(self.PLANES[self.CURRENT_ROOM][self.CURRENT_DIRECTION])
end


