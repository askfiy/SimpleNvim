local api = require("utils.api")

local M = {}

function M.init(cmp, luasnip)
    M.cmp = cmp
    M.luasnip = luasnip
end

function M.get_view_conf()
    return {
        -- "custom", "wildmenu" or "native"
        entries = "custom",
    }
end

function M.get_sources_conf()
    return M.cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "cmp_tabnine" },
        { name = "vim-dadbod-completion" },
    })
end

function M.get_confirmation_conf()
    -- Insert or Replace
    return {
        default_behavior = M.cmp.ConfirmBehavior.Insert,
    }
end

function M.get_snippet_conf()
    return {
        expand = function(args)
            M.luasnip.lsp_expand(args.body)
        end,
    }
end

function M.get_window_conf()
    if not api.get_setting().is_float_border() then
        return {}
    end

    return {
        completion = M.cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search",
            -- menu position offset
            col_offset = -4,
            -- content offset
            side_padding = 0,
        }),
        documentation = M.cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search",
        }),
    }
end

function M.get_sorting_conf()
    return {
        priority_weight = 2,
        comparators = {
            M.cmp.config.compare.offset,
            M.cmp.config.compare.exact,
            -- cmp.config.compare.scopes,
            M.cmp.config.compare.score,
            M.cmp.config.compare.recently_used,
            M.cmp.config.compare.locality,
            M.cmp.config.compare.kind,
            -- cmp.config.compare.sort_text,
            M.cmp.config.compare.length,
            M.cmp.config.compare.order,
            -- cmp.config.compare.recently_used,
            -- cmp.config.compare.locality,
        },
    }
end

function M.get_formatting_conf()
    if not api.get_setting().is_enable_icon_groups("kind") then
        return {}
    end

    ----

    local kind_icons = api.get_setting().get_icon_groups("kind", false)
    local source_icons = api.get_setting().get_icon_groups("source", false)
    local default_icon = kind_icons["Default"]

    local complete_window_conf = {
        fixed = false,
        min_width = 15,
        max_width = 15,
    }

    local complete_duplicate_conf = {
        -- allow duplicate keywords
        ["luasnip"] = 1,
        ["nvim_lsp"] = 1,
        -- do not allow duplicate keywords
        ["buffer"] = 0,
        ["path"] = 0,
        ["cmdline"] = 0,
        ["cmp_tabnine"] = 0,
        ["vim-dadbod-completion"] = 0,
    }

    return {
        -- sort menu
        fields = { "kind", "abbr", "menu" },
        expandable_indicator = true,

        format = function(entry, vim_item)
            local abbr = vim_item.abbr
            local kind = vim_item.kind
            ---@diagnostic disable-next-line: unused-local
            local menu = vim_item.menu

            local source = entry.source.name

            -- vim_item.abbr = kind
            -- vim_item.menu = ("<%s>"):format(source:upper())

            local defualt_kind = (" %s "):format(
                kind_icons[kind] or default_icon
            )

            -- icon_prefix
            if not api.get_setting().is_enable_icon_groups("source") then
                vim_item.kind = defualt_kind
            else
                vim_item.kind = (" %s "):format(
                    source_icons[source] or defualt_kind
                )
            end

            vim_item.menu = ("<%s>"):format(menu)
            vim_item.dup = complete_duplicate_conf[source] or 0

            -- determine if it is a fixed window size
            if complete_window_conf.fixed and vim.fn.mode() == "i" then
                local min_width = complete_window_conf.min_width
                local max_width = complete_window_conf.max_width
                local truncated_abbr = vim.fn.strcharpart(abbr, 0, max_width)

                if truncated_abbr ~= abbr then
                    vim_item.abbr = ("%s %s"):format(truncated_abbr, "…")
                elseif abbr:len() < min_width then
                    local padding = (" "):rep(min_width - abbr:len())
                    vim_item.abbr = ("%s %s"):format(abbr, padding)
                end
            end

            return vim_item
        end,
    }
end

function M.command_source_setup()
    -- define completion in cmd mode
    M.cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        },
    })

    M.cmp.setup.cmdline("?", {
        sources = {
            { name = "buffer" },
        },
    })

    M.cmp.setup.cmdline(":", {
        sources = M.cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
            M.cmp.setup.buffer({
                sources = { { name = "vim-dadbod-completion" } },
            })
            vim.opt_local.filetype = "sql"
            vim.opt_local.commentstring = "-- %s"
        end,
    })
end

return M
