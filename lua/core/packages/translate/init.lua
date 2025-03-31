-- https://github.com/uga-rosa/translate.nvim

local utils = require("utils")

local pack = {}

pack.lazy = {
    "uga-rosa/translate.nvim",
    cmd = { "Translate" },
}

function pack.before_load()
    pack.plugin = require("translate")
end

function pack.load()
    pack.plugin.setup({
        default = {
            command = "translate_shell",
            output = "floating",
            parse_before = "no_handle",
            -- parse_after = "bing",
        },
        preset = {
            command = {
                translate_shell = {
                    -- args = { "-e", "bing" },
                    args = { "-x", "127.0.0.1:7890" },
                },
            },
        },
        parse_after = {
            -- bing = {
            --     cmd = function(lines)
            --         -- Fold multiple rows into one
            --         lines = vim.fn.join(lines, "\n")
            --         -- Replace \\n to \n
            --         ---@diagnostic disable-next-line: need-check-nil
            --         lines = lines:gsub("\\n", "\n")
            --         lines = lines:gsub("\\t", "\n")
            --         -- Split into tables by \n
            --         return vim.tbl_filter(function(line)
            --             return line ~= ""
            --         end, vim.fn.split(lines, "\n"))
            --     end,
            -- },
        },
        replace_symbols = {
            google = {},
            deepl_pro = {},
            deepl_free = {},
            translate_shell = {},
        },
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n", "v" },
            lhs = "<leader>tcs",
            rhs = ":Translate ZH -source=EN -output=split<cr>",
            options = { silent = true },
            description = "Translate English to Chinese and open in split window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tcr",
            rhs = ":Translate ZH -source=EN -output=replace<cr>",
            options = { silent = true },
            description = "Translate English to Chinese and replace English",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tcf",
            rhs = ":Translate ZH -source=EN -output=floating<cr>",
            options = { silent = true },
            description = "Translate English to Chinese and open in float window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tci",
            rhs = ":Translate ZH -source=EN -output=insert<cr>",
            options = { silent = true },
            description = "Translate English to Chinese and insert to next line",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tcc",
            rhs = ":Translate ZH -source=EN -output=register<cr>",
            options = { silent = true },
            description = "Translate English to Chinese and copy result to clipboard",
        },
        {
            mode = { "n" },
            lhs = "<leader>tcb",
            rhs = ":Translate ZH -source=EN -output=floating -comment<cr>",
            options = { silent = true },
            description = "Translate English comment to Chinese and open in float window",
        },
        {
            mode = { "n" },
            lhs = "<leader>tcw",
            rhs = ":normal! m'viw<cr>:Translate ZH -source=EN -output=floating<cr>`'",
            options = { silent = true },
            description = "Translate English word to Chinese and open in float window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tes",
            rhs = ":Translate EN -source=ZH -output=split<cr>",
            options = { silent = true },
            description = "Translate Chinese to English and open in split window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>ter",
            rhs = ":Translate EN -source=ZH -output=replace<cr>",
            options = { silent = true },
            description = "Translate Chinese to English and replace Chinese",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tef",
            rhs = ":Translate EN -source=ZH -output=floating<cr>",
            options = { silent = true },
            description = "Translate Chinese to English and open in float window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tei",
            rhs = ":Translate EN -source=ZH -output=insert<cr>",
            options = { silent = true },
            description = "Translate Chinese to English and insert to next line",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tec",
            rhs = ":Translate EN -source=ZH -output=register<cr>",
            options = { silent = true },
            description = "Translate Chinese to English and copy result to clipboard",
        },
        {
            mode = { "n" },
            lhs = "<leader>teb",
            rhs = ":Translate EN -source=ZH -output=floating -comment<cr>",
            options = { silent = true },
            description = "Translate Chinese comment to English and open in float window",
        },
        {
            mode = { "n" },
            lhs = "<leader>tew",
            rhs = ":normal! m'viw<cr>:Translate EN -source=ZH -output=floating<cr>`'",
            options = { silent = true },
            description = "Translate Chinese word to English and open in float window",
        },
    })
end

return pack
