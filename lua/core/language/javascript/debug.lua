local conf = require("conf")
local utils = require("utils")

return {
    adapters = {
        ["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                -- 💀 Make sure to update this path to point to your installation
                args = {
                    utils.path.join(
                        conf.get_mason_install_path(),
                        "packages",
                        "js-debug-adapter",
                        "js-debug",
                        "src",
                        "dapDebugServer.js"
                    ),
                    "${port}",
                },
            },
        },
    },
    configurations = {
        typescript = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
                runtimeExecutable = "ts-node",
                skipFiles = { "<node_internals>/**", "node_modules/**" },
                resolveSourceMapLocations = {
                    "${workspaceFolder}/dist/**/*.js",
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
            },
        },
        javascript = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
                runtimeExecutable = "node",
                skipFiles = { "<node_internals>/**", "node_modules/**" },
                resolveSourceMapLocations = {
                    "${workspaceFolder}/dist/**/*.js",
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
            },
        },
    },
}
