local lsp = {}

function lsp.filter_publish_diagnostics(
    a,
    params,
    client_info,
    extra_message,
    config
)
    -- local client = vim.lsp.get_client_by_id(client_info.client_id)

    local ignore_diagnostic_message = extra_message.ignore_diagnostic_message
        or {}

    local ignore_diagnostic_level = vim.tbl_map(function(level)
        return vim.diagnostic.severity[level:upper()]
    end, extra_message.ignore_diagnostic_level or {})

    if ignore_diagnostic_message then
        local new_index = 1

        for _, diagnostic in ipairs(params.diagnostics) do
            local message_ignored = false

            -- Use regular expressions to check if messages are ignored
            for _, pattern in ipairs(ignore_diagnostic_message) do
                if string.match(diagnostic.message, pattern) then
                    message_ignored = true
                    break
                end
            end

            if
                not (
                    vim.tbl_contains(
                        ignore_diagnostic_level,
                        diagnostic.severity
                    ) -- disable level
                    or message_ignored -- disable message
                )
            then
                params.diagnostics[new_index] = diagnostic
                new_index = new_index + 1
            end
        end

        for i = new_index, #params.diagnostics do
            params.diagnostics[i] = nil
        end
    end

    vim.lsp.diagnostic.on_publish_diagnostics(
        a,
        params,
        client_info,
        extra_message,
        config
    )
end

return lsp
