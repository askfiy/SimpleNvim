local lsp = {}


-- function lsp.filter_publish_diagnostics({
--
-- })
-- {
--   diagnostics = { {
--       message = '"socketserver" is not accessed',
--       range = {
--         ["end"] = {
--           character = 19,
--           line = 1
--         },
--         start = {
--           character = 7,
--           line = 1
--         }
--       },
--       severity = 4,
--       source = "Pyright",
--       tags = { 1 }
--     } },
--   uri = "file:///Users/askfiy/project/pyproject/main.py",
--   version = 0
-- }

--


---@class DiagnosticsFilters
---@field message? table<string>
---@field level? table<string>

---@param diagnostics_filters DiagnosticsFilters
function lsp.filter_publish_diagnostics(diagnostics_filters)
    diagnostics_filters.level = diagnostics_filters.level or {}
    diagnostics_filters.message = diagnostics_filters.message or {}

    local filters_level = vim.tbl_map(function(level)
        return vim.diagnostic.severity[level:upper()]
    end, diagnostics_filters.level)

    return function(err, result, ctx)

        if diagnostics_filters.message then
            local new_index = 1

            for _, diagnostic in ipairs(result.diagnostics) do
                local message_ignored = false

                -- Use regular expressions to check if messages are ignored
                for _, pattern in ipairs(diagnostics_filters.message) do
                    if string.match(diagnostic.message, pattern) then
                        message_ignored = true
                        break
                    end
                end

                if
                    not (
                        vim.tbl_contains(
                            filters_level,
                            diagnostic.severity
                        ) -- disable level
                        or message_ignored -- disable message
                    )
                then
                    result.diagnostics[new_index] = diagnostic
                    new_index = new_index + 1
                end
            end

            for i = new_index, #result.diagnostics do
                result.diagnostics[i] = nil
            end
        end

        vim.lsp.diagnostic.on_publish_diagnostics(
            err,
            result,
            ctx
        )
    end
end


return lsp
