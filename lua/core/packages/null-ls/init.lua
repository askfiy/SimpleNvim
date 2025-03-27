-- https://github.com/nvimtools/none-ls.nvim

local conf = require("conf")
local language = require("core.language")
local helper = require("core.packages.null-ls.helper")

local pack = {}

pack.lazy = {
    "nvimtools/none-ls.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "neovim/nvim-lspconfig" },
    },
}

function pack.before_load()
    pack.plugin = require("null-ls")
end

function pack.load()
    local null_sources = helper.load()

    for _, source_conf in ipairs(language.get_null_ls()) do
        local null_pack =
            pack.plugin.builtins[source_conf.type][source_conf.exe]

        if not null_pack then
            vim.print(source_conf.exe)
        else
            null_pack = null_pack.with(source_conf)
            table.insert(null_sources, null_pack)
        end
    end

    pack.plugin.setup({
        border = conf.get_float_border("double"),
        sources = null_sources,
    })
end

function pack.after_load() end

return pack
