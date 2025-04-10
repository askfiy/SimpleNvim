local utils = require("utils")

local lang_pack = {}

lang_pack.lazy = {
    {
        "Vimjas/vim-python-pep8-indent",
        ft = { "python" },
    },
}

lang_pack.mason = {
    ensure_installed = {
        "autopep8",
        "pylint",
        "debugpy",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "python",
        "requirements",
        "htmldjango",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "ruff", "jedi-language-server" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "autopep8",
        extra_args = {
            "-a",
            "--max-line-length=180",
        },
        condition = function()
            return true
        end,
    },
    diagnostics = {
        exe = "pylint",
        extra_args = {
            "--rcfile="
                .. utils.path.join(
                    utils.path.dirname(utils.path.filepath()),
                    "pylintrc"
                ),
        },
        condition = function()
            return false
        end,
    },
}

lang_pack.code_runner = {
    filetypes = { "python" },
    command = function()
        return ("python3 %s"):format(vim.fn.expand("%:p"))
    end,
}

return lang_pack
