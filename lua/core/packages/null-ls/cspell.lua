local conf = require("conf")
local utils = require("utils")

local cspell = {}

local function tbl_find_index(tbl, element)
    local index = 0
    for i, v in ipairs(tbl) do
        if v == element then
            index = i
            break
        end
    end
    return index
end

local function exclude_diagnostic_namespace_by_name(ignore_lsp_sources)
    local namespaces = {}
    for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
        if not vim.tbl_contains(ignore_lsp_sources, diagnostic.source) then
            table.insert(namespaces, diagnostic.namespace)
        end
    end
    return namespaces
end

local function include_diagnostic_namespace_by_name(ignore_lsp_sources)
    local namespaces = {}
    for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
        if vim.tbl_contains(ignore_lsp_sources, diagnostic.source) then
            table.insert(namespaces, diagnostic.namespace)
        end
    end
    return namespaces
end

local function get_cspell_word()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local lnum = cursor[1]
    local col = cursor[2]

    local diagnostics = vim.diagnostic.get(0, {
        lnum = lnum - 1,
    })
    local cword = vim.fn.expand("<cword>")

    local filter_diagnostics = {}
    for _, diagnostic in ipairs(diagnostics) do
        local cspell_word =
            cword:match(diagnostic.message:match("Unknown word %((.*)%)"))
        if diagnostic.source == "cspell" and cspell_word then
            table.insert(filter_diagnostics, {
                word = cspell_word,
                lnum = diagnostic.lnum,
                end_lnum = diagnostic.end_lnum,
                col = diagnostic.col,
                end_col = diagnostic.end_col,
            })
        end
    end

    local closest_diag = nil
    local closest_distance = math.huge

    for _, diagnostic in ipairs(filter_diagnostics) do
        local distance = math.abs(diagnostic.col - col)
        if distance < closest_distance then
            closest_distance = distance
            closest_diag = diagnostic
        end
    end

    if closest_diag then
        return closest_diag.word
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = { "*" },
    callback = function()
        local filepath = conf.get_cspell_conf_path()
        local dirname = utils.path.dirname(filepath)

        if not utils.path.exists(dirname) then
            vim.fn.mkdir(dirname)
        end

        if not utils.path.exists(filepath) then
            vim.fn.writefile({
                vim.json.encode({
                    version = "0.2",
                    language = "en",
                    words = {},
                }),
            }, filepath)
        end

        local content = table.concat(vim.fn.readfile(filepath), "\n")
        cspell.cacher = vim.json.decode(content)
    end,
    desc = "Load word dictionary",
    once = true,
})

function cspell.load()
    cspell.plugin = require("null-ls")

    local source = cspell.plugin.builtins.diagnostics.cspell.with({
        diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["HINT"]
        end,
        extra_args = {
            "--config",
            conf.get_cspell_conf_path(),
        },

        diagnostic_config = {
            underline = true,
            severity_sort = true,
            signs = true,
            virtual_text = true,
            update_in_insert = false,
        },
        disabled_filetypes = utils.special_filetypes(),
        runtime_condition = conf.code_spell_is_open,
    })

    return source
end

function cspell.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>cs",
            rhs = function()
                local null_query = { name = "cspell" }

                if conf.code_spell_is_open() then
                    cspell.plugin.disable(null_query)
                else
                    cspell.plugin.enable(null_query)
                end

                conf.switch_code_spell()
            end,
            options = { silent = true },
            description = "Enable or disable spell checking",
        },
        {

            mode = { "n" },
            lhs = "[s",
            rhs = function()
                vim.diagnostic.jump({
                    count = -1,
                    float = { border = conf.get_float_border("rounded") },
                    namespace = include_diagnostic_namespace_by_name({
                        "cspell",
                    }),
                })
            end,
            options = { silent = true },
            description = "Go to prev cspell word",
        },
        {

            mode = { "n" },
            lhs = "]s",
            rhs = function()
                vim.diagnostic.jump({
                    count = 1,
                    float = { border = conf.get_float_border("rounded") },
                    namespace = include_diagnostic_namespace_by_name({
                        "cspell",
                    }),
                })
            end,
            options = { silent = true },
            description = "Go to next cspell word",
        },
        {
            mode = { "n" },
            lhs = "zg",
            rhs = function()
                local word = get_cspell_word()

                if not vim.tbl_contains(cspell.cacher.words, word) then
                    table.insert(cspell.cacher.words, word)
                    vim.fn.writefile(
                        { vim.json.encode(cspell.cacher) },
                        conf.get_cspell_conf_path()
                    )
                    vim.cmd([[:e]])
                else
                    vim.api.nvim_echo({
                        {
                            ("'%s' already exists"):format(word),
                            "WarningMsg",
                        },
                    }, false, {})
                end
            end,
            options = { silent = true },
            description = "Add word to cspell.json",
        },
        {
            mode = { "n" },
            lhs = "zw",
            rhs = function()
                local word = vim.fn.expand("<cword>")

                for _, cacher_word in ipairs(cspell.cacher.words) do
                    if word:find(cacher_word) then
                        table.remove(
                            cspell.cacher.words,
                            tbl_find_index(cspell.cacher.words, cacher_word)
                        )
                        vim.fn.writefile(
                            { vim.json.encode(cspell.cacher) },
                            conf.get_cspell_conf_path()
                        )
                        return vim.cmd([[:e]])
                    end
                end

                vim.api.nvim_echo({
                    {
                        ("'%s' does not exist"):format(word),
                        "WarningMsg",
                    },
                }, false, {})
            end,
            options = { silent = true },
            description = "Add word to cspell.json",
        },
    })
end

return cspell
