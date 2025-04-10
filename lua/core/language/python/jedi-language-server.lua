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
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    root_dir = lspconfig_util.root_pattern(unpack(root_files)),
    single_file_support = true,

    settings = {
        initializationOptions = {
            diagnostics = {
                eanble = true,
            },
            hover = {
                enable = false,
            },
        },
    },
}
