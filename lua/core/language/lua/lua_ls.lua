-- https://github.com/sumneko/lua-language-server

local utils = require("utils")
local util = require("lspconfig.util")

local runtime_path = vim.split(package.path, ";")

local root_files = {
    ".luarc.json",
    ".luacheckrc",
    ".stylua.toml",
    "selene.toml",
    -- custom settings
    ".git",
}

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    single_file_support = true,
    root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname)
            or vim.fs.dirname(vim.fs.find(".git", {})[1])
    end,
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
