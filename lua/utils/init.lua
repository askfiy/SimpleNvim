local utils = {}

utils.lsp = require("utils.lsp")
utils.map = require("utils.map")
utils.path = require("utils.path")

function utils.special_filetypes(filetypes)
    return vim.tbl_extend("force", {
        "qf",
        "help",
        "dbui",
        "lazy",
        "mason",
        "aerial",
        "notify",
        "lspinfo",
        "NvimTree",
        "toggleterm",
        "spectre_panel",
        "TelescopePrompt",
    }, filetypes or {})
end

function utils.get_package_from_directory(directory_path, ignore_packages)
    ignore_packages = ignore_packages or {}
    table.insert(ignore_packages, "init")

    local packages = vim.tbl_map(function(package_abspath)
        return vim.fn.fnamemodify(package_abspath, ":t:r")
    end, vim.fn.globpath(directory_path, "*", false, true))

    return vim.tbl_filter(function(package_name)
        return not vim.tbl_contains(ignore_packages, package_name)
    end, packages)
end

function utils.relative_import(path)
    if not (path:sub(1, 2) == "./" or path:sub(1, 3) == "../") then
        return require(path)
    end

    local root_path = table.concat(
        vim.iter({ vim.fn.stdpath("config"), "lua" }):flatten():totable(),
        "/"
    )

    local current_file = debug.getinfo(2, "S").source:sub(2)

    if current_file == "[C]" then
        current_file = debug.getinfo(3, "S").source:sub(2)
    end

    local current_dir = current_file:match("(.*/)")

    local resolved_path = current_dir .. path

    local path_parts = { "" }

    for part in resolved_path:gmatch("[^/]+") do
        if part == ".." then
            table.remove(path_parts)
        elseif part ~= "." and part ~= "" then
            table.insert(path_parts, part)
        end
    end

    local final_path = table.concat(path_parts, "/")
    local relative_path = final_path:gsub("^" .. root_path .. "/", "")
    return require(relative_path)
end

return utils
