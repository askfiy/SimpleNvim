local conf = require("conf")
local utils = require("utils")

local lang_pack = {}

lang_pack.lazy = {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "javascript", "typescript" },
    config = function()
        require("dap-vscode-js").setup({
            node = "node",
            debugpath = utils.path.join(
                conf.get_mason_install_path(),
                "packages",
                "js-debug-adapter"
            ),
            adapters = {
                "pwa-node",
                "pwa-chrome",
                "pwa-msedge",
                "node-terminal",
                "pwa-extensionHost",
            },
        })
    end,
}

lang_pack.mason = {
    ensure_installed = {
        "prettier",
        "js-debug-adapter",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "javascript",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "eslint", "ts_ls" },
}

lang_pack.code_runner = {
    filetypes = { "javascript" },
    command = function()
        return ("node %s"):format(vim.fn.expand("%:p"))
    end,
}

lang_pack.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {
        },
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
