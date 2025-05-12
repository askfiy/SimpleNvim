-- https://github.com/neovim/nvim-lspconfig

local conf = require("conf")
local utils = require("utils")
local language = require("core.language")

local pack = {}

pack.lazy = {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "askfiy/lsp-helper.nvim" },
    },
}

function pack.before_load()
    pack.plugin = require("lspconfig")
end

function pack.load()
    require("lsp-helper").setup({
        float = {
            border = conf.get_float_border("rounded"),
            progress_format = function(progress)
                return ("%s%%"):format(tostring(progress))
            end,
        },
        diagnostic = {
            config = {
                virtual_text = { source = "always" },
            },
            icons = {},
            jump_ignore_lsp_sources = { "cspell" },
        },
        lspconfig = {
            on_init = function(client, initialize_result)
                client.server_capabilities.documentFormattingProvider = false
                local bufnr = vim.api.nvim_get_current_buf()

                if
                    not vim.tbl_contains(
                        language.get_treesitter_disabled_highlight(),
                        vim.api.nvim_buf_get_option(bufnr, "filetype")
                    )
                then
                    client.server_capabilities.semanticTokensProvider = nil
                end
            end,
            on_attach = function(client, bufnr)
                vim.lsp.inlay_hint.enable(conf.inlay_hint_is_open())
            end,
        },
    })
end

function pack.after_load()
    for server_name, server_conf in pairs(language.get_lsp_packages()) do
        vim.lsp.config(server_name, server_conf)
        vim.lsp.enable({server_name})
        pack.plugin[server_name].setup(server_conf)
    end
end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>ca",
            rhs = vim.lsp.buf.code_action,
            options = { silent = true },
            description = "Show code action",
        },
        {
            mode = { "n" },
            lhs = "<leader>cn",
            rhs = vim.lsp.buf.rename,
            options = { silent = true },
            description = "Variable renaming",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>ct",
            rhs = function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end,
            options = { silent = true },
            description = "Format buffer",
        },
        {
            mode = { "n", "v" },
            lhs = "<leader>cf",
            rhs = function()
                vim.lsp.buf.format({ async = true })
            end,
            options = { silent = true },
            description = "Format buffer",
        },
        {
            mode = { "v" },
            lhs = "<leader>cf",
            rhs = function()
                vim.lsp.buf.format({
                    async = true,
                    range = {
                        vim.fn.getpos("v"),
                        vim.api.nvim_win_get_cursor(0),
                    },
                })
            end,
            options = { silent = true },
            description = "Format buffer",
        },
        {
            mode = { "n" },
            lhs = "gh",
            rhs = function()
                require("lsp-helper").lsp.hover()
            end,
            options = { silent = true },
            description = "Show help information",
        },
        {
            mode = { "n" },
            lhs = "gr",
            rhs = function()
                require("telescope.builtin").lsp_references()
            end,
            options = { silent = true },
            description = "Go to references",
        },
        {
            mode = { "n" },
            lhs = "gi",
            rhs = function()
                require("telescope.builtin").lsp_implementations()
            end,
            options = { silent = true },

            description = "Go to implementations",
        },
        {
            mode = { "n" },
            lhs = "gd",
            rhs = function()
                require("telescope.builtin").lsp_definitions()
            end,
            options = { silent = true },
            description = "Go to definitions",
        },
        {
            mode = { "n" },
            lhs = "gD",
            rhs = function()
                require("telescope.builtin").lsp_type_definitions()
            end,
            options = { silent = true },
            description = "Go to type definitions",
        },
        {
            mode = { "n" },
            lhs = "go",
            rhs = function()
                require("lsp-helper").diagnostic.open()
            end,
            options = { silent = true },
            description = "Show Current Cursor/Bufnr Diagnostic[s]",
        },
        {
            mode = { "n" },
            lhs = "gO",
            rhs = function()
                require("telescope.builtin").diagnostics()
            end,
            options = { silent = true },
            description = "Show Workspace Diagnostics",
        },
        {
            mode = { "n" },
            lhs = "[d",
            rhs = function()
                require("lsp-helper").diagnostic.goto_prev()
            end,
            options = { silent = true },
            description = "Jump to prev diagnostic",
        },
        {
            mode = { "n" },
            lhs = "]d",
            rhs = function()
                require("lsp-helper").diagnostic.goto_next()
            end,
            options = { silent = true },
            description = "Jump to next diagnostic",
        },
        {
            mode = { "i" },
            lhs = "<c-j>",
            rhs = function()
                require("lsp-helper").lsp.signature_help()
            end,
            options = { silent = true },
            description = "Toggle signature help",
        },
        {
            mode = { "i", "n" },
            lhs = "<c-b>",
            rhs = function()
                require("lsp-helper").float.scroll_hover_to_up(5)
            end,
            options = { silent = true },
            description = "Scroll up floating window",
        },
        {
            mode = { "i", "n" },
            lhs = "<c-f>",
            rhs = function()
                require("lsp-helper").float.scroll_hover_to_down(5)
            end,
            options = { silent = true },
            description = "Scroll down floating window",
        },
    })
end

return pack
