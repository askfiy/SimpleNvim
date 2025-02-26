local lang_pack = {}

-- npm install -g browser-sync
lang_pack.lazy = {
    {

        "ray-x/web-tools.nvim",
        cmd = {
            "BrowserSync",
            "BrowserOpen",
            "BrowserPreview",
            "BrowserRestart",
        },
        config = function()
            require("web-tools").setup()
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
        "html",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "html", "emmet_ls" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        condition = function()
            return true
        end,
        runtime_condition = function()
            return vim.tbl_contains({ "html" }, vim.opt.filetype:get())
        end,
    },
}

lang_pack.code_runner = {
    filetypes = { "html" },
    command = function()
        return ":BrowserPreview"
    end,
}

return lang_pack
