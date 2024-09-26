-- author: askfiy

require("core.setting")
require("core.mapping")
require("core.command")
require("core.depends")

-- neovide settings
if vim.g.neovide then
    vim.o.guifont = "BlexMono Nerd Font:h9"

    vim.opt.linespace = 0
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_refresh_rate = 165

    vim.g.neovide_confirm_quit = false

    vim.g.neovide_cursor_animation_length = 0.15
    vim.g.neovide_cursor_trail_size = 0.6

    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true

    vim.g.neovide_cursor_vfx_mode = "torpedo"
    vim.g.neovide_profiler = false

    vim.g.neovide_scale_factor = 1.0

    -- keymap
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end

    vim.keymap.set({ "n", "i", "t" }, "<C-=>", function()
        change_scale_factor(1.25)
    end)

    vim.keymap.set({ "n", "i", "t" }, "<C-->", function()
        change_scale_factor(1 / 1.25)
    end)

    vim.keymap.set({ "c", "t", "i" }, "<C-V>", "<C-R>+") -- Paste command mode
end
