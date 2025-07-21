local utils = require("utils")

return {

    handlers = {
        ["textDocument/publishDiagnostics"] = utils.lsp.filter_publish_diagnostics({
            level = {},
            message = {
                '此类型自 Python 3.10 起已弃用；请改用 "| None"',
            },
        }),
    },
    settings = {
        basedpyright = {
            analysis = {
                diagnosticSeverityOverrides = {
                    strictListInference = true,
                    strictDictionaryInference = true,
                    strictSetInference = true,
                    reportMissingTypeStubs = "none",
                    reportUnusedExpression = "none",
                    reportUnusedCoroutine = "none",
                    reportUnusedClass = "none",
                    reportUnusedImport = "none",
                    reportUnusedFunction = "none",
                    reportUnusedVariable = "none",
                    reportUnusedCallResult = "none",
                    reportCallInDefaultInitializer = "none",
                    reportDuplicateImport = "warning",
                    reportPrivateUsage = "warning",
                    reportConstantRedefinition = "error",
                    reportIncompatibleMethodOverride = "error",
                    reportMissingImports = "error",
                    reportUndefinedVariable = "error",
                    reportAssertAlwaysTrue = "error",
                    reportUnannotatedClassAttribute = "none",
                    reportAssignmentType = "none",
                    reportImportCycles = "none",
                    reportAny = "none",
                    reportDeprecated = "hint",
                    reportUnknownParameterType = "none",
                    reportExplicitAny = "none",
                    reportUnusedParameter = "none",
                },
            },
        },
    },
}
