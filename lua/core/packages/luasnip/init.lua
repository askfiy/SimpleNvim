-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/rafamadriz/friendly-snippets

local conf = require("conf")
local utils = require("utils")
local language = require("core.language")

local pack = {}

pack.lazy = {
    "L3MON4D3/LuaSnip",
    dependencies = {
        { "rafamadriz/friendly-snippets" },
    },
    lazy = true,
}

function pack.before_load()
    pack.plugin = require("luasnip")
end

function pack.load()
    pack.plugin.setup({
        history = true,
        region_check_events = "InsertEnter",
        delete_check_events = "TextChanged,InsertLeave",
        update_events = "TextChanged,TextChangedI,InsertLeave",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
    })
end

function pack.after_load()
    require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
            utils.path.join(vim.fn.stdpath("config"), "snippets"),
            utils.path.join(conf.get_lazy_install_path(), "friendly-snippets"),
        },
    })

    if language.has("javascript") then
        pack.plugin.filetype_extend("javascript", { "typescript" })
    end

    if language.has("typescript") then
        pack.plugin.filetype_extend("typescript", { "javascript" })
    end

    if language.has("vue") then
        pack.plugin.filetype_extend("vue", { "javascript", "typescript" })
    end
end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "i", "s" },
            lhs = "<tab>",
            rhs = function()
                return vim.api.nvim_eval(
                    "luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<tab>'"
                )
            end,
            options = { silent = true, expr = true },
            description = "Jump to the next fragment placeholder",
        },
        {
            mode = { "i", "s" },
            lhs = "<s-tab>",
            rhs = function()
                return vim.api.nvim_eval(
                    "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<s-tab>'"
                )
            end,
            options = { silent = true, expr = true },
            description = "Jump to the prev fragment placeholder",
        },
    })
end

return pack
