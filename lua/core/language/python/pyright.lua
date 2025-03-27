local utils = require("utils")
local lspconfig_util = require("lspconfig.util")

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
    -- customize
    "main.py",
}

return {
    filetypes = { "python" },
    single_file_support = true,
    cmd = { "pyright-langserver", "--stdio" },
    root_dir = lspconfig_util.root_pattern(unpack(root_files)),
    handlers = {
        ["textDocument/publishDiagnostics"] = utils.lsp.filter_publish_diagnostics({
            level={},
            message={},
        }),
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            buffer = bufnr,
            callback = function()
                client.notify(
                    "workspace/didChangeConfiguration",
                    { settings = client.config.settings }
                )
            end,
        })
    end,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic", -- off, basic, strict
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly", -- workspace
                -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
                diagnosticSeverityOverrides = {
                    strictListInference = true,
                    strictDictionaryInference = true,
                    strictSetInference = true,
                    reportUnusedExpression = "none",
                    reportUnusedCoroutine = "none",
                    reportUnusedClass = "none",
                    reportUnusedImport = "none",
                    reportUnusedFunction = "none",
                    reportUnusedVariable = "none",
                    reportUnusedCallResult = "none",
                    reportDuplicateImport = "warning",
                    reportPrivateUsage = "warning",
                    reportConstantRedefinition = "error",
                    reportIncompatibleMethodOverride = "error",
                    reportMissingImports = "error",
                    reportUndefinedVariable = "error",
                    reportAssertAlwaysTrue = "error",
                },
            },
        },
    },
}
}
