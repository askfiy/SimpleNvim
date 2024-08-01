-- https://github.com/stevearc/aerial.nvim

local api = require("utils.api")

local M = {}

M.lazy = {
    "stevearc/aerial.nvim",
    cmd = {
        "AerialToggle",
    },
}

function M.init()
    M.aerial = require("aerial")
end

function M.load()
    local icons = api.get_setting().get_icon_groups("kind", false)

    M.aerial.setup({
        icons = icons,
        show_guides = true,
        attach_mode = "global",
        update_events = "TextChanged,InsertLeave",
        on_attach = function(bufnr) end,
        layout = {
            placement = "edge",
            min_width = 30,
            max_width = { 40, 0.2 },
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

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>2",
            rhs = "<cmd>AerialToggle! right<cr>",
            options = { silent = true },
            description = "Open Outilne Explorer",
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

return M
