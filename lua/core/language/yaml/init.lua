local lang_pack = {}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {
        "prettier",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "yaml",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "yamlls" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        condition = function()
            return true
        end,
        runtime_condition = function()
            return vim.tbl_contains({ "yaml" }, vim.opt.filetype:get())
        end,
    },
}

return lang_pack
