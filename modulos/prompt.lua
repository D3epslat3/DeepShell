local utils = require("modulos.utils")
local configs = require("modulos.configs")

local M = {}

-- Função para verificar se é root
function M.is_root()
    return os.getenv("USER") == "root" or os.getenv("SUDO_USER")
end

-- Função para obter informações do git (se disponível)
function M.get_git_info()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if handle then
        local branch = handle:read("*a"):gsub("\n", "")
        handle:close()
        if branch ~= "" then
            return " (" .. branch .. ")"
        end
    end
    return ""
end

-- Função para formatar o path
function M.format_path(path)
    local home = os.getenv("HOME")
    local config = configs.CONFIG
    
    -- Substitui home por ~
    if path:sub(1, #home) == home then
        path = config.symbols.home_symbol .. path:sub(#home + 1)
    end
    
    return path
end

function M.get_prompt()
    local config = configs.CONFIG
    local prompt_parts = {}
    
    -- Obtém informações básicas
    local user = os.getenv("USER") or "user"
    local hostname = io.popen("hostname"):read("*l") or "host"
    local pwd = io.popen("pwd"):read("*l") or "~"
    pwd = M.format_path(pwd)
    
    -- Verifica se é root
    local is_root = M.is_root()
    local prompt_symbol = is_root and config.symbols.root_prompt or config.symbols.user_prompt
    local user_color = is_root and "root" or "prompt_user"
    
    -- Monta o prompt baseado nas configurações
    if config.prompt.show_user then
        table.insert(prompt_parts, utils.colorize(user, config.colors[user_color]))
    end
    
    if config.prompt.show_host then
        table.insert(prompt_parts, utils.colorize(hostname, config.colors.prompt_host))
    end
    
    if config.prompt.show_dir then
        table.insert(prompt_parts, utils.colorize(pwd, config.colors.prompt_dir))
    end
    
    -- Adiciona informações do git se configurado
    if config.prompt.show_git then
        local git_info = M.get_git_info()
        if git_info ~= "" then
            table.insert(prompt_parts, utils.colorize(git_info, "yellow"))
        end
    end
    
    -- Monta o prompt final
    local prompt_str = table.concat(prompt_parts, config.symbols.separator)
    
    -- Adiciona o símbolo final
    prompt_str = prompt_str .. " " .. utils.colorize(prompt_symbol, is_root and config.colors.root or config.colors.prompt_user) .. " "
    
    return prompt_str
end

return M