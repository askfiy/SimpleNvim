-- https://github.com/rust-lang/rust-analyzer

return {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = {
            allFeatures = true,
        },
    },
}
