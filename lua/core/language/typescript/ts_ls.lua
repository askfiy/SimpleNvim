-- https://github.com/theia-ide/typescript-language-server

local lspconfig_util = require("lspconfig.util")

local root_files = {
    "index.js",
    "tsconfig.json",
    "package.json",
    "jsconfig.json",
    ".git",
}

return {
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = function(fname)
        return lspconfig_util.root_pattern(unpack(root_files))(fname)
            or vim.fn.getcwd()
    end,
    init_options = {
        hostInfo = "neovim",
        -- locale = "zh-CN", -- Set the language to Chinese (Simplified)
    },
    handlers = {},
    settings = {
        -- implicitProjectConfiguration = {
        --     checkJs = true,
        -- },
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
}
