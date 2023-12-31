local M = {}

local space_rand = {}

function M.register(map)
    map.options.desc = map.description

    if type(map.rhs) == "function" or map.options.buffer then
        vim.keymap.set(map.mode, map.lhs, map.rhs, map.options)
        return
    end

    for _, mode in ipairs(map.mode) do
        vim.api.nvim_set_keymap(mode, map.lhs, map.rhs, map.options)
    end
end

function M.unregister(mode, lhs, opts)
    vim.keymap.del(mode, lhs, opts)
end

function M.bulk_register(maps)
    for _, map in pairs(maps) do
        M.register(map)
    end
end

function M.register_menu(group, mode, description, command)
    if "---" == description then
        local rand = math.random(1, 100)
        while true do
            if not vim.tbl_contains(space_rand, rand) then
                table.insert(space_rand, rand)
                break
            else
                rand = math.random(1, 100)
            end
        end

        description = ("-%d-"):format(rand)
    end
    local cmd = ("%s.%s %s"):format(
        group,
        description:gsub(" ", "\\ ") or "",
        command or ""
    )
    vim.cmd(([[%snoremenu %s]]):format(mode, cmd))
end

function M.bulk_register_menu(group, maps)
    for _, map in pairs(maps) do
        M.register_menu(group, map.mode, map.description, map.command)
    end
end

return M
