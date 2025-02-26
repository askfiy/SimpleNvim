-- https://github.com/numToStr/Comment.nvim

local language = require("core.language")

local pack = {}

pack.lazy = {
    "numToStr/Comment.nvim",
    dependencies = {
        { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    event = { "VeryLazy" },
}

function pack.before_load()
    pack.plugin = require("Comment")
end

function pack.load()
    pack.plugin.setup({
        opleader = {
            line = "gc",
            block = "gb",
        },
        toggler = {
            line = "gcc",
            block = "gcb",
        },
        extra = {
            above = "gck",
            below = "gcj",
            eol = "gca",
        },
        pre_hook = require(
            "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook(),
    })
end

function pack.after_load()
    local filetype = require("Comment.ft")

    filetype({ "less", "sass" }, filetype.get("css"))

    if language.has("python") then
        filetype.set("python", { "# %s", '"""\n%s\n"""' })
    end
end

return pack
