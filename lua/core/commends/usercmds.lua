local utils = require("utils")

vim.api.nvim_create_user_command("BufferDelete", function(ctx)
    local file_exist = vim.fn.filereadable(vim.fn.expand("%p"))
    local modified = vim.api.nvim_buf_get_option(0, "modified")

    if 0 == file_exist and modified then
        local user_choice = vim.fn.input(
            "The file is not saved, whether to force delete? Press enter or input [y/n]:"
        )
        if user_choice == "y" or user_choice:len() == 0 then
            vim.cmd("bd!")
        end
        return
    end

    local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"

    vim.cmd(
        force and "bd!"
            or ("bp | bd! %s"):format(vim.api.nvim_get_current_buf())
    )
end, { desc = "Delete the current Buffer while maintaining the window layout" })

vim.api.nvim_create_user_command("UserConfigFile", function(ctx)
    local user_config_file_path =
        utils.path.join(vim.fn.stdpath("config"), "lua", "conf", "settings.lua")
    vim.cmd((":e %s"):format(user_config_file_path))
end, { desc = "Open user config file" })

vim.api.nvim_create_user_command("UserSpellFile", function(ctx)
    local spell_file_path =
        utils.path.join(vim.fn.stdpath("config"), "spell", "cspell.json")
    vim.cmd((":e %s"):format(spell_file_path))
end, { desc = "Open user spell file" })

vim.api.nvim_create_user_command("UserSnippetFile", function(ctx)
    local snippet_file_name = vim.opt.filetype:get() .. ".json"
    local snippet_file_path =
        utils.path.join(vim.fn.stdpath("config"), "snippets", snippet_file_name)
    vim.cmd((":e %s"):format(snippet_file_path))
end, { desc = "Open snippet file from current filetype" })

vim.api.nvim_create_user_command("UserWorkspace", function(ctx)
    local filepath = utils.path.join(vim.fn.expand("%:p:h"), "workspace.json")
    if not utils.path.exists(filepath) then
        vim.fn.writefile({
            vim.json.encode({
                execute = "",
                debug = {},
            }),
        }, filepath)
    end

    vim.cmd(("e %s"):format(filepath))
end, { desc = "Create or open workspace file" })
