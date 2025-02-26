local lang_pack = {}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {
        "prettier",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "json",
        "jsonc",
        "json5",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "jsonls" },
}

lang_pack.code_runner = {
    filetypes = { "json", "json5", "jsonc" },
    command = function()
        return ("lua %s"):format(vim.fn.expand("%:p"))
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
