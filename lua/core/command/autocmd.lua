local api = require("utils.api")

local restore = vim.api.nvim_create_augroup("restore", { clear = true })

vim.api.nvim_create_autocmd({ "BufUnload" }, {
    pattern = "*",
    group = restore,
    command = "silent! mkview",
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = "*",
    group = restore,
    command = "silent! loadview",
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*" },
    group = restore,
    callback = function()
        if
            vim.fn.line("'\"") > 0
            and vim.fn.line("'\"") <= vim.fn.line("$")
        then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.fn.setpos(".", vim.fn.getpos("'\""))
            -- how do I center the buffer in a sane way??
            -- vim.cmd('normal zz')
            vim.cmd("silent! foldopen")
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = { "*" },
    group = restore,
    command = ("mksession! %s"):format(api.get_setting().get_session_path()),
    desc = "Each time you exit Neovim, save the session",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end,
})

if api.get_setting().is_auto_save() then
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        pattern = { "*" },
        callback = function()
            vim.cmd("silent! wall")
        end,
        nested = true,
    })
end

if api.get_setting().is_input_switch() then
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        pattern = { "*" },
        callback = function()
            local input_status = tonumber(vim.fn.system("fcitx5-remote"))
            if input_status == 2 then
                vim.fn.system("fcitx5-remote -c")
            end
        end,
    })
end

-- TODO: This seems to be a bug, in molecule, js files do not work smoothly with indentation
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "javascript", "typescript" },
    callback = function()
        local expand = vim.opt_local.expandtab:get()
        local shiftwidth  = vim.opt_local.shiftwidth:get()
        local tabstop  = vim.opt_local.tabstop:get()
        local softtabstop = vim.opt_local.softtabstop:get()

        vim.defer_fn(function()
            vim.opt_local.expandtab = expand
            vim.opt_local.shiftwidth = shiftwidth
            vim.opt_local.tabstop = tabstop
            vim.opt_local.softtabstop = softtabstop
        end, 100)
    end,
})
