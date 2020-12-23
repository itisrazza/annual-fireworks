
local lg = love.graphics
local secs, secs_old = 60, 60
local secs_scale, secs_opacity = 2, 0
local secs_render, secs_render_old = nil
local partcile_fade = 1

local function update(dt)
    particle_update(dt)
    
    -- update the second counter
    secs = DATE_TARGET - os.time() + DATE_OFFSET

    -- update the texture if needed
    if secs ~= secs_old then
        secs_render_old = secs_render
        secs_old = secs
        secs_scale = 0
        secs_opacity = 0
        if secs <= 0 then
            secs_render = nil
        else
            secs_render = lg.newText(FONTS.bigg, secs)
        end
    end

    -- 0 secs
    if secs <= -1 then
        PHASE = require "phases/fireworks"
        return
    end

    -- 5 secs: fade out particles
    if secs < 5 then
        partcile_fade = partcile_fade - dt / 5
    end

    -- 10 secs: fade to black
    if secs < 10 then
        background_fade_to(10, 0, 0, 0)
    end

    -- update the scale and opacity of the scale
    secs_scale = secs_scale + dt
    secs_opacity = secs_opacity + dt
end

local function draw()
    particle_draw(partcile_fade)
    
    if secs_render_old ~= nil then
        lg.setColor(1, 1, 1, 1 - math.pow(secs_opacity, 2))
        lg.draw(secs_render_old,
            BASE_WIDTH / 2,
            BASE_HEIGHT / 2,
            0,
            math.pow(secs_scale, 3) + 1, 
            math.pow(secs_scale, 3) + 1,
            secs_render_old:getWidth() / 2,
            secs_render_old:getHeight() / 2)
    end

    if secs_render ~= nil then
        lg.setColor(1, 1, 1, math.pow(secs_opacity, 2))
        lg.draw(secs_render,
            BASE_WIDTH / 2,
            BASE_HEIGHT / 2,
            0,
            math.pow(secs_scale, 1/10), 
            math.pow(secs_scale, 1/10),
            secs_render:getWidth() / 2,
            secs_render:getHeight() / 2)
    end
end

return {
    update = update,
    draw = draw
}
