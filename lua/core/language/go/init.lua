local lang_pack = {
    enable = false
}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {
        "delve",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "go",
        "gomod",
        "gosum",
        "gowork",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "gopls" },
}

lang_pack.code_runner = {
    filetypes = { "go" },
    command = function()
        return "go run ."
    end,
}

lang_pack.null_ls = {
    formatting = {
        exe = "gofmt",
        extra_args = {},
        condition = function()
            return true
        end,
    },
}

return lang_pack
