local api = require("utils.api")

local M = {}

local methods = vim.lsp.protocol.Methods
local float_border_style = api.get_setting().get_float_border("rounded")

-------------------------------------------------------------------------------

local function enhanced_float_handler(handler)
    return function(_, result, ctx, config)
        local bufnr, winner = handler(_, result, ctx, config)

        if not bufnr or not winner then
            return
        end

        --
        vim.api.nvim_buf_set_var(bufnr, api.lsp.constant.float_feature, true)
        api.fn.generate_percentage_footer("down", winner, bufnr)

        -- Adjust the orientation to fit the display, in general, I prefer the floating window to appear above the cursor rather than below
        local window_height = vim.api.nvim_win_get_height(winner)
        local current_cursor_line = vim.fn.line(".")
        if current_cursor_line > window_height + 2 then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_win_set_config(winner, {
                anchor = "SW",
                relative = "cursor",
                row = 0,
                col = -1,
            })
        end

        return bufnr, winner
    end
end

function M.get_client_headlerss(configuration)
    local handlers = configuration.handlers or vim.lsp.handlers

    local lsp_float_config = {
        -- :h nvim_open_win() config
        border = float_border_style,
    }

    handlers[methods.textDocument_hover] = vim.lsp.with(
        enhanced_float_handler(vim.lsp.handlers.hover),
        lsp_float_config
    )

    handlers[methods.textDocument_signatureHelp] = vim.lsp.with(
        enhanced_float_handler(vim.lsp.handlers.signature_help),
        lsp_float_config
    )

    return handlers
end

-------------------------------------------------------------------------------

function M.get_client_capabilities(configuration)
    local capabilities = configuration.capabilities
        or vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    ---@diagnostic disable-next-line: missing-fields
    capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }

    return capabilities
end

-------------------------------------------------------------------------------

function M.init_configuration(configuration)
    local default_callback = function(client, bufnr) end

    local private_on_init = configuration.on_init or default_callback
    local private_on_attach = configuration.on_attach or default_callback

    configuration.on_init = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        if not api.get_setting().is_lspconfig_semantic_token() then
            client.server_capabilities.semanticTokensProvider = nil
        end
        private_on_init(client, bufnr)
    end

    configuration.on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(api.get_setting().is_lspconfig_inlay_hint())
        private_on_attach(client, bufnr)
    end

    configuration.handlers = M.get_client_headlerss(configuration)
    configuration.capabilities = M.get_client_capabilities(configuration)

    return configuration
end

return M
