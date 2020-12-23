
local lg = love.graphics
local la = love.audio

local digits_fade = -1
local digits_width = BASE_WIDTH * 0.5
local digits_left = (BASE_WIDTH - digits_width) / 2
local digits = {}
lg.setColor(1, 1, 1)
digits[1] = lg.newText(FONTS.bigg, "2")
digits[2] = lg.newText(FONTS.bigg, "0")
digits[3] = digits[1]
digits[4] = lg.newText(FONTS.bigg, "1")

local HAPPY_NEW_YEAR = lg.newText(FONTS.smol, "HAPPY NEW YEAR!")
local hny_opacity = 0

local FIREWORK_BLANK = 100
local FIREWORK_SIZE = 100

local firework_snd_volume = 1
local FIREWORK_STAR_SND = la.newSource("data/boom.wav", "static")
local FIREWORK_LAUNCH_SND = la.newSource("data/launch.wav", "static")

local function Firework(self)
    self = self or {}
    self.x = math.random(0, BASE_WIDTH)
    self.y = 0
    self.explode = math.random(BASE_HEIGHT / 6, BASE_HEIGHT / 6 + BASE_HEIGHT * 2 / 3)
    self.stars = math.random(3, 20)
    self.has_exploded = false

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
        stars = 10,
        has_exploded = false
    }, {
        x = BASE_WIDTH * 2 / 5, 
        y = -30, 
        explode = BASE_HEIGHT / 2, 
        stars = 10,
        has_exploded = false
    }, {
        x = BASE_WIDTH * 3 / 5, 
        y = -60, 
        explode = BASE_HEIGHT / 2, 
        stars = 10,
        has_exploded = false
    }, {
        x = BASE_WIDTH * 4 / 5, 
        y = -90, 
        explode = BASE_HEIGHT / 2, 
        stars = 10,
        has_exploded = false
    }, {
        x = BASE_WIDTH * 2, 
        y = -120, 
        explode = BASE_HEIGHT / 2, 
        stars = 10,
        has_exploded = false
    }, 
}

background_fade_to(10, 0, 0, 0.1)

local function update(dt)
    -- fade out the sounds over 15 secs
    if firework_snd_volume > 0 then
        firework_snd_volume = math.max(0, firework_snd_volume - dt / 15)
        FIREWORK_LAUNCH_SND:setVolume(firework_snd_volume)
        FIREWORK_STAR_SND:setVolume(firework_snd_volume)
    end

    -- at 5 seconds past midnight, fade out "2021" and in the new year msg
    if os.time() - DATE_TARGET + DATE_OFFSET >= 5 then
        if digits_fade > 0.2 then
            digits_fade = digits_fade - dt
        end

        if hny_opacity < 1 then
            hny_opacity = math.clip(0, hny_opacity + dt, 1)
        end
    else
        -- before 5 secs
        -- fade in the letters 
        if digits_fade < 1 then
            digits_fade = math.min(1, digits_fade + dt)
        end
    end

    -- update the firework positions
    for i, firework in ipairs(fireworks) do
        if firework_gone(firework) then
            Firework(firework)
        end

        firework.y = firework.y + 150 * dt
        if firework.y > firework.explode then
            if not firework.has_exploded then
                if (FIREWORK_STAR_SND:isPlaying()) then
                    FIREWORK_STAR_SND:stop()
                end
                FIREWORK_STAR_SND:play()
            end

            firework.has_exploded = true
        end
    end
end

local function draw()
    local x = digits_left
    lg.setColor(0.8, 0.8, 1, math.clip(0, digits_fade, 1))
    for i = 1, 4, 1 do
        lg.draw(
            digits[i],
            BASE_WIDTH * i / 5,
            BASE_HEIGHT / 2,
            0,
            1, 1,
            digits[i]:getWidth() / 2,
            digits[i]:getHeight() / 2)
    end

    lg.setColor(1, 1, 1, hny_opacity)
    lg.draw(
        HAPPY_NEW_YEAR, 
        BASE_WIDTH / 2,
        BASE_HEIGHT / 2 + 3,
        0,
        1, 1,
        HAPPY_NEW_YEAR:getWidth() / 2,
        HAPPY_NEW_YEAR:getHeight() / 2)

    -- draw the fireworks
    lg.setColor(1, 1, 1)
    for i, firework in ipairs(fireworks) do
        if firework.y < firework.explode then
            lg.setColor(1, 1, 1, 1)
            lg.draw(
                FIREWORK_LAUNCH,
                firework.x,
                BASE_HEIGHT - firework.y,
                0, 1, 1,
                FIREWORK_LAUNCH:getWidth() / 2,
                FIREWORK_LAUNCH:getHeight() / 2)
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
                local opacity = 1 - (firework.y - firework.explode) / firework.explode

                lg.setColor(1, 1, 1, opacity)                
                lg.draw(
                    FIREWORK_STAR,
                    center_x + dx * distance - 8 * size / 2,
                    center_y + dy * distance - 8 * size / 2 + 10 * math.pow(size, 2),
                    firework.y / 100,
                    1, 1,
                    FIREWORK_STAR:getWidth() / 2,
                    FIREWORK_STAR:getHeight() / 2)
            end
        end
    end
end

return {
    update = update,
    draw = draw
}
