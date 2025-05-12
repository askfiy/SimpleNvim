-- https://github.com/askfiy/lsp-extra-dim.nvim

local pack = {}

pack.lazy = {
    "askfiy/lsp_extra_dim",
    event = { "LspAttach" },
}

function pack.before_load()
    pack.plugin = require("lsp_extra_dim")
end

function pack.load()
    pack.plugin.setup()
end

function pack.after_load() end

return pack
