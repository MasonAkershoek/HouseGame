
function love.load()
    backgroundimage = love.graphics.newImage("house.png")
    pixelshader = love.graphics.newShader("shaders/pixelate.glsl")
    pixelation = 0.0
    maxPixelSize = 32
end

function love.update(dt)
    -- Increase pixelation over time (0 -> 1)
    pixelation = math.min(pixelation + dt * 0.5, 1.0)

    pixelshader:send("pixelation", pixelation)
    pixelshader:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    pixelshader:send("maxPixelSize", maxPixelSize)
end

function love.draw()
    love.graphics.setShader(pixelshader 
)
    love.graphics.draw(backgroundimage, 0,0)
    love.graphics.setShader()
end