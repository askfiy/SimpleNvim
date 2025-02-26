local lang_pack = {}

lang_pack.lazy = {
    {
        "folke/neodev.nvim",
        priority = 80,
    },
}

lang_pack.mason = {
    ensure_installed = {
        "stylua",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "lua",
        "luadoc",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "lua_ls" },
}

lang_pack.code_runner = {
    filetypes = { "lua" },
    command = function()
        return ("lua %s"):format(vim.fn.expand("%:p"))
    end,
}

lang_pack.null_ls = {
    formatting = {
        exe = "stylua",
        extra_args = {
            "--indent-type=Spaces",
            "--indent-width=4",
            "--column-width=80",
        },
        condition = function()
            return true
        end,
        -- runtime_condition = function()
        --     return true
        -- end,
    },
}

return lang_pack
