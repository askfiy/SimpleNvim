-- https://github.com/hrsh7th/nvim-cmp

local helper = require("core.packages.nvim-cmp.helper")

local pack = {}

pack.lazy = {
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

function pack.before_load()
    pack.plugin = require("cmp")
    helper.load()
end

function pack.load()
    pack.plugin.setup({
        preselect = helper.preselect,
        view = helper.view,
        window = helper.window,
        snippet = helper.snippet,
        sorting = helper.sorting,
        formatting = helper.formatting,
        sources = helper.sources,
        confirmation = helper.confirmation,
        mapping = {
            ["<cr>"] = helper.confirm(),
            ["<c-f>"] = helper.scroll_docs(5),
            ["<c-b>"] = helper.scroll_docs(-5),
            ["<tab>"] = helper.confirm_select(),
            ["<c-p>"] = helper.select_prev_item(),
            ["<c-n>"] = helper.select_next_item(),
            ["<c-u>"] = helper.select_prev_n_item(5),
            ["<c-d>"] = helper.select_next_n_item(5),
            ["<c-k>"] = helper.toggle_complete_menu(),
        },
    })
end

function pack.after_load()
    helper.load_sources()
end

return pack
