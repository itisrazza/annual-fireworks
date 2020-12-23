
local lg = love.graphics
local la = love.audio

local function update(dt)
end

local function draw()
    local font = FONTS.smol
    local y, h = 0, font:getHeight()

    local date = os.date("*t", DATE_TARGET)
    
    lg.clear(1, 1, 1)
    lg.setColor(0, 0, 0)
    lg.setFont(font)
    lg.print("NYE Countdown 2021 | Calibration Menu", 0, y)
    lg.print("os.time() = " .. os.time(), 0, y + 2 * h)
    lg.print("   + DATE_OFFSET = " .. os.time() + DATE_OFFSET, 0, y + 3 * h)

    lg.print("DATE_TARGET = " .. DATE_TARGET .. " (UP/DOWN to change)", 0, y + 5 * h)
    lg.print("   " .. os.date("%Y-%m-%d %H:%M:%S", DATE_TARGET), 0, y + 6 * h)
    
    lg.print("DATE_OFFSET = " .. DATE_OFFSET .. " (LEFT/RIGHT to change)", 0, y + 8 * h)

end

love.keyboard.setKeyRepeat(true)
function love.keypressed(key, scancode, is_repeat)
    if scancode == "left" then
        DATE_OFFSET = DATE_OFFSET - 1
    end

    if scancode == "right" then
        DATE_OFFSET = DATE_OFFSET + 1
    end

    if scancode == "up" then
        DATE_TARGET = DATE_TARGET + 1
    end

    if scancode == "down" then
        DATE_TARGET = DATE_TARGET - 1
    end
end

return {
    update = update,
    draw = draw
}
