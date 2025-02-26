local lang_pack = {}

lang_pack.lazy = {}

lang_pack.mason = {
    ensure_installed = {
        "clang-format",
        "cpptools",
    },
}

lang_pack.treesitter = {
    ensure_installed = {
        "c",
        "cpp",
        "cmake",
    },
    disable_highlight = false,
}

lang_pack.lspconfig = {
    server = { "clangd" },
}

lang_pack.null_ls = {
    formatting = {
        exe = "clang_format",
        extra_args = {
            "--style",
            "{IndentWidth: 4}",
        },
        condition = function()
            return true
        end,
    },
}

lang_pack.code_runner = {
    filetypes = { "c", "cpp" },
    command = function()
        local source_path = vim.fn.expand("%:p")
        local binary_path = vim.fn.expand("%:p:r")
        local command = ("gcc -fdiagnostics-color=always -g %s -o %s"):format(
            source_path,
            binary_path
        )
        vim.fn.jobstart(command)
        vim.cmd("sleep 200m")
        return binary_path
    end,
}

return lang_pack
