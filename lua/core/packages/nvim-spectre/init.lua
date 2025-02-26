-- https://github.com/nvim-pack/nvim-spectre

local utils = require("utils")

local pack = {}

pack.lazy = {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
}

function pack.before_load()
    pack.plugin = require("spectre")
end

function pack.load()
    pack.plugin.setup({
        highlight = {
            ui = "@string",
            search = "@string.regex",
            replace = "@text.emphasis",
        },
    })
end

function pack.after_load()
end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>rp",
            rhs = function()
                require("spectre").open()
            end,
            options = { silent = true },
            description = "Replace characters in all files in the current workspace",
        },
        {
            mode = { "n" },
            lhs = "<leader>rf",
            rhs = function()
                require("spectre").open_file_search()
            end,
            options = { silent = true },
            description = "Replace all characters in the current file",
        },
        {
            mode = { "n" },
            lhs = "<leader>rwf",
            rhs = function()
                require("spectre").open_visual({
                    select_word = true,
                    path = vim.fn.fnameescape(vim.fn.expand("%:p:.")),
                })
            end,
            options = { silent = true },
            description = "Replace the character under the cursor in the current file",
        },
        {
            mode = { "n" },
            lhs = "<leader>rwp",
            rhs = function()
                require("spectre").open_visual({ select_word = true })
            end,
            options = { silent = true },
            description = "Replace the character under the cursor in all files under the current workspace",
        },
    })
end

return pack
