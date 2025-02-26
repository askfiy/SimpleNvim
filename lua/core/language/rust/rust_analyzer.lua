-- https://github.com/rust-lang/rust-analyzer

local util = require("lspconfig.util")

local root_files = {
    "Cargo.toml",
    ".git",
}

return {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = util.root_pattern(unpack(root_files)),
    settings = {
        ["rust-analyzer"] = {
            allFeatures = true,
        },
    },
}
