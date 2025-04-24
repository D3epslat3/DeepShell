local M = {}

local function get_shell_base_dir()
    return "/usr/local/share/deepshell/"
end

-- Carrega configurações do arquivo Lua
function M.load_config()
    local default_config = {
        shell_name = "DeepShell",
        version = "1.0.0",
        prompt_style = "fancy",
        history_file = os.getenv("HOME") .. "/.deepshell_history",
        colors = {
            prompt_user = "green",
            prompt_host = "blue",
            prompt_dir = "cyan",
            error = "red",
            success = "green"
        }
    }

    local config_path = get_shell_base_dir() .. "config.lua"
    local success, config = pcall(dofile, config_path)
    if not success then
        print("Aviso: Erro ao carregar config.lua, usando configurações padrão")
        return default_config
    end

    return config
end

M.CONFIG = M.load_config()

return M