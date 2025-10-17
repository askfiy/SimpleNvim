local conf = require("conf")
local utils = require("utils")

return {
    adapters = {
        python = {
            type = "executable",
            command = utils.path.join(
                conf.get_mason_install_path(),
                "packages",
                "debugpy",
                "venv",
                "bin",
                "python3"
            ),
            args = { "-m", "debugpy.adapter" },
            -- command = "python3",
            -- args = { "-m", "debugpy.adapter" },
        },
    },
    configurations = {
        python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = "python3",
                justMyCode = false,
            },
            {
                type = "python",
                request = "launch",
                name = "Launch Django",
                program = "manage.py",
                pythonPath = "python3",
                justMyCode = false,
                args = {
                    "runserver",
                    "127.0.0.1:8000",
                    "--noreload",
                },
            },
            {
                type = "python",
                request = "launch",
                name = "XYZ-Platform",
                module = "uvicorn",
                pythonPath = "python3",
                justMyCode = false,
                args = {
                    "src.main:backend_app",
                    "--host",
                    "0.0.0.0",
                    "--port",
                    "8100",
                },
            },
        },
    },
}
