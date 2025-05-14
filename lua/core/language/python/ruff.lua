return {
    on_init = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
    end,
}
