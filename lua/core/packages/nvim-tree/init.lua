-- https://github.com/nvim-tree/nvim-tree.lua

local conf = require("conf")
local utils = require("utils")
local helper = require("core.packages.nvim-tree.helper")

local pack = {}

pack.lazy = {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
}

function pack.before_load()
    pack.plugin = require("nvim-tree")
end

function pack.load()
    local icons = conf.get_icons_by_group("diagnostic", true)

    pack.plugin.setup({
        disable_netrw = false,
        hijack_netrw = false,
        hijack_cursor = true,
        update_cwd = true,
        reload_on_bufenter = true,
        auto_reload_on_write = true,
        on_attach = helper.on_attach,
        notify = {
            threshold = vim.log.levels.WARN,
        },
        update_focused_file = {
            enable = true,
            update_cwd = false,
        },
        view = {
            side = "left",
            width = 30,
            signcolumn = "yes",
        },
        diagnostics = {
            enable = false,
            show_on_dirs = true,
            icons = {
                hint = icons.Hint,
                info = icons.Info,
                warning = icons.Warn,
                error = icons.Error,
            },
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = true,
                restrict_above_cwd = false,
            },
            open_file = {
                resize_window = false,
                window_picker = {
                    enable = true,
                },
            },
        },
        trash = {
            cmd = "trash",
            require_confirm = true,
        },
        filters = {
            dotfiles = false,
            custom = { "node_modules", "\\.cache", "__pycache__" },
            exclude = {},
        },
        renderer = {
            add_trailing = true,
            highlight_git = true,
            root_folder_label = false,
            highlight_opened_files = "none",
            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = false,
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "凜",
                        untracked = "",
                        deleted = "",
                        ignored = "",
                    },
                    folder = {
                        arrow_open = "",
                        arrow_closed = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                },
            },
        },
    })
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>1",
            rhs = function()
                require("nvim-tree.api").tree.toggle({
                    find_file = true,
                    focus = true,
                })
            end,
            options = { silent = true },
            description = "Open File Explorer",
        },
    })
end

return pack
