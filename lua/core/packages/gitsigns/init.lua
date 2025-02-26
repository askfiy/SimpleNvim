-- https://github.com/lewis6991/gitsigns.nvim

local conf = require("conf")
local utils = require("utils")

local pack = {}

pack.lazy = {
    "lewis6991/gitsigns.nvim",
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("gitsigns")
end

function pack.load()
    pack.plugin.setup({
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        on_attach = function(bufnr) end,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 100,
            ignore_whitespace = false,
        },
        preview_config = {
            border = conf.get_float_border("rounded"),
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>gl",
            rhs = "<cmd>Gitsigns toggle_current_line_blame<cr>",
            options = { silent = true },
            description = "Toggle current line blame",
        },
        {
            mode = { "n" },
            lhs = "<leader>gh",
            rhs = "<cmd>lua require'gitsigns'.preview_hunk()<cr>",
            options = { silent = true },
            description = "Preview current hunk",
        },
        {
            mode = { "n" },
            lhs = "<leader>gH",
            rhs = "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>",
            options = { silent = true },
            description = "Show current block blame",
        },
        {
            mode = { "n" },
            lhs = "<leader>gd",
            rhs = "<cmd>Gitsigns diffthis<cr>",
            options = { silent = true },
            description = "Open deff view",
        },
        {
            mode = { "n" },
            lhs = "<leader>gD",
            rhs = "<cmd>Gitsigns toggle_deleted<cr>",
            options = { silent = true },
            description = "Show deleted lines",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>gr",
            rhs = "<cmd>Gitsigns reset_hunk<cr>",
            options = { silent = true },
            description = "Reset current hunk",
        },
        {
            mode = { "n" },
            lhs = "<leader>gR",
            rhs = "<cmd>Gitsigns reset_buffer<cr>",
            options = { silent = true },
            description = "Reset current buffer",
        },
        {
            mode = { "n" },
            lhs = "[c",
            rhs = function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    pack.plugin.prev_hunk()
                end)
                return "<Ignore>"
            end,
            options = { silent = true, expr = true },
            description = "Jump to the prev hunk",
        },
        {
            mode = { "n" },
            lhs = "]c",
            rhs = function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    pack.plugin.next_hunk()
                end)
                return "<Ignore>"
            end,
            options = { silent = true, expr = true },
            description = "Jump to the next hunk",
        },
    })
end

return pack
