-- https://github.com/kosayoda/nvim-lightbulb

local pack = {}

pack.lazy = {
    "kosayoda/nvim-lightbulb",
    event = { "LspAttach" },
}

function pack.before_load()
    pack.plugin = require("nvim-lightbulb")
end

function pack.load()
    pack.plugin.setup({
        autocmd = { enabled = true },
        priority = 15,
        sign = {
            enabled = true,
            text = "",
            hl = "DiagnosticSignWarn",
        },
    })
end

function pack.after_load() end

return pack
