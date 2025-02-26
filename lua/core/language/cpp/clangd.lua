-- https://github.com/clangd/clangd

local util = require("lspconfig.util")

local root_files = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac", -- AutoTools
    -- customize
    ".git",
}

return {
    single_file_support = true,
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname)
            or vim.fs.dirname(vim.fs.find(".git", {})[1])
    end,
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = "utf-8",
    },
}
