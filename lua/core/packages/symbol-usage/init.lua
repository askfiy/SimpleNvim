-- https://github.com/Wansmer/symbol-usage.nvim

local pack = {}

pack.lazy = {
    "Wansmer/symbol-usage.nvim",
    dependencies = {
        { "neovim/nvim-lspconfig" },
    },
    event = "LspAttach",
}

function pack.before_load()
    pack.plugin = require("symbol-usage")
end

function pack.load()
    pack.plugin.setup({
        hl = { link = "DiagnosticUnnecessary" },
        -- 'above'|'end_of_line'|'textwidth'
        vt_position = "end_of_line",
        disable = { filetypes = { "vue" } },
    })
end

function pack.after_load() end

return pack
