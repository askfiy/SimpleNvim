require("conf.perferences")

return {
    -- ui
    colorscheme = "killer-queen",
    float_border = true,
    -- control
    input_switch = true,
    -- code
    code = {
        spell = true,
        inlay_hint = false,
        language_injections = true,
    },
    -- icons
    icons = {
        diagnostic = {
            enable = false,
            groups = {
                Error = "",
                Warn = "",
                Info = "󰋽",
                Hint = "󰋽",
            },
        },
        kind = {
            enable = true,
            groups = {
                Default = "",
                String = "",
                Number = "󰎠",
                Boolean = "󰺟",
                Array = "",
                Object = "",
                Key = "󱕵",
                Null = "",
                Text = "",
                Method = "",
                Function = "󰊕",
                Constructor = "󱒖",
                Namespace = "",
                Field = "󰽐",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "󰚯",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "󰅴",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            },
        },
    },
    -- database
    database = {
        {
            name = "mysql(example)",
            url = "mysql://username:password@localhost:3306/db?protocol=tcp",
        },
        {
            name = "postgresql(example)",
            url = "postgres://username:password@localhost:5432/db",
        },
        {
            name = "sqlite3(example)",
            url = "sqlite3:" .. vim.fn.fnamemodify("DATABASE.db", ":p"),
        },
    },
}
