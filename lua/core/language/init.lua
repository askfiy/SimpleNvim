local utils = require("utils")

local language = {}

language.packages = {}

function language.has(lang)
    local packages = language.get_packages()
    return vim.tbl_contains(vim.tbl_keys(packages), lang)
end

function language.get_packages()
    if vim.tbl_isempty(language.packages) then
        local dirname = utils.path.dirname(utils.path.filepath())

        vim.tbl_map(function(lang_name)
            local lang_pack = utils.relative_import("./" .. lang_name)
            if lang_pack.enable ~= false then
                language.packages[lang_name] = lang_pack
            end
        end, utils.get_package_from_directory(utils.path.join(dirname)))
    end

    return language.packages
end

function language.get_lazy_packages()
    local lang_packages = language.get_packages()
    local lazy_packages = {}

    for _, lang_package in ipairs(vim.tbl_values(lang_packages)) do
        for _, lazy_package in ipairs(lang_package.lazy or {}) do
            if not vim.tbl_contains(lazy_packages, lazy_package) then
                table.insert(lazy_packages, lazy_package)
            end
        end
    end

    return lazy_packages
end

function language.get_lsp_packages()
    local registry = require("mason-registry")
    local lang_packages = language.get_packages()
    local lsp_packages = {}

    for lang_name, lang_package in pairs(lang_packages) do
        if
            type(lang_package.lspconfig) == "table"
            and type(lang_package.lspconfig.server) == "table"
        then
            for _, server_name in ipairs(lang_package.lspconfig.server) do
                if
                    not vim.tbl_contains(
                        vim.tbl_keys(lsp_packages),
                        server_name
                    )
                then
                    local config_path = ("./%s/%s"):format(
                        lang_name,
                        server_name
                    )

                    local ok, server_conf =
                        pcall(utils.relative_import, config_path)

                    local aliases = registry.get_package_aliases(server_name)
                    if not vim.tbl_isempty(aliases) then
                        server_name = aliases[1]
                    end

                    if not ok then
                        lsp_packages[server_name] = {}
                    else
                        lsp_packages[server_name] = server_conf
                    end
                end
            end
        end
    end

    return lsp_packages
end

function language.get_dap_packages()
    local lang_packages = language.get_packages()

    local dap_packages = {
        adapters = {},
        configurations = {},
    }

    local dirname = utils.path.dirname(utils.path.filepath())

    for lang_name, lang_package in pairs(lang_packages) do
        local dapfile = utils.path.join(dirname, lang_name, "debug.lua")

        if utils.path.exists(dapfile) then
            local dapconfig =
                utils.relative_import(("./%s/%s"):format(lang_name, "debug"))

            dap_packages.adapters = vim.tbl_deep_extend(
                "force",
                dap_packages.adapters,
                dapconfig.adapters
            )
            dap_packages.configurations = vim.tbl_deep_extend(
                "force",
                dap_packages.configurations,
                dapconfig.configurations
            )
        end
    end

    return dap_packages
end

function language.get_mason_packages(installed)
    local lang_packages = language.get_packages()
    local mason_packages = { unpack(installed or {}) }

    for _, lang_package in ipairs(vim.tbl_values(lang_packages)) do
        if lang_package.mason and lang_package.mason.ensure_installed then
            for _, mason_package in ipairs(lang_package.mason.ensure_installed) do
                if not vim.tbl_contains(mason_packages, mason_package) then
                    table.insert(mason_packages, mason_package)
                end
            end
        end
    end

    return mason_packages
end

function language.get_treesitter_packages(installed)
    local lang_packages = language.get_packages()
    local treesitter_packages = { unpack(installed or {}) }

    for _, lang_package in ipairs(vim.tbl_values(lang_packages)) do
        if
            lang_package.treesitter
            and lang_package.treesitter.ensure_installed
        then
            for _, treesitter_package in
                ipairs(lang_package.treesitter.ensure_installed)
            do
                if
                    not vim.tbl_contains(
                        treesitter_packages,
                        treesitter_package
                    )
                then
                    table.insert(treesitter_packages, treesitter_package)
                end
            end
        end
    end

    return treesitter_packages
end

function language.get_treesitter_disabled_highlight(ensure_disabled)
    local lang_packages = language.get_packages()
    local disabled_highlight = { unpack(ensure_disabled or {}) }

    for lang_name, lang_package in pairs(lang_packages) do
        if
            lang_package.treesitter
            and lang_package.treesitter.disable_highlight
        then
            table.insert(disabled_highlight, lang_name)
        end
    end

    return disabled_highlight
end

function language.get_null_ls()
    local lang_packages = language.get_packages()
    local null_ls_packages = {}

    for _, lang_package in ipairs(vim.tbl_values(lang_packages)) do
        for source_type, source_conf in pairs(lang_package.null_ls) do
            source_conf["type"] = source_type
            table.insert(null_ls_packages, source_conf)
        end
    end

    return null_ls_packages
end

function language.get_code_runner()
    local mapping = {}
    local runner = "code_runner"

    for _, lang_pack in pairs(language.get_packages()) do
        if lang_pack[runner] then
            for _, filetype in ipairs(lang_pack[runner]["filetypes"] or {}) do
                mapping[filetype] = lang_pack[runner]["command"]
            end
        end
    end

    return mapping
end

return language
