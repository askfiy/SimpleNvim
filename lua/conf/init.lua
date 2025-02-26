local utils = require("utils")
local settings = require("conf.settings")

local conf = {}

function conf.get_colorscheme()
    return settings.colorscheme
end

function conf.is_enable_colorscheme(color_scheme)
    return settings.colorscheme == color_scheme
end

function conf.is_float_border()
    return settings.float_border
end

function conf.is_input_switch()
    return settings.input_switch
end

function conf.get_float_border(style)
    return conf.is_float_border() and style or "none"
end

function conf.code_spell_is_open()
    return settings.code.spell
end

function conf.switch_code_spell()
    settings.code.spell = not settings.code.spell
end

function conf.inlay_hint_is_open()
    return settings.code.inlay_hint
end

function conf.language_injections_is_open()
    return settings.code.language_injections
end

function conf.is_enable_icons_by_group(group_name)
    return settings.icons[group_name].enable
end

function conf.get_database()
    local env_dbs = os.getenv("DB")
    local dbs = settings.database

    if env_dbs and type(env_dbs) == "string" then
        for _, db in ipairs(vim.json.decode(env_dbs)) do
            table.insert(dbs, db)
        end
    end

    return dbs
end

function conf.get_icons_by_group(group_name, has_suffix_space)
    local group = settings.icons[group_name].groups

    if has_suffix_space then
        for name, icon in pairs(group) do
            group[name] = ("%s "):format(icon)
        end
    end

    return group
end

function conf.get_session_path()
    return utils.path.join(vim.fn.stdpath("data"), "session.vim")
end

function conf.get_lazy_install_path()
    return utils.path.join(vim.fn.stdpath("data"), "packages")
end

function conf.get_mason_install_path()
    return utils.path.join(vim.fn.stdpath("data"), "mason")
end

function conf.get_cspell_conf_path()
    return utils.path.join(vim.fn.stdpath("config"), "spell", "cspell.json")
end

return conf
