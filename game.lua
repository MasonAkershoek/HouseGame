Game = {}

Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)
    self:setGlobals()
    return self
end

function Game:setup()
    bootManager("Starting up", .1)

    -- Canves
    --self.drawSpace = love.graphics.newCanvas(_GAME_WIDTH, _GAME_HEIGHT)
    --self.pauseSpace = love.graphics.newCanvas(_GAME_WIDTH, _GAME_HEIGHT)

    bootManager("Loading Images", .3)
    self:loadGraphics()

end