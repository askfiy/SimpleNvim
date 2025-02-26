-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring

local pack = {}

pack.lazy = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "VeryLazy" },
}

function pack.before_load()
    pack.plugin = require("ts_context_commentstring")
end

function pack.load()
    pack.plugin.setup({
        enable_autocmd = false,
        languages = {
            vue = {
                __default = "<!-- %s -->",
                __multiline = "<!-- %s -->",
                raw_text = {
                    __default = "/* %s */",
                    __multiline = "/* %s */",
                },
            },
        },
    })
end

function pack.after_load() end

return pack
