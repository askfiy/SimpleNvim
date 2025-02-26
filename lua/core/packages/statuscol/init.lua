-- https://github.com/luukvbaal/statuscol.nvim

local utils = require("utils")

local pack = {}

pack.lazy = {
    "luukvbaal/statuscol.nvim",
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("statuscol")
end

function pack.load()
    local builtin = require("statuscol.builtin")

    pack.plugin.setup({
        ft_ignore = utils.special_filetypes(),
        bt_ignore = nil,
        segments = {
            {
                sign = {
                    name = { "Dap*", "Diag*" },
                    namespace = { "bulb*", "gitsign*", "diag*" },
                    colwidth = 1,
                },
                click = "v:lua.ScSa",
            },
            {
                text = { " ", builtin.lnumfunc },
                condition = { true, builtin.not_empty },
                click = "v:lua.ScLa",
            },
            {
                text = { " ", builtin.foldfunc, "  " },
                condition = { true, builtin.not_empty },
                click = "v:lua.ScFa",
            },
        },
    })
end

function pack.after_load()
    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = utils.special_filetypes(),
        callback = function()
            vim.opt_local.foldcolumn = "0"
        end,
    })
end

return pack
