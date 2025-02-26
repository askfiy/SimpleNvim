-- https://github.com/vuejs/vetur/tree/master/server

local util = require("lspconfig.util")

local root_files = {
    "tsconfig.json",
    "package.json",
    "jsconfig.json",
    ".git",
    -- custom
    "vite.config.js",
}

return {
    cmd = { "vls" },
    filetypes = { "vue" },
    root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname) or vim.fn.getcwd()
    end,
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
