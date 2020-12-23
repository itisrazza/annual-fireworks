
local lg = love.graphics
local la = love.audio

local digits_width = BASE_WIDTH * 0.5
local digits_left = (BASE_WIDTH - digits_width) / 2
local digits = {}
lg.setColor(1, 1, 1)
digits[1] = lg.newText(FONTS.bigg, "2")
digits[2] = lg.newText(FONTS.bigg, "0")
digits[3] = digits[1]
digits[4] = lg.newText(FONTS.bigg, "1")

local FIREWORK_BLANK = 100
local FIREWORK_SIZE = 100
local FIREWORK_STAR_SND = la.newSource("data/boom.wav", "static")
local FIREWORK_LAUNCH_SND = la.newSource("data/launch.wav", "static")

local function Firework(self)
    self = self or {}
    self.x = math.random(0, BASE_WIDTH)
    self.y = 0
    self.explode = math.random(BASE_HEIGHT / 6, BASE_HEIGHT / 6 + BASE_HEIGHT * 2 / 3)
    self.stars = math.random(3, 20)

    if (FIREWORK_LAUNCH_SND:isPlaying()) then
        FIREWORK_LAUNCH_SND:stop()
    end
    FIREWORK_LAUNCH_SND:play()
end

local function firework_gone(self)
    return self.y >= self.explode + FIREWORK_SIZE + FIREWORK_BLANK
end

lg.setColor(1, 1, 1)
local FIREWORK_STAR = lg.newImage("data/fw_star.png")
local FIREWORK_LAUNCH = lg.newImage("data/fw_launch.png")
local fireworks = {
    {
        x = BASE_WIDTH * 1 / 5, 
        y = 0, 
        explode = BASE_HEIGHT / 2, 
        stars = 10
    }, {
        x = BASE_WIDTH * 2 / 5, 
        y = -30, 
        explode = BASE_HEIGHT / 2, 
        stars = 10
    }, {
        x = BASE_WIDTH * 3 / 5, 
        y = -60, 
        explode = BASE_HEIGHT / 2, 
        stars = 10
    }, {
        x = BASE_WIDTH * 4 / 5, 
        y = -90, 
        explode = BASE_HEIGHT / 2, 
        stars = 10
    }, {
        x = BASE_WIDTH * 2, 
        y = -120, 
        explode = BASE_HEIGHT / 2, 
        stars = 10
    }, 
}

local function update(dt)
    for i, firework in ipairs(fireworks) do
        if firework_gone(firework) then
            Firework(firework)
        end

        firework.y = firework.y + 100 * dt
    end
end

local function draw()
    -- local x = digits_left
    -- for i = 1, 4, 1 do
    --     lg.draw(
    --         digits[i],
    --         digits_left + digits_width * (i - 1) / 3,
    --         BASE_HEIGHT / 2,
    --         0,
    --         1, 1,
    --         digits[i]:getWidth() / 2,
    --         digits[i]:getHeight() / 2)
    -- end

    -- draw the fireworks
    lg.setColor(1, 1, 1)
    for i, firework in ipairs(fireworks) do
        if firework.y < firework.explode then
            lg.draw(
                FIREWORK_LAUNCH,
                firework.x,
                BASE_HEIGHT - firework.y)
        elseif firework.y >= firework.explode then
            local center_x = firework.x
            local distance = firework.y - firework.explode
            local center_y = BASE_HEIGHT - firework.explode
            local gone_pt  = firework.explode + FIREWORK_SIZE + FIREWORK_BLANK
            local size = 1 - (firework.y - firework.explode) / FIREWORK_SIZE

            for i = 0, 360 - 1, 360 / firework.stars do
                local rad = i * math.pi / 180
                local dx = math.cos(rad)
                local dy = math.sin(rad)

                lg.draw(
                    FIREWORK_STAR,
                    center_x + dx * distance - 8 * size / 2,
                    center_y + dy * distance - 8 * size / 2)
            end
        end
    end
end

return {
    update = update,
    draw = draw
}
