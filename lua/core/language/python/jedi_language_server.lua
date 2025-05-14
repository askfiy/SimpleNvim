return {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    single_file_support = true,
    settings = {
        initializationOptions = {
            diagnostics = {
                enable = false,
            },
            hover = {
                enable = false,
            },
        },
    },
}
