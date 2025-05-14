-- https://github.com/sumneko/lua-language-server

local runtime_path = vim.split(package.path, ";")

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    single_file_support = true,
    handlers = {},
    log_level = 2,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
            hover = {
                previewFields = vim.o.lines * 4,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
            },
        },
    },
}
