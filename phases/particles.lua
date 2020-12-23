
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
    self.size = 1
    self.color = { 
        1, 
        1, 
        1,
        0.6 * math.pow(-self.dy / PARTICLE_DY_MAX, 2)
    }

    return self
end

-- create all the particles
for i = 0, 1024, 1 do
    local p = Particle()
    table.insert(particles, p)
end

function particle_update(dt)
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

function particle_draw(alpha)
    local og_blend_mode = lg.getBlendMode()
    lg.setBlendMode(og_blend_mode)

    if alpha == nil then alpha = 1 end
    for i, particle in pairs(particles) do
        lg.setColor(
            particle.color[1], 
            particle.color[2], 
            particle.color[3], 
            alpha * particle.color[4])
        lg.rectangle(
            "fill",
            math.floor(particle.x), 
            math.floor(particle.y), 
            math.floor(particle.size), 
            math.floor(particle.size))
    end
end
