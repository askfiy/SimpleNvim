local conf = require("conf")

local helper = {}

local function autocomplete()
    local luasnip = require("luasnip")
    local default_on_change = require("cmp.core").on_change

    require("cmp.core").on_change = function(self, trigger_event)
        local in_snippet = luasnip.in_snippet()
        local jump_prev_able = luasnip.jumpable(-1)
        local jump_next_able = luasnip.jumpable(1)

        -- When jumping up or down is available in the fragment, no automatic completion will be performed
        if
            not (
                vim.bo.filetype == "markdown"
                and in_snippet
                and (jump_prev_able or jump_next_able)
            )
        then
            default_on_change(self, trigger_event)
        end
    end
end

local function under_sort(entry1, entry2)
    local _, entry1_under = entry1.completion_item.label:find("^_+")
    local _, entry2_under = entry2.completion_item.label:find("^_+")
    entry1_under = entry1_under or 0
    entry2_under = entry2_under or 0
    if entry1_under > entry2_under then
        return false
    elseif entry1_under < entry2_under then
        return true
    end
end

local function get_window_config()
    if not conf.is_float_border() then
        return {}
    end

    return {
        completion = helper.plugin.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search",
            -- menu position offset
            col_offset = -4,
            -- content offset
            side_padding = 0,
        }),
        documentation = helper.plugin.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search",
        }),
    }
end

local function get_view_config()
    return {
        -- "custom", "wildmenu" or "native"
        entries = "custom",
    }
end

local function get_snippet_config()
    return {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    }
end

local function get_sources_config()
    return helper.plugin.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "cmp_tabnine" },
        { name = "vim-dadbod-completion" },
    })
end

local function get_sorting_config()
    return {
        priority_weight = 2,
        comparators = {
            under_sort,
            helper.plugin.config.compare.offset,
            helper.plugin.config.compare.exact,
            -- helper.plugin.config.compare.scopes,
            helper.plugin.config.compare.score,
            helper.plugin.config.compare.recently_used,
            helper.plugin.config.compare.locality,
            helper.plugin.config.compare.kind,
            -- helper.plugin.config.compare.sort_text,
            helper.plugin.config.compare.length,
            helper.plugin.config.compare.order,
            -- helper.plugin.config.compare.recently_used,
            -- helper.plugin.config.compare.locality,
        },
    }
end

local function get_formatting_config()
    if not conf.is_enable_icons_by_group("kind") then
        return {}
    end

    local kind_icons = conf.get_icons_by_group("kind")

    local default_icon = kind_icons["Default"]

    local complete_window_conf = {
        fixed = false,
        min_width = 15,
        max_width = 15,
    }

    local complete_duplicate_conf = {
        -- allow duplicate keywords
        ["nvim_lsp"] = 1,
        -- do not allow duplicate keywords
        ["luasnip"] = 0,
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
            -- local menu = vim_item.menu

            local source = entry.source.name

            -- vim_item.abbr = kind
            -- vim_item.menu = ("<%s>"):format(source:upper())

            vim_item.kind = (" %s "):format(kind_icons[kind] or default_icon)
            vim_item.menu = ("<%s>"):format(source)

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

local function get_confirmation_config()
    -- Insert or Replace
    return {
        default_behavior = helper.plugin.ConfirmBehavior.Insert,
    }
end

function helper.confirm()
    return helper.plugin.mapping(
        helper.plugin.mapping.confirm(),
        { "i", "s", "c" }
    )
end

function helper.confirm_select()
    return helper.plugin.mapping(
        helper.plugin.mapping.confirm({ select = true }),
        { "i", "s", "c" }
    )
end

function helper.scroll_docs(n)
    return helper.plugin.mapping(
        helper.plugin.mapping.scroll_docs(n),
        { "i", "s", "c" }
    )
end

function helper.select_prev_item()
    return helper.plugin.mapping(
        helper.plugin.mapping.select_prev_item(),
        { "i", "s", "c" }
    )
end

function helper.select_next_item()
    return helper.plugin.mapping(
        helper.plugin.mapping.select_next_item(),
        { "i", "s", "c" }
    )
end

function helper.select_prev_n_item(n)
    return helper.plugin.mapping(function(fallback)
        if helper.plugin.visible() then
            for i = 1, n, 1 do
                helper.plugin.select_prev_item({
                    behavior = helper.plugin.SelectBehavior.Select,
                })
            end
        else
            fallback()
        end
    end, { "i", "s", "c" })
end

function helper.select_next_n_item(n)
    return helper.plugin.mapping(function(fallback)
        if helper.plugin.visible() then
            for i = 1, n, 1 do
                helper.plugin.select_next_item({
                    behavior = helper.plugin.SelectBehavior.Select,
                })
            end
        else
            fallback()
        end
    end, { "i", "s", "c" })
end

function helper.toggle_complete_menu()
    return helper.plugin.mapping(function()
        if helper.plugin.visible() then
            helper.plugin.abort()
        else
            helper.plugin.complete()
        end
    end, { "i", "s", "c" })
end

function helper.load_sources()
    helper.plugin.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        },
    })

    helper.plugin.setup.cmdline("?", {
        sources = {
            { name = "buffer" },
        },
    })

    helper.plugin.setup.cmdline(":", {
        sources = helper.plugin.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
            helper.plugin.setup.buffer({
                sources = { { name = "vim-dadbod-completion" } },
            })
            vim.opt_local.filetype = "sql"
            vim.opt_local.commentstring = "-- %s"
        end,
    })
end

function helper.load()
    autocomplete()

    helper.plugin = require("cmp")
    helper.preselect = require("cmp.types").cmp.PreselectMode.None

    helper.view = get_view_config()
    helper.window = get_window_config()
    helper.snippet = get_snippet_config()
    helper.sources = get_sources_config()
    helper.sorting = get_sorting_config()
    helper.formatting = get_formatting_config()
    helper.confirmation = get_confirmation_config()
end

return helper
