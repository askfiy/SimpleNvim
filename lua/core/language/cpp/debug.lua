-- https://github.com/Microsoft/vscode-cpptools

local conf = require("conf")
local utils = require("utils")

-- U need install: gdb
-- example ArchLinux:
-- yay -S gdb

local configuration = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            local source_path = vim.fn.expand("%:p")
            local binary_path = vim.fn.expand("%:p:r")
            local command = ("gcc -fdiagnostics-color=always -g %s -o %s"):format(
                source_path,
                binary_path
            )
            vim.fn.jobstart(command)
            return binary_path
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
}

return {
    adapters = {
        cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = utils.path.join(
                conf.get_mason_install_path(),
                "packages",
                "cpptools",
                "extension",
                "debugAdapters",
                "bin",
                "OpenDebugAD7"
            ),
            options = {
                datached = false,
            },
        },
    },
    configurations = {
        c = vim.deepcopy(configuration),
        cpp = vim.deepcopy(configuration),
    },
}
