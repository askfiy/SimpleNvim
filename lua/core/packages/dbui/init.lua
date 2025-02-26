-- https://github.com/kristijanhusak/vim-dadbod-ui
-- https://github.com/tpope/vim-dadbod

local conf = require("conf")
local utils = require("utils")

local pack = {}

pack.lazy = {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod" },
    },
    cmd = { "DBUIToggle" },
}

function pack.before_load() end

function pack.load()
    vim.g.db_ui_winwidth = 40
    vim.g.db_ui_win_position = "right"

    vim.g.db_ui_auto_execute_table_helpers = true
    vim.g.db_ui_execute_on_save = false
    vim.g.db_ui_show_database_icon = true


    vim.g.dbs = conf.get_database()
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>3",
            rhs = "<cmd>DBUIToggle<cr>",
            options = { silent = true },
            description = "Open Database Explorer",
        },
    })
end

return pack
