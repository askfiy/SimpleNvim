-- https://github.com/RRethy/vim-illuminate

local utils = require("utils")

local conf = require("conf")

local pack = {}

pack.lazy = {
    "RRethy/vim-illuminate",
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("illuminate")
end

function pack.load()
    pack.plugin.configure({
        delay = 100,
        under_cursor = true,
        modes_denylist = { "i" },
        providers = {
            --[[ "lsp", ]]
            "regex",
            "treesitter",
        },
        filetypes_denylist = utils.special_filetypes(),
    })
end

function pack.after_load() end

return pack
