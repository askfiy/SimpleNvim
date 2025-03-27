-- See: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins

local utils = require("utils")

local extras = {}

function extras.expand_builtins()
    local null_ls = require("null-ls")
    local dirname = utils.path.dirname(utils.path.filepath())

    for _, builtins_name in ipairs(utils.get_package_from_directory(dirname)) do
        local builtins_tool = utils.path.join(dirname, builtins_name)

        for _, package_name in
            ipairs(utils.get_package_from_directory(builtins_tool))
        do
            null_ls.builtins[builtins_name][package_name] =
                utils.relative_import(
                    ("./%s/%s"):format(builtins_name, package_name)
                )
        end
    end
end

return extras
