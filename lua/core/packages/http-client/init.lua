-- https://github.com/askfiy/http-client

local utils = require("utils")

local pack = {}

pack.lazy = {
    "askfiy/http-client.nvim",
}

function pack.before_load()
    pack.plugin = require("http-client")
end

function pack.load()
    pack.plugin.setup()
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>hs",
            rhs = "<cmd>HttpClient sendRequest<cr>",
            options = { silent = true },
            description = "Send Request by cursor",
        },
        {
            mode = { "n" },
            lhs = "<leader>hl",
            rhs = "<cmd>HttpClient lastRequest<cr>",
            options = { silent = true },
            description = "Send last Request",
        },
        {
            mode = { "n" },
            lhs = "<leader>hr",
            rhs = "<cmd>HttpClient lastRequest<cr>",
            options = { silent = true },
            description = "Render last Request",
        },
        {
            mode = { "n" },
            lhs = "<leader>hc",
            rhs = "<cmd>HttpClient stopRequest<cr>",
            options = { silent = true },
            description = "Close all active client",
        },
    })
end

return pack
