-- https://github.com/nvim-treesitter/nvim-treesitter

local language = require("core.language")

local pack = {}

pack.lazy = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "windwp/nvim-ts-autotag" },
    },
    event = { "UIEnter" },
}

function pack.before_load()
    pack.plugin = require("nvim-treesitter.configs")
end

function pack.load()
    require("nvim-treesitter.install").prefer_git = true

    pack.plugin.setup({
        ensure_installed = language.get_treesitter_packages({
            "xml",
            "http",
            "regex",
            "git_config",
            "git_rebase",
            "gitcommit",
            "gitignore",
            "dockerfile",
        }),
        ignore_install = {},
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = language.get_treesitter_disabled_highlight(),
        },
        indent = {
            enable = false,
        },
        -- incremental selection
        incremental_selection = {
            enable = false,
            keymaps = {
                init_selection = "<cr>",
                node_incremental = "<cr>",
                node_decremental = "<bs>",
                scope_incremental = "<tab>",
            },
        },
        -- nvim-ts-autotag
        autotag = {
            enable = true,
        },
    })
end

function pack.after_load() end

return pack
