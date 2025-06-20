-- https://github.com/folke/lazy.nvim

local conf = require("conf")
local utils = require("utils")
local language = require("core.language")

local lazy = {}

function lazy.before_load()
    local lazy_install_path =
        utils.path.join(conf.get_lazy_install_path(), "lazy.nvim")

    if not vim.uv.fs_stat(lazy_install_path) then
        vim.fn.mkdir(lazy_install_path, "p")

        vim.notify(
            "Clone lazy.nvim ...",
            "INFO",
            { annote = "[SimpleNvim]", key = "[SimpleNvim]" }
        )

        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            lazy_install_path,
        })
    end

    vim.opt.runtimepath:prepend(lazy_install_path)
end

function lazy.load()
    lazy.module = require("lazy")

    local dirname =
        utils.path.dirname(utils.path.dirname(utils.path.filepath()))
    local packages = utils.get_package_from_directory(dirname, { "lazy" })

    local lazy_packages = vim.tbl_map(function(package_name)
        local pack = utils.relative_import("../" .. package_name)

        assert(
            pack.lazy,
            ("Package <%s> does not have a `lazy` attribute"):format(
                package_name
            )
        )

        pack.lazy.init = pack.lazy.init
            or function()
                if pack.register_maps then
                    pack.register_maps()
                end
            end

        pack.lazy.config = pack.lazy.config
            or function()
                if pack.before_load then
                    pack.before_load()
                end

                if pack.load then
                    pack.load()
                end

                if pack.after_load then
                    pack.after_load()
                end
            end

        return pack.lazy
    end, packages)

    for _, pack in ipairs(language.get_lazy_packages()) do
        table.insert(lazy_packages, pack)
    end

    lazy.module.setup(lazy_packages, {
        root = conf.get_lazy_install_path(),
        install = {
            colorscheme = { "default" },
        },
        ui = {
            border = conf.get_float_border("double"),
        },
        performance = {
            disabled_plugins = {
                -- "netrw",
                -- "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    })
end

function lazy.after_load()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>lh",
            rhs = ":Lazy<cr>",
            options = { silent = true },
            description = "Run Lazy command",
        },
        {
            mode = { "n" },
            lhs = "<leader>li",
            rhs = ":Lazy install<cr>",
            options = { silent = true },
            description = "Run Lazy install command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lu",
            rhs = ":Lazy update<cr>",
            options = { silent = true },
            description = "Run Lazy update command",
        },
        {
            mode = { "n" },
            lhs = "<leader>ls",
            rhs = ":Lazy sync<cr>",
            options = { silent = true },
            description = "Run Lazy sync command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lx",
            rhs = ":Lazy clean<cr>",
            options = { silent = true },
            description = "Run Lazy clean command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lc",
            rhs = ":Lazy check<cr>",
            options = { silent = true },
            description = "Run Lazy check command",
        },
        {
            mode = { "n" },
            lhs = "<leader>ll",
            rhs = ":Lazy log<cr>",
            options = { silent = true },
            description = "Run Lazy log command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lr",
            rhs = ":Lazy restore<cr>",
            options = { silent = true },
            description = "Run Lazy restore command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lp",
            rhs = ":Lazy profile<cr>",
            options = { silent = true },
            description = "Run Lazy profile command",
        },
        {
            mode = { "n" },
            lhs = "<leader>ld",
            rhs = ":Lazy debug<cr>",
            options = { silent = true },
            description = "Run Lazy debug command",
        },
        {
            mode = { "n" },
            lhs = "<leader>l?",
            rhs = ":Lazy help<cr>",
            options = { silent = true },
            description = "Run Lazy help command",
        },
    })
end

function lazy.enter()
    lazy.before_load()
    lazy.load()
    lazy.after_load()
end

return lazy
