-- https://github.com/vuejs/vetur/tree/master/server

local util = require("lspconfig.util")

return {
    cmd = { "vls" },
    filetypes = { "vue" },
    init_options = {
        config = {
            vetur = {
                -- ignore: Vetur can't find `tsconfig.json` or `jsconfig.json`
                -- js = {
                --     implicitProjectConfig = { checkJs = true },
                -- },
                -- ts = {
                --     implicitProjectConfig = { checkJs = true },
                -- },

                ignoreProjectWarning = true,
                completion = {
                    autoImport = true,
                    tagCasing = "kebab",
                    useScaffoldSnippets = true,
                },
                useWorkspaceDependencies = true,
                validation = {
                    script = true,
                    style = true,
                    template = true,
                },
            },
        },
    },
}
