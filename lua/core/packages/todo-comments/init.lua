-- https://github.com/folke/todo-comments.nvim

local utils = require("utils")

local pack = {}

pack.lazy = {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
}

function pack.before_load()
    pack.plugin = require("todo-comments")
end

function pack.load()
    pack.plugin.setup({
        signs = false,
        keywords = {
            NOTE = { color = "#98D8AA", alt = { "PASS" } },
            TODO = { color = "#1ABC9C" },
            WARN = { color = "#F7D060" },
            ERROR = { color = "#ED2B2A" },
            HACK = { color = "#F2AFEF", alt = { "DEP" } },
            FIX = { color = "#6ACAFC", alt = { "BUG" } },
        },
        highlight = { multiline = true },
        gui_style = { fg = "NONE", bg = "NONE", gui = "NONE" },
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "]t",
            rhs = function()
                require("todo-comments").jump_next()
            end,
            options = { silent = true },
            description = "Next todo comment",
        },
        {
            mode = { "n" },
            lhs = "[t",
            rhs = function()
                require("todo-comments").jump_prev()
            end,
            options = { silent = true },
            description = "Prev todo comment",
        },
        {
            mode = { "n" },
            lhs = "<leader>ft",
            rhs = function()
                require("telescope").extensions["todo-comments"].todo()
            end,
            options = { silent = true },
            description = "Find todo tag in the current workspace",
        },
    })
end

return pack
