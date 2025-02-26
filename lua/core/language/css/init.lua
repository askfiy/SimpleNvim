local lang_pack = {}

-- npm install -g browser-sync
lang_pack.lazy = {
    {
        "askfiy/neovim-easy-less",
        ft = { "less" },
        config = function()
            require("easy-less").setup()
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
        "css",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "cssls" },
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
                { "css", "less", "sass" },
                vim.opt.filetype:get()
            )
        end,
    },
}

return lang_pack
