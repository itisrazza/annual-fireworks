
local lg = love.graphics
lovesize = require("lib/lovesize")

DATE_TARGET = 1609412400    -- fancy computer number for jan 1 2021 (nzdt)
-- DATE_TARGET = os.time() + 70

-- time offset for streaming
DATE_OFFSET = 0

-- gfx
BASE_WIDTH = 320
BASE_HEIGHT = 180
FONTS = {
    smol = nil,
    bigg = nil
}

-- the current phase to call upon
PHASE = nil
local in_calibration = false

-- init
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

-- update the size thing
function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.update(dt)
    background_update(dt)
    PHASE.update(dt)
end

-- How to draw stuff 
function love.draw()
    lovesize.begin()

    -- draw the background and current phase
    draw_background()
    PHASE.draw()

    lovesize.finish()
end

-- click handler (left click = full screen, right click = calibration)
function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        local fs = love.window.getFullscreen()
        love.window.setFullscreen(not fs, 'desktop')
    elseif button == 2 then
        if not in_calibration then
            in_calibration = true
            PHASE = require "phases/calibration"
        else
            in_calibration = false
            PHASE = require "phases/datetime"
        end
    end
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
