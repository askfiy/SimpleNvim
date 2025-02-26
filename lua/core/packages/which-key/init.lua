-- https://github.com/folke/which-key.nvim

local pack = {}

pack.lazy = {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "echasnovski/mini.icons",
    },
}

function pack.before_load()
    pack.plugin = require("which-key")
end

function pack.load()
    pack.plugin.setup({
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
        spec = {
            { "<leader>b", group = "Buffers" },
            { "<leader>c", group = "Code" },
            { "<leader>d", group = "Debug" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>l", group = "Lazy" },
            { "<leader>r", group = "Replace" },
            { "<leader>u", group = "Upload" },
            {
                "<leader>rw",
                desc = "Replace Word To ...",
                prefix = "",
            },
            { "<leader>t", group = "Terminal | Translate" },
            {
                "<leader>tc",
                desc = "Translate English to Chinese",
                prefix = "",
            },
            {
                "<leader>te",
                desc = "Translate Chinese to English",
                prefix = "",
            },
            {
                "gc",
                desc = "Toggle comment",
            },
            {
                "gcc",
                desc = "Toggle comment line",
            },
        },
    })
end

function pack.after_load() end

return pack
