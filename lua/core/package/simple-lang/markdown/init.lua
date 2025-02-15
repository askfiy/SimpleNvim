local M = {}

M.lazys = {
    {
        "iamcco/markdown-preview.nvim",
        cmd = {
            "MarkdownPreviewToggle",
            "MarkdownPreview",
            "MarkdownPreviewStop",
        },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
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
