local conf = require("conf")
local utils = require("utils")
local language = require("core.language")

local runner = language.get_code_runner()

local helper = {}

local regex_error_jumps = {
    c = "(.+%.c):(%d+):(%d+)",
    go = "(.+%.go):(%d+):(%d+)",
    cpp = "(.+%.cpp):(%d+):(%d+)",
    rust = " *%-*>? ?(.+.%rs):(%d+):(%d+)",
    python = '.*"(.+%.py)".*line (%d+).*',
    lua = "l?u?a?:? ?(.+%.lua):(%d+)",
}

local function terminal_cmd(command)
    local ok, tree_api = pcall(require, "nvim-tree.api")

    if not ok then
        return vim.cmd(command)
    end

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufnr, "filetype") == "NvimTree" then
            tree_api.tree.toggle({ focus = false })
            vim.cmd(command)
            tree_api.tree.toggle({ focus = false })
            return
        end
    end

    vim.cmd(command)
end

local function create_float_term()
    return helper.terminal:new({
        hidden = true,
        count = 120,
        direction = "float",
        float_opts = {
            border = conf.get_float_border("double"),
        },
        on_open = function(term)
            vim.defer_fn(function()
                vim.cmd("startinsert")
            end, 0)

            utils.map.register({
                mode = { "t", "n" },
                lhs = "<esc>",
                rhs = function()
                    local current_mode = vim.fn.mode()
                    if current_mode == "t" then
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes(
                                "<C-\\><C-n>",
                                true,
                                false,
                                true
                            ),
                            "n",
                            true
                        )
                    elseif current_mode == "n" then
                        vim.cmd("close")
                    end
                end,
                options = { silent = true, buffer = term.bufnr },
                description = "Escape float terminal",
            })
        end,
    })
end

local function create_lazy_term()
    return helper.terminal:new({
        cmd = "lazygit",
        count = 130,
        hidden = true,
        direction = "float",
        float_opts = {
            border = conf.get_float_border("double"),
        },
        on_open = function(term)
            vim.defer_fn(function()
                vim.cmd("startinsert")
            end, 0)

            utils.map.register({
                mode = { "i" },
                lhs = "q",
                rhs = "<cmd>close<cr>",
                options = { silent = true, buffer = term.bufnr },
                description = "Escape lazygit terminal",
            })
            utils.map.unregister({ "t" }, "<esc>")
        end,
        on_close = function(term)
            utils.map.register({
                mode = { "t" },
                lhs = "<esc>",
                rhs = "<c-\\><c-n>",
                options = { silent = true },
                description = "Escape terminal insert mode",
            })
        end,
    })
end

local function jump_err_file()
    local first_file_info = {}

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

        if vim.tbl_contains(vim.tbl_keys(regex_error_jumps), filetype) then
            local rule = regex_error_jumps[filetype]
            local line = vim.api.nvim_get_current_line()
            local filepath, row, col = line:match(rule)
            local current_file = vim.api.nvim_buf_get_name(bufnr)

            if vim.tbl_isempty(first_file_info) then
                first_file_info.filepath = filepath
                first_file_info.row = row
                first_file_info.col = col
            end

            if
                vim.fn.fnamemodify(filepath, ":t")
                == vim.fn.fnamemodify(current_file, ":t")
            then
                local win = vim.fn.win_findbuf(bufnr)[1]

                if win == nil or not vim.api.nvim_win_is_valid(win) then
                    break
                end

                vim.api.nvim_set_current_win(win)
                vim.api.nvim_win_set_cursor(
                    0,
                    { tonumber(row or 0), tonumber(col or 0) }
                )
                return
            else
                vim.api.nvim_echo(
                    { { "Can't goto err line", "WarningMsg" } },
                    false,
                    {}
                )
            end
        end
    end

    if not vim.tbl_isempty(first_file_info) then
        vim.cmd(":wincmd k")
        vim.cmd("e " .. first_file_info.filepath)
        vim.api.nvim_win_set_cursor(0, {
            tonumber(first_file_info.row or 0),
            tonumber(first_file_info.col or 0),
        })
    end
end

local function code_runner(ctx)
    local config_path = utils.path.join(vim.fn.getcwd(), "workspace.json")

    local execute = ""
    local count = vim.api.nvim_eval("v:count1")
    local command = [[exe %d."TermExec cmd='%s' go_back=0"]]

    if config_path and utils.path.exists(config_path) then
        local content = table.concat(vim.fn.readfile(config_path), "\n")
        execute = vim.json.decode(content)["execute"]
    else
        local callback = runner[vim.opt.filetype:get()]
        if callback then
            execute = callback()
        end
    end

    if execute:len() > 0 then
        if execute:sub(1, 1) == ":" then
            vim.cmd(execute)
        else
            terminal_cmd(command:format(count, execute))
        end
    else
        vim.notify(
            "Not found code runner conf",
            "WARN",
            { annote = "[SimpleNvim]", key = "[SimpleNvim]" }
        )
    end
end

function helper.load()
    helper.terminal = require("toggleterm.terminal").Terminal

    helper.lazy_term = create_lazy_term()
    helper.float_term = create_float_term()
    vim.api.nvim_create_user_command(
        "CodeRunner",
        code_runner,
        { desc = "Code Run in toggleterm" }
    )
end

function helper.on_open(term)
    vim.wo.spell = false
    vim.wo.winfixbuf = true

    utils.map.register({
        mode = { "t" },
        lhs = "<esc>",
        rhs = "<c-\\><c-n>",
        options = { silent = true, buffer = term.bufnr },
        description = "Escape terminal insert mode",
    })

    utils.map.register({
        mode = { "n" },
        lhs = "gf",
        rhs = jump_err_file,
        options = { silent = true, buffer = term.bufnr },
        description = "Quick jump to err file",
    })
end

function helper.switch_float_term()
    helper.float_term:toggle()
end

function helper.switch_lazy_term()
    helper.lazy_term:toggle()
end

function helper.switch_bottom_term()
    local count = vim.api.nvim_eval("v:count1")
    terminal_cmd((("exe %d.'ToggleTerm'"):format(count)))
end

function helper.switch_all_term()
    terminal_cmd("ToggleTermToggleAll")
end

return helper
