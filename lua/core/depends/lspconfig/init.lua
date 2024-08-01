-- https://github.com/neovim/nvim-lspconfig

local api = require("utils.api")
local aux = require("core.depends.lspconfig.aux")

local M = {}

M.lazy = {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
    },
}

function M.init()
    M.lspconfig = require("lspconfig")
    M.lspconfig_configs = require("lspconfig.configs")
    M.lspconfig_ui_windows = require("lspconfig.ui.windows")
end

function M.load()
    -- load simple-servers
    M.lspconfig_configs["pylance"] =
        require("core.package.simple-servers.pylance")

    for _, lang_pack in ipairs(api.get_lang().get_lang_pack()) do
        local server_name = lang_pack.lspconfig.server
        local server_conf = lang_pack.lspconfig.config

        if "string" == type(server_conf) then
            server_conf = require(server_conf)
        end

        aux.conf.init_configuration(server_conf)
        M.lspconfig[server_name].setup(server_conf)
    end

    M.lspconfig_ui_windows.default_options.border = api.get_setting()
        .get_float_border("double")
end

function M.after()
    vim.diagnostic.config({
        signs = true,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        ---@diagnostic disable-next-line: assign-type-mismatch
        float = { source = "always" },
        ---@diagnostic disable-next-line: assign-type-mismatch
        virtual_text = { prefix = "●", source = "always" },
    })

    if api.get_setting().is_enable_icon_groups("diagnostic") then
        local icons = api.get_setting().get_icon_groups("diagnostic", true)
        for tp, icon in pairs(icons) do
            local hl = ("DiagnosticSign%s"):format(tp)
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end
end

function M.register_maps()

    -- Delete default lsp mapping
    -- api.map.unregister("n", "grr")
    -- api.map.unregister("n", "grn")
    -- api.map.unregister("n", "gra")

    api.map.bulk_register({
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
            mode = { "n" },
            lhs = "<leader>ct",
            rhs = aux.maps.toggle_inlay_hint,
            options = { silent = true },
            description = "Toggle inlay hint",
        },
        {
            mode = { "n" },
            lhs = "<leader>cf",
            rhs = function()
                vim.lsp.buf.format({ async = true })
            end,
            options = { silent = true },
            description = "Format buffer",
        },
        {
            mode = { "n" },
            lhs = "gh",
            rhs = vim.lsp.buf.hover,
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
            rhs = aux.maps.diagnostic_open_float,
            options = { silent = true },
            description = "Show Current Diagnostics",
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
            rhs = aux.maps.goto_prev_diagnostic,
            options = { silent = true },
            description = "Jump to prev diagnostic",
        },
        {
            mode = { "n" },
            lhs = "]d",
            rhs = aux.maps.goto_next_diagnostic,
            options = { silent = true },
            description = "Jump to next diagnostic",
        },
        {
            mode = { "i" },
            lhs = "<c-j>",
            rhs = aux.maps.toggle_signature_help,
            options = { silent = true },
            description = "Toggle signature help",
        },
        {
            mode = { "i", "n" },
            lhs = "<c-b>",
            rhs = aux.maps.scroll_docs_to_up("<c-b>", 5),
            options = { silent = true },
            description = "Scroll up floating window",
        },
        {
            mode = { "i", "n" },
            lhs = "<c-f>",
            rhs = aux.maps.scroll_docs_to_down("<c-f>", 5),
            options = { silent = true },
            description = "Scroll down floating window",
        },
    })
end

return M
