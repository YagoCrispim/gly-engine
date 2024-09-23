local _, os = pcall(require, 'os')
local zeebo_meta = require('src/lib/cli/meta')

local function init(args)
    return false, 'not implemented!'
end

local function run(args)
    local love = 'love'
    local screen = args['screen'] and '-screen '..args.screen or ''
    local command = love..' src/engine/core/love -'..screen..' '..args.game
    if not os or not os.execute then
        return false, 'cannot can execute'
    end
    os.execute(command)
    return true
end

local function meta(args)
    arg = nil -- prevent infinite loop
    zeebo_meta.current(args.game):stdout(args.format):run()
    return true
end

local P = {
    run = run,
    meta = meta,
    init = init
}

return P
