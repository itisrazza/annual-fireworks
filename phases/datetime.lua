
local lg = love.graphics

local function update(dt)
    particle_update(dt)
    
    if DATE_TARGET - os.time() < 60 then
        background_fade_to(5, 0, 0, 0.1)
        PHASE = require "phases/countdown"
    end
end

local function draw()
    -- draw the particles
    particle_draw()
    
    --
    -- draw the date and time
    --

    lg.setColor(1, 1, 1)
    
    local hour = lg.newText(FONTS.smol, os.date("%I:%M %p"))
    lg.draw(hour, BASE_WIDTH / 2 - hour:getWidth() / 2, BASE_HEIGHT / 2 - hour:getHeight())
    hour:release()
    
    local date = lg.newText(FONTS.smol, os.date("%A, %B %d, %Y"))
    lg.draw(date, BASE_WIDTH / 2 - date:getWidth() / 2, BASE_HEIGHT / 2)
    date:release()
end

return {
    update = update,
    draw = draw
}
