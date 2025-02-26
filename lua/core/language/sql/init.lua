local lang_pack = {}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {
        "sql-formatter",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "sql",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "sqlls" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "sql_formatter",
        extra_args = {
            "-l=mysql",
        },
        condition = function()
            return true
        end,
    },
}

return lang_pack
