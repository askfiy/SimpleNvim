-- https://github.com/luukvbaal/statuscol.nvim

local utils = require("utils")
local helper = require("core.packages.nvim-toggler.helper")

local pack = {}

pack.lazy = {
    "nguyenvukhang/nvim-toggler",
    lazy = true,
}

function pack.before_load()
    pack.plugin = require("nvim-toggler")
end

function pack.load()
    pack.plugin.setup({
        -- your own inverses
        inverses = helper.get_inverses(),
        -- removes the default <leader>i keymap
        remove_default_keybinds = true,
        -- removes the default set of inverses
        remove_default_inverses = true,
    })
end

function pack.after_load() end


function pack.register_maps()

    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "gs",
            rhs = function()
                require("nvim-toggler").toggle()
            end,
            options = { silent = true },
            description = "Switch current word",
        },
    })
end

return pack
