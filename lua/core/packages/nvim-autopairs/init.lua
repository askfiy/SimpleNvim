-- https://github.com/windwp/nvim-autopairs

local pack = {}

pack.lazy = {
    "windwp/nvim-autopairs",
}

function pack.before_load()
    pack.plugin = require("nvim-autopairs")
end

function pack.load()
    pack.plugin.setup()
end

function pack.after_load() end

return pack
