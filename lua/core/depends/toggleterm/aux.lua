local api = require("utils.api")

local M = {}

function M.init(terminal)
    M.float_terminal = terminal:new({
        hidden = true,
        count = 120,
        direction = "float",
        float_opts = {
            border = api.get_setting().get_float_border("double"),
        },
        on_open = function(term)
            vim.cmd("startinsert")
            api.map.register({
                mode = { "t" },
                lhs = "<esc>",
                rhs = "<c-\\><c-n><cmd>close<cr>",
                options = { silent = true, buffer = term.bufnr },
                description = "Escape float terminal",
            })
        end,
    })

    M.lazygit_terminal = terminal:new({
        cmd = "lazygit",
        count = 130,
        hidden = true,
        direction = "float",
        float_opts = {
            border = api.get_setting().get_float_border("double"),
        },
        on_open = function(term)
            vim.cmd("startinsert")
            api.map.register({
                mode = { "i" },
                lhs = "q",
                rhs = "<cmd>close<cr>",
                options = { silent = true, buffer = term.bufnr },
                description = "Escape lazygit terminal",
            })
            api.map.unregister({ "t" }, "<esc>")
        end,
        on_close = function(term)
            api.map.register({
                mode = { "t" },
                lhs = "<esc>",
                rhs = "<c-\\><c-n>",
                options = { silent = true },
                description = "Escape terminal insert mode",
            })
        end,
    })
end

----------------------------------

function M.gf_goto_err_file(term)
    local gf_filetype_rule_mapping = {
        c = "(.+%.c):(%d+):(%d+)",
        go = "(.+%.go):(%d+):(%d+)",
        cpp = "(.+%.cpp):(%d+):(%d+)",
        rust = " *%-*>? ?(.+.%rs):(%d+):(%d+)",
        python = '.*"(.+%.py)".*line (%d+).*',
        lua = "l?u?a?:? ?(.+%.lua):(%d+)",
    }

    api.map.register({
        mode = { "n" },
        lhs = "gf",
        rhs = function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                if
                    vim.tbl_contains(
                        vim.tbl_keys(gf_filetype_rule_mapping),
                        filetype
                    )
                then
                    local rule = gf_filetype_rule_mapping[filetype]
                    local line = vim.api.nvim_get_current_line()
                    local filepath, row, col = line:match(rule)
                    if filepath then
                        vim.cmd(":wincmd k")
                        vim.cmd("e " .. filepath)
                        vim.api.nvim_win_set_cursor(
                            0,
                            { tonumber(row or 0), tonumber(col or 0) }
                        )
                    else
                        vim.api.nvim_echo(
                            { { "Can't goto err line", "WarningMsg" } },
                            false,
                            {}
                        )
                    end
                    break
                end
            end
        end,
        options = { silent = true, buffer = term.bufnr },
        description = "quick go to err file",
    })
end

----------------------------------

function M.on_open(term)
    vim.wo.spell = false
    vim.wo.winfixbuf = true

    api.map.register({
        mode = { "t" },
        lhs = "<esc>",
        rhs = "<c-\\><c-n>",
        options = { silent = true, buffer = term.bufnr },
        description = "Escape terminal insert mode",
    })

    M.gf_goto_err_file(term)
end

----------------------------------

function M.run_terminal_command(command)
    local tree = require("nvim-tree.api").tree
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufnr, "filetype") == "NvimTree" then
            tree.toggle({ focus = false })
            vim.cmd(command)
            tree.toggle({ focus = false })
            return
        end
    end
    vim.cmd(command)
end

function M.toggle_float_terminl()
    M.float_terminal:toggle()
end

function M.toggle_lazygit_terminl()
    M.lazygit_terminal:toggle()
end

function M.toggle_all_terminal()
    M.run_terminal_command("ToggleTermToggleAll")
end

function M.toggle_bottom_terminal()
    local count = vim.api.nvim_eval("v:count1")
    M.run_terminal_command(("exe %d.'ToggleTerm'"):format(count))
end

return M
