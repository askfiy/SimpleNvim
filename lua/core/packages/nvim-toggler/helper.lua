local helper = {}

local base_inverses = {
    ["+"] = "-",
    [">"] = "<",
    ["!="] = "==",
    ["on"] = "off",
    ["in"] = "out",
    ["no"] = "yes",
    ["to"] = "from",
    ["up"] = "down",
    ["top"] = "bottom",
    ["true"] = "false",
    ["open"] = "close",
    ["next"] = "prev",
    ["left"] = "right",
    ["show"] = "hidden",
    ["before"] = "after",
    ["enable"] = "disable",
    ["enabled"] = "disabled",
    ["resolve"] = "reject",
    ["relative"] = "absolute",
}

local function title(s)
    return (
        s:gsub("(%a)([%w_']*)", function(f, r)
            return f:upper() .. r:lower()
        end)
    )
end

function helper.get_inverses()
    local inverses = vim.deepcopy(base_inverses)

    for word1, word2 in pairs(base_inverses) do
        inverses[title(word1)] = title(word2)
        inverses[word1:upper()] = word2:upper()
    end

    return inverses
end

return helper
