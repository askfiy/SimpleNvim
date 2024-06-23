-- https://github.com/folke/which-key.nvim

local M = {}

M.lazy = {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
}

function M.init()
    M.which_key = require("which-key")
end

function M.load()
    M.which_key.setup({
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 20,
            },
        },
        icons = {
            breadcrumb = " ",
            separator = " ",
            group = " ",
        },
    })
end

function M.after()
    M.which_key.register({
        b = { name = "Buffers" },
        c = { name = "Code" },
        d = { name = "Debug" },
        f = { name = "Find" },
        g = { name = "Git" },
        l = { name = "Lazy" },
        r = { name = "Replace", w = "Replace Word To ..." },
        u = { name = "Upload" },
        t = {
            name = "Terminal | Translate",
            c = "Translate English to Chinese",
            e = "Translate Chinese to English",
        },
    }, { prefix = "<leader>", mode = "n" })
end

return M
