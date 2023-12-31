local M = {}

M.lazys = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "json",
    "jsonc",
    "json5"
}

M.lspconfig = {
    server = "jsonls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        enable = true
    }
}

return M
