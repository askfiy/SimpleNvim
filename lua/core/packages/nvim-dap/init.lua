-- https://github.com/mfussenegger/nvim-dap

---@diagnostic disable: inject-field

local utils = require("utils")
local helper = require("core.packages.nvim-dap.helper")
local language = require("core.language")

local pack = {}

pack.lazy = {
    "mfussenegger/nvim-dap",
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        { "rcarriga/nvim-dap-ui", dependencies = "nvim-neotest/nvim-nio" },
    },
    lazy = true,
}

function pack.before_load()
    pack.plugin = require("dap")
end

function pack.load()
    helper.load()

    local dap_packages = language.get_dap_packages()
    pack.plugin.adapters = dap_packages.adapters
    pack.plugin.configurations = dap_packages.configurations
end

function pack.after_load() end

function pack.register_maps()
    utils.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>db",
            rhs = function()
                helper.update_by_workspace()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").toggle_breakpoint()
            end,
            options = { silent = true },
            description = "Mark or delete breakpoints",
        },
        {
            mode = { "n" },
            lhs = "<leader>dc",
            rhs = function()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").clear_breakpoints()
            end,
            options = { silent = true },
            description = "Clear breakpoints in the current buffer",
        },
        {
            mode = { "n" },
            lhs = "<F5>",
            rhs = function()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").continue()
            end,
            options = { silent = true },
            description = "Enable debugging or jump to the next breakpoint",
        },
        {
            mode = { "n" },
            lhs = "<F6>",
            rhs = function()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").step_into()
            end,
            options = { silent = true },
            description = "Step into",
        },
        {
            mode = { "n" },
            lhs = "<F7>",
            rhs = function()
                ---@diagnostic disable-next-line: missing-parameter, undefined-field
                require("dap").step_over()
            end,
            options = { silent = true },
            description = "Step over",
        },
        {
            mode = { "n" },
            lhs = "<F8>",
            rhs = function()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").step_out()
            end,
            options = { silent = true },
            description = "Step out",
        },
        {
            mode = { "n" },
            lhs = "<F9>",
            rhs = function()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").run_last()
            end,
            options = { silent = true },
            description = "Rerun debug",
        },
        {
            mode = { "n" },
            lhs = "<F10>",
            rhs = function()
                ---@diagnostic disable-next-line: undefined-field
                require("dap").terminate()
            end,
            options = { silent = true },
            description = "Close debug",
        },
        --- dapui
        {
            mode = { "n" },
            lhs = "<leader>du",
            rhs = function()
                ---@diagnostic disable-next-line: missing-parameter
                require("dapui").toggle()
            end,
            options = { silent = true },
            description = "Toggle debug ui",
        },
        {
            mode = { "n" },
            lhs = "<leader>de",
            rhs = function()
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if
                        vim.api.nvim_buf_get_option(bufnr, "filetype")
                        == "dapui_hover"
                    then
                        ---@diagnostic disable-next-line: missing-parameter
                        require("dapui").eval()
                        return
                    end
                end
                ---@diagnostic disable-next-line: missing-parameter
                require("dapui").eval(vim.fn.input("Enter debug expression: "))
            end,
            options = { silent = true },
            description = "Execute debug expressions",
        },
    })
end

return pack
