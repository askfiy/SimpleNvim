local M = {}

M.lazys = {
    {
        "davidgranstrom/nvim-markdown-preview",
        ft = { "markdown" },
        config = function()
            --  github
            --  solarized-light
            --  solarized-dark
            vim.g.nvim_markdown_preview_theme = "solarized-light"
            vim.g.nvim_markdown_preview_format = "markdown"
        end,
    },
    {
        "askfiy/nvim-picgo",
        ft = { "markdown" },
        config = function()
            require("nvim-picgo").setup()
            ---
            vim.keymap.set(
                { "n" },
                "<leader>uc",
                "<cmd>lua require('nvim-picgo').upload_clipboard()<cr>",
                { silent = true, desc = "Upload image from clipboard" }
            )
            vim.keymap.set(
                { "n" },
                "<leader>uf",
                "<cmd>lua require('nvim-picgo').upload_imagefile()<cr>",
                { silent = true, desc = "Upload image from disk file" }
            )
        end,
    },
}

M.mason = {
    "prettier",
}

M.treesitter = {
    "markdown",
    "markdown_inline",
}

M.lspconfig = {
    server = "tailwindcss",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        enable = true,
    },
}

return M
