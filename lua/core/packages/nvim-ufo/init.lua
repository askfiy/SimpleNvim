-- https://github.com/kevinhwang91/nvim-ufo

local pack = {}
local utils = require("utils")
local helper = require("core.packages.nvim-ufo.helper")

pack.lazy = {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    event = { "VeryLazy" },
}

function pack.before_load()
    pack.plugin = require("ufo")
end

function pack.load()
    local foldmethod_by_filetype = {
        default = { "lsp", "indent" },
        markdown = { "treesitter", "indent" },
    }

    pack.plugin.setup({
        open_fold_hl_timeout = 0,
        close_fold_kinds = {},
        provider_selector = function(bufnr, filetype, buftype)
            if
                vim.tbl_contains(vim.tbl_keys(foldmethod_by_filetype), filetype)
            then
                return foldmethod_by_filetype[filetype]
            end
            return foldmethod_by_filetype["default"]
        end,

        fold_virt_text_handler = helper.text_handler,
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "zR",
            rhs = function()
                require("ufo").openAllFolds()
            end,
            options = { silent = true },
            descriptions = "Open all folds",
        },
        {
            mode = { "n" },
            lhs = "zM",
            rhs = function()
                require("ufo").closeAllFolds()
            end,
            options = { silent = true },
            descriptions = "Close all folds",
        },
        {
            mode = { "n" },
            lhs = "zr",
            rhs = function()
                require("ufo").openFoldsExceptKinds()
            end,
            options = { silent = true },
            descriptions = "Fold less",
        },
        {
            mode = { "n" },
            lhs = "zm",
            rhs = function()
                require("ufo").closeFoldsWith()
            end,
            options = { silent = true },
            descriptions = "Fold more",
        },
    })
end

return pack
