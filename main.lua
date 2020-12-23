
local lg = love.graphics
lovesize = require("lib/lovesize")

DATE_TARGET = 1609412400
-- DATE_TARGET = os.time() + 70

BASE_WIDTH = 320
BASE_HEIGHT = 180
FONTS = {
    smol = nil,
    bigg = nil
}

PHASE = nil

-- Pass desired resolution (can be called again to change it)
function love.load()
    lovesize.set(BASE_WIDTH, BASE_HEIGHT)
    lg.setDefaultFilter("nearest")

    require("phases/background")
    require("phases/particles")
    FONTS.smol = lg.newFont("data/nokiafc22.ttf", 8)
    FONTS.bigg = lg.newFont("data/IBMPlexSerif-Bold.ttf", 64)
    FONTS.bigg = lg.newFont("data/IBMPlexSerif-Bold.ttf", 48)

    background_fade_to(0.5, 0.1, 0, 0)
    PHASE = require "phases/datetime"
end

-- Necessary to keep the correct values up to date
function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.update(dt)
    background_update(dt)
    PHASE.update(dt)
end

-- How to draw stuff 
function love.draw()
    -- Example how to clear the letterboxes with a white color
    -- love.graphics.clear(0, 0, 0)

    lovesize.begin()

    draw_background()
    PHASE.draw()

    lovesize.finish()

    -- Draw stuff using screen coords here
end

-- Example how to use "inside" and "pos" functions:
function love.mousepressed(x, y, button, istouch)
    local fs = love.window.getFullscreen()
    love.window.setFullscreen(not fs, 'desktop')
end

--
--
--

function math.clip(min, val, max) return math.max(min, math.min(val, max)) end
function math.round(val)
    if math.fmod(val, 1) >= 0.5 then
        return math.ceil(val)
    else
        return math.floor(val)
    end
end
