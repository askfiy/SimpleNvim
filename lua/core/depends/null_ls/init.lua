-- https://github.com/nvimtools/none-ls.nvim

local api = require("utils.api")
local aux = require("core.depends.null_ls.aux")

local M = {}

M.lazy = {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "neovim/nvim-lspconfig" },
    },
}

function M.init()
    M.null_ls = require("null-ls")
    ---
    aux.init(M.null_ls)
end

function M.load()
    local sources = aux.get_sources()

    -- load all sources
    for _, lang_pack in ipairs(api.get_lang().get_lang_pack()) do
        if not vim.tbl_isempty(lang_pack.null_ls) then
            for source_type, source_conf in pairs({
                hover = lang_pack.null_ls.hover,
                formatting = lang_pack.null_ls.formatting,
                completion = lang_pack.null_ls.completion,
                diagnostics = lang_pack.null_ls.diagnostics,
                code_actions = lang_pack.null_ls.code_actions,
            }) do
                if source_conf and source_conf.enable then
                    local null_ls_pack =
                        M.null_ls.builtins[source_type][source_conf.exe]
                    if not vim.tbl_isempty(source_conf.extra_args) then
                        null_ls_pack =
                            M.null_ls.builtins[source_type][source_conf.exe].with({
                                extra_args = source_conf.extra_args,
                            })
                    end
                    if not vim.tbl_contains(sources, null_ls_pack) then
                        table.insert(sources, null_ls_pack)
                    end
                end
            end
        end
    end

    M.null_ls.setup({
        border = api.get_setting().get_float_border("double"),
        sources = sources,
    })
end

function M.after() end

function M.register_maps()
    aux.register_maps()
end

return M
