local conf = require("conf")

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
    command = ("mksession! %s"):format(conf.get_session_path()),
    desc = "Each time you exit Neovim, save the session",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = { "*" },
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
    end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd("silent! wall")
    end,
    nested = true,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        if vim.bo.commentstring == "# %s" then
            vim.opt_local.smartindent = false
        end
    end,
})

if conf.is_input_switch() then
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        pattern = { "*" },
        callback = function()
            if vim.fn.has("mac") then
                local input_status = vim.fn.system("im-select")
                if input_status:match("com.apple.keylayout.ABC") == nil then
                    vim.fn.system("im-select com.apple.keylayout.ABC") -- 切换到英文输入法
                end
            elseif vim.fn.has("unix") then
                local input_status = tonumber(vim.fn.system("fcitx5-remote"))
                if input_status == 2 then
                    vim.fn.system("fcitx5-remote -c")
                end
            end
        end,
    })
end
