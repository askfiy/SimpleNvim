local map = {}

function map.register(action)
    action.options.desc = action.description
    vim.keymap.set(action.mode, action.lhs, action.rhs, action.options)
end

function map.unregister(mode, lhs, opts)
    vim.keymap.del(mode, lhs, opts)
end

function map.bulk_register(actions)
    for _, action in pairs(actions) do
        map.register(action)
    end
end

return map
