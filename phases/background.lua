
local lg = love.graphics

local PARTICLE_DX_MAX = 5
local PARTICLE_DDX_MAX = 2
local PARTICLE_DY_MAX = 50

local particles = {}
local function Particle(self)
    self = self or {}
    
    self.x = math.random(0, BASE_WIDTH - 1)
    self.y = BASE_HEIGHT
    self.dx = math.random(-PARTICLE_DX_MAX, PARTICLE_DX_MAX)
    self.dy = math.random(-PARTICLE_DY_MAX, 0)
    self.ddx = math.random(-PARTICLE_DDX_MAX, PARTICLE_DDX_MAX)
    self.size = math.floor(1, 3 - self.dx)
    self.color = { 1 * math.random(), 0.2 * math.random(), 0.2 * math.random() }

    return self
end

for i = 0, 512, 1 do
    local p = Particle()
    table.insert(particles, p)
end

function background_update(dt)
    for i, particle in pairs(particles) do
        particle.x = particle.x + dt * particle.dx
        particle.y = particle.y + dt * particle.dy
        particle.dx = math.clip(-PARTICLE_DX_MAX, particle.dx + dt * particle.ddx, PARTICLE_DX_MAX)
        particle.dy = particle.dy - (dt * particle.dy * 0.00001)
        particle.ddx = math.clip(-PARTICLE_DDX_MAX, particle.ddx + dt * math.random(-100, 100), PARTICLE_DDX_MAX)

        if particle.x < 0 or particle.x >= BASE_WIDTH
            or particle.y < 0
        then
            Particle(particle)
        end
    end
end

function draw_background()
    lg.clear(0.1, 0, 0)

    for i, particle in pairs(particles) do
        lg.setColor(particle.color)
        lg.rectangle("fill", 
            math.floor(particle.x), 
            math.floor(particle.y), 
            math.floor(particle.size), 
            math.floor(particle.size))
    end
end
