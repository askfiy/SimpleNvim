local api = require("utils.api")

local M = {}

M.lazys = {
    {
        "mxsdev/nvim-dap-vscode-js",
        ft = { "javascript", "typescript" },
        config = function()
            require("dap-vscode-js").setup({
                node = "node",
                debugpath = api.path.join(
                    api.get_setting().get_mason_install_path(),
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
    },
}

M.mason = {
    "prettier",
    "js-debug-adapter",
}

M.treesitter = {
    "javascript",
    "typescript",
}

M.lspconfig = {
    server = "ts_ls",
    config = api.path.generate_relative_path("./ts_ls"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {
            "--tab-width 4",
            "--use-tabs",
        },
        enable = true,
    },
}

M.code_runner = {
    filetype = { "javascript", "typescript" },
    command = function()
        local buffer_filetype = vim.opt.filetype:get()
        if "javascript" == buffer_filetype then
            return ("node %s"):format(vim.fn.expand("%:p"))
        end
        if "typescript" == buffer_filetype then
            return ("ts-node %s"):format(vim.fn.expand("%:p"))
        end
    end,
}

return M
