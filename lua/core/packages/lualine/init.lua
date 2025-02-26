-- https://github.com/nvim-lualine/lualine.nvim

local conf = require("conf")

local pack = {}

pack.lazy = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("lualine")
end

function pack.load()
    local sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    }

    table.insert(sections.lualine_c, 2, {
        "spell",
        fmt = function(content, context)
            return ("Spell: %s"):format(
                conf.code_spell_is_open() and "Y" or "N"
            )
        end,
    })

    pack.plugin.setup({
        options = {
            theme = conf.get_colorscheme(),
            icons_enabled = true,
            disabled_filetypes = {},
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 100,
                winbar = 100,
            },
        },
        sections = sections,
    })
end

function pack.after_load() end

return pack
