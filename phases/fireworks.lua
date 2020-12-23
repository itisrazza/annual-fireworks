
local lg = love.graphics

local digits_width = BASE_WIDTH * 0.5
local digits_left = (BASE_WIDTH - digits_width) / 2
local digits = {}
lg.setColor(1, 1, 1)
digits[1] = lg.newText(FONTS.bigg, "2")
digits[2] = lg.newText(FONTS.bigg, "0")
digits[3] = digits[1]
digits[4] = lg.newText(FONTS.bigg, "1")

local function update(dt)

end

local function draw()
    local x = digits_left
    for i = 1, 4, 1 do
        lg.draw(
            digits[i],
            digits_left + digits_width * (i - 1) / 3,
            BASE_HEIGHT / 2,
            0,
            1, 1,
            digits[i]:getWidth() / 2,
            digits[i]:getHeight() / 2)
    end
end

return {
    update = update,
    draw = draw
}
