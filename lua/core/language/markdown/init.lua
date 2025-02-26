local lang_pack = {}

lang_pack.lazy = {
    --[[You may need to manually install and run the dependencies, just check the github homepage]]
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
    --[[Requires picgo file configuration]]
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

lang_pack.mason = {
    ensure_installed = {
        "prettier",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "markdown",
        "markdown_inline",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "tailwindcss" },
}

lang_pack.code_runner = {
    filetypes = { "markdown" },
    command = function()
        return ":MarkdownPreview"
    end,
}

lang_pack.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        condition = function()
            return true
        end,
        runtime_condition = function()
            return vim.tbl_contains(
                lang_pack.code_runner.filetypes,
                vim.opt.filetype:get()
            )
        end,
    },
}

return lang_pack
