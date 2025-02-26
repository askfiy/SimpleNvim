local lang_pack = {}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {},
}

lang_pack.treesitter = {
    ensure_installed = {
        "rust",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "rust_analyzer" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "rustfmt",
        extra_args = {},
        condition = function()
            return true
        end,
    },
}

lang_pack.code_runner = {
    filetypes = { "rust" },
    command = function()
        return "cargo run ."
    end,
}

return lang_pack
