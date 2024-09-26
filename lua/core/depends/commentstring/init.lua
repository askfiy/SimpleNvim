-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring

local M = {}

M.lazy = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "VeryLazy" },
}

function M.init()
    M.commentstring = require("ts_context_commentstring")
end

function M.load()
    M.commentstring.setup({
        enable_autocmd = false,
    })
end

function M.after() end

return M
