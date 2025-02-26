local conf = require("conf")

local pack = {}

pack.lazy = {
    "askfiy/killer-queen",
    priority = 80,
    cond = conf.is_enable_colorscheme("killer-queen"),
}

function pack.before_load()
    pack.plugin = require("killer-queen")
end

function pack.load()
    pack.plugin.setup({
        is_border = conf.is_float_border(),
        transparent = false,
    })

    vim.cmd([[colorscheme killer-queen]])
end

function pack.after_load() end

return pack
