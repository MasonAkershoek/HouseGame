require "math"

require "lib.logger"
require "lib.lovecolors"
require "engine.functions"
require "game"
require "globals"

function love.load()
    G = Game.new()
    love.keyboard.setKeyRepeat(false)
end

function love.keypressed(key, scancode, isrepeate)
    if key == "up" then
        G.CURRENT_ROOM = G.CURRENT_ROOM + 1
    end
    changeRoom(key)
end

function love.update(dt)

end

function love.draw()
    G:draw()
end