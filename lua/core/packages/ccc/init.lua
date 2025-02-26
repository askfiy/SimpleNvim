-- https://github.com/uga-rosa/ccc.nvim

local pack = {}

pack.lazy = {
    "uga-rosa/ccc.nvim",
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("ccc")
end

function pack.load()
    pack.plugin.setup({
        highlighter = {
            auto_enable = true,
            lsp = true,
        },
    })
end

function pack.after_load()
    vim.cmd([[CccHighlighterEnable]])
end

return pack
