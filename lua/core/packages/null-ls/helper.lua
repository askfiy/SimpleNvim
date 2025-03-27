local cspell = require("core.packages.null-ls.cspell")
local extras = require("core.packages.null-ls.extras")

local helper = {}

function helper.load()
    extras.expand_builtins()
    helper.register_maps()

    --
    return {
        cspell.load(),
    }
end

function helper.register_maps()
    cspell.register_maps()
end

return helper
