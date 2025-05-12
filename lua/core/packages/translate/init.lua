-- https://github.com/askfiy/smart-translate.nvim

local utils = require("utils")

local pack = {}

pack.lazy = {
    "askfiy/smart-translate.nvim",
    cmd = { "Translate" },
    dependencies = {
        "askfiy/http.nvim", -- a wrapper implementation of the Python aiohttp library that uses CURL to send requests.
    },
}

function pack.before_load()
    pack.plugin = require("smart-translate")
end

function pack.load()
    pack.plugin.setup()
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n", "v" },
            lhs = "<leader>tcs",
            rhs = ":Translate --target=zh-CN --source=en --handle=split<cr>",
            options = { silent = true },
            description = "Translatelate English to Chinese and open in split window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tcr",
            rhs = ":Translate --target=zh-CN --source=en --handle=replace<cr>",
            options = { silent = true },
            description = "Translatelate English to Chinese and replace English",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tcf",
            rhs = ":Translate --target=zh-CN --source=en --handle=float<cr>",
            options = { silent = true },
            description = "Translatelate English to Chinese and open in float window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tcc",
            rhs = ":Translate --target=zh-CN --source=en --handle=register<cr>",
            options = { silent = true },
            description = "Translatelate English to Chinese and copy result to clipboard",
        },
        {
            mode = { "n" },
            lhs = "<leader>tcb",
            rhs = ":Translate --target=zh-CN --source=en --handle=float --comment<cr>",
            options = { silent = true },
            description = "Translatelate English comment to Chinese and open in float window",
        },
        {
            mode = { "n" },
            lhs = "<leader>tcw",
            rhs = ":normal! m'viw<cr>:Translate --target=zh-CN --source=en --handle=float<cr>`'",
            options = { silent = true },
            description = "Translatelate English word to Chinese and open in float window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>ter",
            rhs = ":Translate --target=en --source=zh-CN --handle=replace<cr>",
            options = { silent = true },
            description = "Translatelate Chinese to English and replace Chinese",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tes",
            rhs = ":Translate --target=en --source=zh-CN --handle=split<cr>",
            options = { silent = true },
            description = "Translatelate Chinese to English and open in split window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tef",
            rhs = ":Translate --target=en --source=zh-CN --handle=float<cr>",
            options = { silent = true },
            description = "Translatelate Chinese to English and open in float window",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>tec",
            rhs = ":Translate --target=en --source=zh-CN --handle=register<cr>",
            options = { silent = true },
            description = "Translatelate Chinese to English and copy result to clipboard",
        },
        {
            mode = { "n" },
            lhs = "<leader>teb",
            rhs = ":Translate --target=en --source=zh-CN --handle=float --comment<cr>",
            options = { silent = true },
            description = "Translatelate Chinese comment to English and open in float window",
        },
        {
            mode = { "n" },
            lhs = "<leader>tew",
            rhs = ":normal! m'viw<cr>:Translate --target=en --source=zh-CN --handle=float<cr>`'",
            options = { silent = true },
            description = "Translatelate Chinese word to English and open in float window",
        },
    })
end

return pack
