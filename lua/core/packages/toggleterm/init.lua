-- https://github.com/akinsho/toggleterm.nvim

local utils = require("utils")
local helper = require("core.packages.toggleterm.helper")

local pack = {}

pack.lazy = {
    "akinsho/toggleterm.nvim",
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("toggleterm")
end

function pack.load()
    helper.load()

    pack.plugin.setup({
        start_in_insert = false,
        shade_terminals = true,
        shading_factor = 1,
        on_open = helper.on_open,
        highlights = {
            Normal = {
                link = "Normal",
            },
            NormalFloat = {
                link = "NormalFloat",
            },
            FloatBorder = {
                link = "FloatBorder",
            },
        },
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>cr",
            rhs = "<cmd>CodeRunner<cr>",
            options = { silent = true },
            description = "Code running in terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tf",
            rhs = helper.switch_float_term,
            options = { silent = true },
            description = "Toggle float terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tt",
            rhs = helper.switch_bottom_term,
            options = { silent = true },
            description = "Toggle bottom terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tg",
            rhs = helper.switch_lazy_term,
            options = { silent = true },
            description = "Toggle lazygit terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>ta",
            rhs = helper.switch_all_term,
            options = { silent = true },
            description = "Toggle all terminal",
        },
    })
end

return pack
