
local lg = love.graphics

local current_color = { 0, 0, 0 }
local target_color = current_color

-- update the background
function background_update(dt)
    for i = 1, 3 do
        local min, max = current_color[i], target_color[i]
        local delta = max - min
        current_color[i] = min + dt * (delta / 2)
    end
end

function draw_background()
    lg.clear(current_color)
end

function background_fade_to(delta_factor, color_r, color_g, color_b)
    if type(color_r) == "number" then
        color_r = { color_r, color_g, color_b }
    end
    target_color = color_r
end
