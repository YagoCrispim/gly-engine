local os = require('os')

---@type Timeout[]
local timers = {}

---@param time_in_seconds number
---@param cb function
local function set_timeout(time_in_seconds, cb)
    local timer = os.time() + time_in_seconds
    table.insert(timers, {time = timer, cb = cb})
end

---@param pos { x: number, y: number }
---@return Alien
local function Alien(pos)
    local allow_update = false

    local update_timer
    update_timer = function()
        allow_update = true
        set_timeout(1, update_timer)
    end
    update_timer()

    --
    return {
        --
        speed = 40,
        dim = {w = 20, h = 10},
        transform = {
            pos = {
                --
                x = pos.x or 0,
                y = pos.y or 0
            }
        },

        update = function(alien)
            if not allow_update then return end

            alien.transform.pos.x = alien.transform.pos.x + alien.speed
            allow_update = false
        end,

        draw = function(alien, std, _)
            std.draw.color(std.color.white)
            std.draw.rect(0, alien.transform.pos.x, alien.transform.pos.y,
                          alien.dim.w, alien.dim.h)
        end
    }
end

---@param x number
---@param y number
---@return Vector2D
local function Vector2D(x, y)
    return {
        x = x,
        y = y,

        sum = function(self, v)
            self.x = self.x + v
            self.y = self.y + v
            return self
        end
    }
end

local function Group()end

return {
    meta = {
        title = 'SpaceInvadersTV',
        author = 'YagoCrispim',
        description = '',
        version = '1.0.0'
    },
    callbacks = {
        init = function(_, game)
            game._go = {}

            local processed = {line = 0, col = 0}
            local aliens = {col = 10, lines = 3}
            local pos = Vector2D(10, 10)
            local alien_w = 20
            local spacing = 40

            game._state = {rlimit = 10, llimit = pos.x + alien_w + aliens.col}

            while processed.line <= aliens.lines do
                while processed.col <= aliens.col do
                    table.insert(game._go, Alien(Vector2D(pos.x, pos.y)))
                    pos.x = pos.x + spacing
                    processed.col = processed.col + 1
                end

                pos = Vector2D(10, pos.y + spacing)
                processed.line = processed.line + 1
                processed.col = 0
            end
        end,

        loop = function(_, game)
            -- run completed timeout
            local now = os.time()
            for k, v in ipairs(timers) do
                if now >= v.time then
                    v.cb()
                    table.remove(timers, k)
                end
            end

            -- update game objects
            for _, v in pairs(game._go) do
                --
                v:update()
            end
        end,

        draw = function(std, game)
            std.draw.clear(std.color.black)

            -- draw game objects
            for _, v in pairs(game._go) do
                --
                v:draw(std, game)
            end
        end
    } --[[ @as SpaceInvadersTVCallbacks ]]
}

--[[ TYPES ]]
---@class SpaceInvadersTVCallbacks
---@field init fun(std: table, game: table): nil
---@field loop fun(std: table, game: table): nil
---@field draw fun(std: table, game: table): nil
---@field exit? fun(std: table, game: table): nil
--
---@class Vector2D
---@field x number
---@field y number
---@field sum fun(self: Vector2D, v: number): Vector2D
--
---@class Alien
---@field speef number
---@field dim { w: number, h: number }
---@field transform { pos: Vector2D }
---@field update fun(alien: Alien): nil
---@field draw fun(alien: Alien, std: table, game: table): nil
--
---@class Timeout
---@field time number
---@field cb { time: number, cb: function }
