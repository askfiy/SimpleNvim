-- https://github.com/williamboman/mason.nvim

local conf = require("conf")
local utils = require("utils")
local language = require("core.language")

local pack = {}

pack.lazy = {
    "williamboman/mason.nvim",
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "j-hui/fidget.nvim" },
    },
    event = { "VimEnter" },
}

function pack.before_load()
    pack.plugin = require("mason")
end

function pack.load()
    pack.plugin.setup({
        ui = {
            icons = {
                package_installed = "󰜛",
                package_pending = "󰄼",
                package_uninstalled = "󱌠",
            },
            border = conf.get_float_border("double"),
        },
        max_concurrent_installers = 20,
        install_root_dir = conf.get_mason_install_path(),
    })

    require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = true,
    })
end

function pack.after_load()
    -- Wait for the Mason data update to complete before downloading
    local registry = require("mason-registry")

    local refresh_lock =
        utils.path.join(vim.fn.stdpath("data"), "mason-refresh.lock")

    if not utils.path.exists(refresh_lock) then
        -- When opening it for the first time, refresh the package information first
        registry.refresh()
        vim.fn.writefile({ "locking" }, refresh_lock)
    else
        -- Update the package information when it is subsequently opened
        registry.update()
    end

    -- The information update is complete, and the required packages can be installed
    for _, package_name in ipairs(language.get_mason_packages({ "cspell" })) do
        if not registry.is_installed(package_name) then
            if
                not vim.tbl_contains(
                    registry.get_all_package_names(),
                    package_name
                )
            then
                vim.notify(
                    ("Invalid package name <%s>"):format(package_name),
                    "ERROR",
                    { annote = "[mason.nvim]", key = "[mason.nvim]" }
                )
            else
                registry.get_package(package_name):install()

                vim.notify(
                    ("Installing <%s>"):format(package_name),
                    "INFO",
                    { annote = "[mason.nvim]", key = "[mason.nvim]" }
                )
            end
        else
        end
    end
end

return pack
