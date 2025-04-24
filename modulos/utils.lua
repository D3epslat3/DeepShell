local M = {}

-- Códigos ANSI para cores
M.COLORS = {
    reset = "\27[0m",
    bright = "\27[1m",
    dim = "\27[2m",
    black = "\27[30m",
    red = "\27[31m",
    green = "\27[32m",
    yellow = "\27[33m",
    blue = "\27[34m",
    magenta = "\27[35m",
    cyan = "\27[36m",
    white = "\27[37m",
    bg_black = "\27[40m",
    bg_red = "\27[41m",
    bg_green = "\27[42m",
    bg_yellow = "\27[43m",
    bg_blue = "\27[44m",
    bg_magenta = "\27[45m",
    bg_cyan = "\27[46m",
    bg_white = "\27[47m"
}

function M.colorize(text, color)
    if not M.COLORS[color] then
        return text
    end
    return M.COLORS[color] .. text .. M.COLORS.reset
end

function M.split_string(str, sep)
    local parts = {}
    for part in string.gmatch(str, "[^" .. (sep or "%s+") .. "]+") do
        table.insert(parts, part)
    end
    return parts
end

-- Função para detectar se estamos em um terminal
function M.is_terminal()
    return io.stdout.isatty and io.stdout:isatty()
end

-- Função para definir variáveis de ambiente
function os.setenv(name, value)
    if value then
        os.execute(string.format('export %s="%s"', name, value))
    else
        os.execute(string.format('unset %s', name))
    end
end

-- Função para verificar se um caminho é absoluto
function M.is_absolute_path(path)
    return path:sub(1,1) == "/"
end

-- Função para juntar caminhos
function M.join_paths(...)
    local parts = {...}
    return table.concat(parts, "/"):gsub("//+", "/")
end

-- Função para normalizar um caminho
function M.normalize_path(path)
    -- Remove ./
    path = path:gsub("%.?/", "/")
    -- Remove múltiplas /
    path = path:gsub("//+", "/")
    -- Remove / no final
    path = path:gsub("/$", "")
    return path
end

return M