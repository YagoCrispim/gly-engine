local os = require('os')

local c = require('examples.space_invaders.components')
local t = require('examples.space_invaders.timers')

-- #region Components
local Alien = c.Alien
local Vector2D = c.Vector2D
local Grid = c.Grid
-- #endregion

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

            local aliens = {}
            for _ = 1, 12 do
                table.insert(aliens, Alien(Vector2D(10, 10), {w = 10, h = 10}))
            end
            local aliens_grid = Grid(aliens, 4, 4, 40)

            local function move()
                aliens_grid.pos.x = aliens_grid.pos.x + 10
                t.set_timeout(1, function()
                    aliens_grid.pos.x = aliens_grid.pos.x + 10
                    move()
                end)
            end
            move()

            table.insert(game._go, aliens_grid)
        end,

        loop = function(_, game)
            -- run completed timeout
            local now = os.time()
            for k, v in ipairs(t.timers) do
                if now >= v.time then
                    v.cb()
                    table.remove(t.timers, k)
                end
            end

            -- update game objects
            for _, v in pairs(game._go) do
                --
                v:update(game)
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
