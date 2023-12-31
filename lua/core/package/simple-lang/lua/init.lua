local api = require("utils.api")

local M = {}

M.lazys = {
    {
        "folke/neodev.nvim",
        priority = 80,
    },
}

M.mason = {
    "stylua",
}

M.treesitter = {
    "lua",
    "luadoc",
}

M.lspconfig = {
    server = "lua_ls",
    config = api.path.generate_relative_path("./lua_ls"),
}

M.dapconfig = {
    config = {},
}

M.null_ls = {
    formatting = {
        exe = "stylua",
        extra_args = {
            "--indent-type=Spaces",
            "--indent-width=4",
            "--column-width=80",
        },
        enable = true,
    },
}

M.code_runner = {
    filetype = { "lua" },
    command = function()
        return ("lua %s"):format(vim.fn.expand("%:p"))
    end,
}

return M
