
local lg = love.graphics
lovesize = require("lib/lovesize")

BASE_WIDTH = 320
BASE_HEIGHT = 180
FONTS = {
    smol = nil,
    bigg = nil
}

-- Pass desired resolution (can be called again to change it)
function love.load()
    lovesize.set(BASE_WIDTH, BASE_HEIGHT)
    lg.setDefaultFilter("nearest")

    require("phases/background")
    FONTS.smol = lg.newFont("data/nokiafc22.ttf", 8)
end

-- Necessary to keep the correct values up to date
function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.update(dt)
    background_update(dt)
end

-- How to draw stuff 
function love.draw()
    -- Example how to clear the letterboxes with a white color
    love.graphics.clear(0, 0, 0)

    lovesize.begin()
    draw_background()
    
    lg.setColor(0.8, 1, 0.6)
    
    local hour = lg.newText(FONTS.smol, os.date("%I:%M %p"))
    lg.draw(hour, BASE_WIDTH / 2 - hour:getWidth() / 2, BASE_HEIGHT / 2 - hour:getHeight())
    hour:release()
    
    local date = lg.newText(FONTS.smol, os.date("%A, %B %d, %Y"))
    lg.draw(date, BASE_WIDTH / 2 - date:getWidth() / 2, BASE_HEIGHT / 2)
    date:release()

    lovesize.finish()

    -- Draw stuff using screen coords here
end

-- Example how to use "inside" and "pos" functions:
function love.mousepressed(x, y, button, istouch)
    local fs, type = love.window.getFullscreen()
    love.window.setFullscreen(not fs, 'desktop')
end

--
--
--

function math.clip(min, val, max)
    return math.max(min, math.min(val, max))
end
