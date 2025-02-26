-- https://github.com/theia-ide/typescript-language-server

local utils = require("utils")
local lspconfig_util = require("lspconfig.util")

local ignore_diagnostic_message = {}

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
    handlers = {
        -- If you want to disable pyright's diagnostic prompt, open the code below
        -- ["textDocument/publishDiagnostics"] = function(...) end,
        -- If you want to disable pyright from diagnosing unused parameters, open the function below
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            utils.lsp.filter_publish_diagnostics,
            {
                ignore_diagnostic_level = {},
                ignore_diagnostic_message = ignore_diagnostic_message,
            }
        ),
    },
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
