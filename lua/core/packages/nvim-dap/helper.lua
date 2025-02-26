---@diagnostic disable: undefined-field

local utils = require("utils")

local helper = {}

function helper.load()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
        layouts = {
            {
                elements = {
                    -- elements can be strings or table with id and size keys.
                    "scopes",
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 30,
                position = "right",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 10,
                position = "bottom",
            },
        },
    })

    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

function helper.update_by_workspace()
    local config_path = utils.path.join(vim.fn.getcwd(), "workspace.json")

    if not (config_path and utils.path.exists(config_path)) then
        return
    end

    local content = table.concat(vim.fn.readfile(config_path), "\n")

    content = vim.json.decode(content)

    local configuration = content["debug"]

    if not configuration or vim.tbl_isempty(configuration) then
        return
    end

    local configurations = require("dap").configurations[configuration["type"]]

    if type(configurations) == "table" then
        table.insert(configurations, configuration)
    else
        require("dap").configurations[configuration["type"]] = configuration
    end
end

return helper
