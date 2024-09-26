-- https://github.com/hrsh7th/nvim-cmp

local aux = require("core.depends.nvim-cmp.aux")

local M = {}

M.lazy = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        { "L3MON4D3/LuaSnip" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "saadparwaiz1/cmp_luasnip" },
        { "kristijanhusak/vim-dadbod-completion" },
        { "tzachar/cmp-tabnine", build = "./install.sh" },
    },
    event = { "InsertEnter", "CmdlineEnter" },
}

function M.init()
    M.cmp = require("cmp")
    M.cmp_types = require("cmp.types")
    M.luasnip = require("luasnip")
    --
    aux.init(M.cmp, M.luasnip)
end

function M.load()
    M.cmp.setup({
        preselect = M.cmp_types.cmp.PreselectMode.None,
        view = aux.conf.get_view_conf(),
        window = aux.conf.get_window_conf(),
        snippet = aux.conf.get_snippet_conf(),
        sources = aux.conf.get_sources_conf(),
        sorting = aux.conf.get_sorting_conf(),
        formatting = aux.conf.get_formatting_conf(),
        confirmation = aux.conf.get_confirmation_conf(),
        mapping = {
            ["<cr>"] = aux.maps.confirm(),
            ["<c-f>"] = aux.maps.scroll_docs(5),
            ["<c-b>"] = aux.maps.scroll_docs(-5),
            ["<tab>"] = aux.maps.confirm_select(),
            ["<c-p>"] = aux.maps.select_prev_item(),
            ["<c-n>"] = aux.maps.select_next_item(),
            ["<c-u>"] = aux.maps.select_prev_n_item(5),
            ["<c-d>"] = aux.maps.select_next_n_item(5),
            ["<c-k>"] = aux.maps.toggle_complete_menu(),
        },
    })
end

function M.after()
    aux.conf.command_source_setup()
end

return M
