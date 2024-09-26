-- https://github.com/numToStr/Comment.nvim

local M = {}

M.lazy = {
    "numToStr/Comment.nvim",
    dependencies = {
        { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    event = { "VeryLazy" },
}

function M.init()
    M.comment = require("Comment")
    M.comment_ft = require("Comment.ft")
    M.ts_context_commentstring_integrations_comment_nvim =
        require("ts_context_commentstring.integrations.comment_nvim")
end

function M.load()
    M.comment.setup({
        opleader = {
            line = "gc",
            block = "gb",
        },
        toggler = {
            line = "gcc",
            block = "gcb",
        },
        extra = {
            above = "gck",
            below = "gcj",
            eol = "gca",
        },
        pre_hook = M.ts_context_commentstring_integrations_comment_nvim.create_pre_hook(),
    })
end

function M.after()
    M.comment_ft({ "less", "sass" }, M.comment_ft.get("css"))
end

return M
