---@diagnostic disable: param-type-mismatch
local api = require("utils.api")

local M = {}

local inlay_hint = api.get_setting().is_lspconfig_inlay_hint()
local float_border_style = api.get_setting().get_float_border("rounded")

-------------------------------------------------------------------------------

function M.goto_prev_diagnostic()
    ---@diagnostic disable-next-line: missing-fields, deprecated
    vim.diagnostic.goto_prev({
        float = { border = float_border_style },
        namespace = api.lsp.exclude_diagnostic_namespace_by_name({ "cspell" }),
    })

    -- vim.diagnostic.jump({
    --     count = -1,
    --     float = { border = float_border_style },
    --     namespace = api.lsp.exclude_diagnostic_namespace_by_name({ "cspell" }),
    -- })
end

function M.goto_next_diagnostic()
    ---@diagnostic disable-next-line: missing-fields, deprecated
    vim.diagnostic.goto_next({
        float = { border = float_border_style },
        namespace = api.lsp.exclude_diagnostic_namespace_by_name({ "cspell" }),
    })
    -- vim.diagnostic.jump({
    --     count = 1,
    --     float = { border = float_border_style },
    --     namespace = api.lsp.exclude_diagnostic_namespace_by_name({ "cspell" }),
    -- })
end

function M.open_diagnostic()
    if
        not vim.tbl_isempty(
            vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        )
    then
        vim.diagnostic.open_float({
            border = float_border_style,
        })
    else
        require("telescope.builtin").diagnostics({ bufnr = 0 })
    end
end

function M.toggle_inlay_hint()
    inlay_hint = not inlay_hint
    vim.lsp.inlay_hint.enable(inlay_hint)
end

function M.toggle_signature_help()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if api.fn.buf_has_var(bufnr, api.lsp.constant.float_feature) then
            vim.api.nvim_win_close(vim.fn.bufwinid(bufnr), false)
            return
        end
    end
    vim.lsp.buf.signature_help()
end

function M.scroll_docs_to_up(map, scroll)
    local cache_scrolloff = vim.opt.scrolloff:get()

    return function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if api.fn.buf_has_var(bufnr, api.lsp.constant.float_feature) then
                local winner = vim.fn.bufwinid(bufnr)
                local cursor_line = vim.fn.line(".", winner)
                local buffer_total_line = vim.api.nvim_buf_line_count(bufnr)
                local window_height = vim.api.nvim_win_get_height(winner)
                local win_first_line = vim.fn.line("w0", winner)

                if
                    buffer_total_line + 1 <= window_height
                    or cursor_line == 1
                then
                    -- vim.api.nvim_echo(
                    --     { { "Can't scroll up", "WarningMsg" } },
                    --     false,
                    --     {}
                    -- )
                    return
                end

                vim.opt.scrolloff = 0

                if cursor_line > win_first_line then
                    if win_first_line - scroll > 1 then
                        vim.api.nvim_win_set_cursor(
                            winner,
                            { win_first_line - scroll, 0 }
                        )
                    else
                        vim.api.nvim_win_set_cursor(winner, { 1, 0 })
                    end
                elseif cursor_line - scroll < 1 then
                    vim.api.nvim_win_set_cursor(winner, { 1, 0 })
                else
                    vim.api.nvim_win_set_cursor(
                        winner,
                        { cursor_line - scroll, 0 }
                    )
                end
                vim.opt.scrolloff = cache_scrolloff

                api.fn.generate_percentage_footer("up", winner, bufnr)
                return
            end
        end

        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

function M.scroll_docs_to_down(map, scroll)
    local cache_scrolloff = vim.opt.scrolloff:get()

    return function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if api.fn.buf_has_var(bufnr, api.lsp.constant.float_feature) then
                local winner = vim.fn.bufwinid(bufnr)

                local cursor_line = vim.fn.line(".", winner)
                local buffer_total_line = vim.api.nvim_buf_line_count(bufnr)
                local window_height = vim.api.nvim_win_get_height(winner)
                local window_last_line = vim.fn.line("w$", winner)

                if

                    buffer_total_line + 1 <= window_height
                    or cursor_line == buffer_total_line
                then
                    -- vim.api.nvim_echo(
                    --     { { "Can't scroll down", "WarningMsg" } },
                    --     false,
                    --     {}
                    -- )
                    return
                end

                vim.opt.scrolloff = 0

                if cursor_line < window_last_line then
                    if window_last_line + scroll < buffer_total_line then
                        vim.api.nvim_win_set_cursor(
                            winner,
                            { window_last_line + scroll, 0 }
                        )
                    else
                        vim.api.nvim_win_set_cursor(
                            winner,
                            { buffer_total_line, 0 }
                        )
                    end
                elseif cursor_line + scroll >= buffer_total_line then
                    vim.api.nvim_win_set_cursor(
                        winner,
                        { buffer_total_line, 0 }
                    )
                else
                    vim.api.nvim_win_set_cursor(
                        winner,
                        { cursor_line + scroll, 0 }
                    )
                end

                vim.opt.scrolloff = cache_scrolloff

                api.fn.generate_percentage_footer("down", winner, bufnr)
                return
            end
        end

        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

return M
