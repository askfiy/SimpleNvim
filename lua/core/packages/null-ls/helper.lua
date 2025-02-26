local cspell = require("core.packages.null-ls.cspell")

local helper = {}

function helper.load()
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
