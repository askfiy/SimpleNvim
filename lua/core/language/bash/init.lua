local lang_pack = {}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {
        "shfmt",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "bash",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "bashls" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "shfmt",
        extra_args = {},
        condition = function()
            return true
        end,
    },
}

lang_pack.code_runner = {
    filetypes = { "sh" },
    command = function()
        return ("sh %s"):format(vim.fn.expand("%:p"))
    end,
}

return lang_pack
