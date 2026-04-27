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
    pack.plugin = require("nvim-treesitter")
end

function pack.load()
    pack.plugin.setup()
    require("nvim-treesitter").install(
        language.get_treesitter_packages({
            "xml",
            "http",
            "regex",
            "git_config",
            "git_rebase",
            "gitcommit",
            "gitignore",
            "dockerfile",
        })
    )
end

function pack.after_load() end

return pack
