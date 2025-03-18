local conf = require("conf")
local utils = require("utils")

utils.map.bulk_register({
    {
        mode = { "n" },
        lhs = "<leader><esc>",
        rhs = ":qa!<cr>",
        options = { silent = true },
        description = "Escape Neovim",
    },
    {
        mode = { "i" },
        lhs = "jj",
        rhs = "<esc>",
        options = { silent = true },
        description = "Escape editor insert mode",
    },
    {
        mode = { "t" },
        lhs = "<esc>",
        rhs = "<c-\\><c-n>",
        options = { silent = true },
        description = "Escape terminal insert mode",
    },
    {
        mode = { "n" },
        lhs = "<m-k>",
        rhs = function()
            local size = math.ceil(vim.api.nvim_win_get_height(0) / 10)
            vim.cmd("resize +" .. size)
        end,
        options = { silent = true },
        description = "Reduce horizontal split screen size",
    },
    {
        mode = { "n" },
        lhs = "<m-j>",
        rhs = function()
            local size = math.ceil(vim.api.nvim_win_get_height(0) / 10)
            vim.cmd("resize -" .. size)
        end,
        options = { silent = true },
        description = "Increase horizontal split screen size",
    },
    {
        mode = { "n" },
        lhs = "<m-h>",
        rhs = function()
            local size = math.ceil(vim.api.nvim_win_get_width(0) / 10)
            vim.cmd("vertical resize +" .. size)
        end,
        options = { silent = true },
        description = "Reduce vertical split screen size",
    },
    {
        mode = { "n" },
        lhs = "<m-l>",
        rhs = function()
            local size = math.ceil(vim.api.nvim_win_get_width(0) / 10)
            vim.cmd("vertical resize -" .. size)
        end,
        options = { silent = true },
        description = "Increase vertical split screen size",
    },
    {
        mode = { "i", "c", "t" },
        lhs = "<m-k>",
        rhs = "<up>",
        options = {},
        description = "Move cursor up in insert mode",
    },
    {
        mode = { "i", "c", "t" },
        lhs = "<m-j>",
        rhs = "<down>",
        options = {},
        description = "Move cursor down in insert mode",
    },
    {
        mode = { "i", "c", "t" },
        lhs = "<m-h>",
        rhs = "<left>",
        options = {},
        description = "Move cursor left in insert mode",
    },
    {
        mode = { "i", "c", "t" },
        lhs = "<m-l>",
        rhs = "<right>",
        options = {},
        description = "Move cursor right in insert mode",
    },
    {
        mode = { "i", "c", "t" },
        lhs = "<m-b>",
        rhs = "<c-left>",
        options = {},
        description = "Jump to previous word in insert mode",
    },
    {
        mode = { "i", "c", "t" },
        lhs = "<m-f>",
        rhs = "<c-right>",
        options = {},
        description = "Jump to next word in insert mode",
    },
    {
        mode = { "n" },
        lhs = "i",
        rhs = function()
            local cond = #vim.fn.getline(".") == 0
            if cond then
                return '"_cc'
            else
                return "i"
            end
        end,
        options = { expr = true },
        description = "When you press i, automatically indent to the appropriate position",
    },
    {
        mode = { "n" },
        lhs = "dd",
        rhs = function()
            if vim.api.nvim_get_current_line():match("^%s*$") then
                return '"_dd'
            else
                return "dd"
            end
        end,
        options = { expr = true },
        description = "Delete empty lines without writing to registers",
    },
    {
        mode = { "n" },
        lhs = "<c-u>",
        rhs = function()
            vim.cmd(
                "normal! "
                    .. math.ceil(vim.api.nvim_win_get_height(0) / 4)
                    .. "k"
            )
        end,
        options = { silent = true },
        description = "Move 1/4 screen up",
    },
    {
        mode = { "n" },
        lhs = "<c-d>",
        rhs = function()
            vim.cmd(
                "normal! "
                    .. math.ceil(vim.api.nvim_win_get_height(0) / 4)
                    .. "j"
            )
        end,
        options = { silent = true },
        description = "Move 1/4 screen down",
    },
    {
        mode = { "n", "x" },
        lhs = "j",
        rhs = function()
            return vim.v.count > 0 and "j" or "gj"
        end,
        options = { silent = true, expr = true },
        description = "Move down one line",
    },
    {
        mode = { "n", "x" },
        lhs = "k",
        rhs = function()
            return vim.v.count > 0 and "k" or "gk"
        end,
        options = { silent = true, expr = true },
        description = "Move up one line",
    },
    {
        mode = { "n", "x" },
        lhs = "^",
        rhs = function()
            return vim.v.count > 0 and "^" or "g^"
        end,
        options = { silent = true, expr = true },
        description = "Move to the first character at the beginning of the line",
    },
    {
        mode = { "n", "x" },
        lhs = "$",
        rhs = function()
            return vim.v.count > 0 and "$" or "g$"
        end,
        options = { silent = true, expr = true },
        description = "Move to the last character at the end of the line",
    },
    {
        mode = { "n" },
        lhs = "<leader>sl",
        rhs = function()
            vim.cmd(("source %s"):format(conf.get_session_path()))
        end,
        options = { silent = true },
        description = "Resume the session",
    },
})
