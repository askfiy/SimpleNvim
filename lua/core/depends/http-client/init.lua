local api = require("utils.api")

local M = {}

M.lazy = {
    "askfiy/http-client.nvim",
}

function M.init()
    M.http_client = require("http-client")
end

function M.load()
    M.http_client.setup()
end

function M.after()
    api.map.bulk_register({
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
    })
end

return M
