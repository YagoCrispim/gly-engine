---@param x? number
---@param y? number
---@return Vector2D
local function Vector2D(x, y)
    return {
        x = x or 0,
        y = y or 0,

        sum = function(self, v)
            self.x = self.x + v
            self.y = self.y + v
            return self
        end,

        copy = function(self) return Vector2D(self.x, self.y) end
    }
end

---@param pos Vector2D
---@param dim Dimensions
---@return Alien
local function Alien(pos, dim)
    return {
        speed = 10,
        dim = { w = dim.w, h = dim.h },
        pos = Vector2D(pos.x, pos.y),

        update = function() end,

        draw = function(self, std, _)
            std.draw.color(std.color.white)
            std.draw.rect(0, self.pos.x, self.pos.y, self.dim.w, self.dim.h)
        end
    } --[[ @as Alien ]]
end

---@param nodes GameObject[]
---@param rows number
---@param cols number
---@param gap number
---@return table
local function Grid(nodes, rows, cols, gap)
    -- #region GridBody
    local grid = {}
    local processed = { row = 0, col = 0 }
    local item_counter = 1
    local prev_pos = Vector2D()

    local original_x = nodes[1].pos.x
    local pos = { x = nodes[1].pos.x, y = nodes[1].pos.y }

    while processed.row < rows do
        local row_objs = {}

        while processed.col < cols do
            local item = nodes[item_counter]

            if item then
                item.pos = Vector2D(pos.x, pos.y)
                pos.x = pos.x + gap
                table.insert(row_objs, item)
            end

            processed.col = processed.col + 1
            item_counter = item_counter + 1
        end

        processed.col = 0
        pos.x = original_x
        pos.y = pos.y + gap
        processed.row = processed.row + 1
        table.insert(grid, row_objs)
    end
    -- #endregion

    return {
        pos = pos,
        children = grid,

        update = function(self, std, game)
            local diffx = self.pos.x - prev_pos.x
            local diffy = self.pos.y - prev_pos.y

            prev_pos.x = self.pos.x
            prev_pos.y = self.pos.y

            for _, item in pairs(nodes) do
                if diffx ~= 0 or diffy ~= 0 then
                    item.pos.x = item.pos.x + diffx
                    item.pos.y = item.pos.y + diffy
                end
                item:update(std, game)
            end
        end,

        draw = function(_, std, game)
            for _, item in pairs(nodes) do item:draw(std, game) end
        end
    }
end

return { Grid = Grid, Vector2D = Vector2D, Alien = Alien }
-- #region Types
--
-- Types
--
---@class GridComponent : GameObject
--
---@class GameObject
---@field pos Vector2D
---@field dim Dimensions
---@field update fun(self: table, std: table, game: table): nil
---@field draw fun(self: table, std: table, game: table): nil
--
---@class Vector2D
---@field x number
---@field y number
---@field sum fun(self: Vector2D, v: number): Vector2D
---@field copy fun(self: Vector2D): Vector2D
--
---@class Dimensions
---@field w number
---@field h number
--
---@class Alien : GameObject
---@field speed number
---@field update fun(self: Alien, std: table, game: table): nil
---@field draw fun(self: Alien, std: table, game: table): nil
--
---@class AlienGroup
---@field nodes Alien[]
---@field speed number
---@field dim { w: number, h: number }
---@field transform { pos: Vector2D }
---@field limits { r: number, l: number }
---@field update fun(self: AlienGroup, game: table): nil
---@field draw fun(self: AlienGroup, std: table, game: table): nil
-- #endregion
