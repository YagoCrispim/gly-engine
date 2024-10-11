---@type Timeout[]
local timers = {}

---@type SetTimeout
local function set_timeout(time_in_seconds, cb)
    local timer = os.time() + time_in_seconds
    table.insert(timers, {time = timer, cb = cb})
end

return {set_timeout = set_timeout, timers = timers}

--
-- Types
--
---@class Timeout
---@field time number
---@field cb { time: number, cb: function }
--
---@alias SetTimeout fun(time_in_seconds: number, cb: function): nil
