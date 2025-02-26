-- https://github.com/stevearc/aerial.nvim

local conf = require("conf")
local utils = require("utils")

local pack = {}

pack.lazy = {
    "stevearc/aerial.nvim",
    cmd = {
        "AerialToggle",
    },
}

function pack.before_load()
    pack.plugin = require("aerial")
end

function pack.load()
    local icons = conf.get_icons_by_group("kind", false)

    pack.plugin.setup({
        icons = icons,
        show_guides = true,
        attach_mode = "global",
        update_events = "TextChanged,InsertLeave",
        on_attach = function(bufnr) end,
        layout = {
            placement = "edge",
            min_width = 30,
            max_width = { 40, 0.2 },
            win_opts = {},
        },
        lsp = {
            diagnostics_trigger_update = false,
            update_when_errors = true,
            update_delay = 300,
        },
        guides = {
            mid_item = "├─",
            last_item = "└─",
            nested_top = "│ ",
            whitespace = "  ",
        },
        filter_kind = {
            "Module",
            "Struct",
            "Interface",
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Method",
        },
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>2",
            rhs = "<cmd>AerialToggle! right<cr>",
            options = { silent = true },
            description = "Open Outline Explorer",
        },
        {
            mode = { "n" },
            lhs = "{",
            rhs = "<cmd>AerialPrev<cr>",
            options = { silent = true },
            description = "Move Preview Aerial Node",
        },
        {
            mode = { "n" },
            lhs = "}",
            rhs = "<cmd>AerialNext<cr>",
            options = { silent = true },
            description = "Move Next Aerial Node",
        },
    })
end

return pack
