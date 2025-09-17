-- This function was written by localthunk and slightly modified by me
-- I plan to make more changes in the future
function bootManager(msg, progress)
    local w, h = love.window.getMode()
    love.graphics.push()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(lovecolors:getColor("SKYBLUE"))
    if progress > 0 then love.graphics.rectangle('fill', w / 2 - 150, h / 2 - 15, progress * 300, 30) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', w / 2 - 150, h / 2 - 15, 300, 30)
    love.graphics.pop()
    love.graphics.present()
    logger:log(msg, " : ", progress)
end