local api = require("utils.api")

--- basic settings ---
require("conf.config")
require("conf.preference")
----------------------

local M = {}

function M.is_auto_save()
    return api.get_config()["auto_save"]
end

function M.is_input_switch()
    return api.get_config()["input_switch"]
end

function M.is_code_spell_switch()
    return api.get_config()["spell"]["switch"]
end

function M.is_code_spell_display_hint()
    return api.get_config()["spell"]["display_hint"]
end

function M.is_float_border()
    return api.get_config()["float_border"]
end

function M.is_transparent_background()
    return api.get_config()["transparent_background"]
end

function M.is_lspconfig_inlay_hint()
    return api.get_config()["lspconfig"]["inlay_hint"]
end

function M.is_lspconfig_semantic_token()
    return api.get_config()["lspconfig"]["semantic_token"]
end

function M.is_enable_icon_groups(groups_name)
    return api.get_config()["icon"][groups_name]["enable"]
end

function M.is_language_injections()
    return api.get_config()["language_injections"]
end

function M.is_enable_colorscheme(colorscheme)
    return colorscheme == api.get_config()["colorscheme"]
end

function M.get_database()
    return api.get_config()["database"]
end

-----------------------------------------------------------------------------------
function M.get_float_border(style)
    return M.is_float_border() and style or "none"
end

function M.get_icon_groups(groups_name, has_suffix_space)
    local icon = vim.deepcopy(api.get_config()["icon"][groups_name]["groups"])

    if has_suffix_space then
        for name, font in pairs(icon) do
            icon[name] = ("%s "):format(font)
        end
    end

    return icon
end

-----------------------------------------------------------------------------------

function M.get_depend_base_path()
    return api.path.join("core", "depends")
end

function M.get_mason_install_path()
    return api.path.join(vim.fn.stdpath("data"), "mason")
end

function M.get_depends_install_path()
    return api.path.join(vim.fn.stdpath("data"), "depends")
end

function M.get_session_path()
    return api.path.join(vim.fn.stdpath("data"), "session.vim")
end

function M.get_cspell_conf_path()
    return api.path.join(vim.fn.stdpath("config"), "spell", "cspell.json")
end

return M
