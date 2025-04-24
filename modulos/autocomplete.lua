local utils = require("modulos.utils")
local lfs = require("lfs")

local autocomplete = {}

-- Lista de comandos internos baseada no seu módulo comandos.lua
local internal_commands = {
    "cd", "pwd", "ls", "mkdir", "rm", "cp", "mv", "cat", "clear", "exit", "help"
}

-- Cache para arquivos e diretórios
local cache = {
    files = {},
    dirs = {},
    last_update = 0,
    timeout = 2 -- segundos para atualizar cache
}

-- Função para expandir o caminho (similar à sua função em comandos.lua)
local function expand_path(path)
    if path:sub(1,1) == "~" then
        return os.getenv("HOME") .. path:sub(2)
    end
    return path
end

-- Atualiza o cache de arquivos e diretórios usando lfs
local function update_cache(dir)
    local current_time = os.time()
    if current_time - cache.last_update > cache.timeout then
        cache.files = {}
        cache.dirs = {}

        dir = dir or "."
        for file in lfs.dir(dir) do
            if file ~= "." and file ~= ".." then
                local path = dir .. "/" .. file
                local mode = lfs.attributes(path, "mode")
                if mode == "directory" then
                    table.insert(cache.dirs, file)
                else
                    table.insert(cache.files, file)
                end
            end
        end
        cache.last_update = current_time
    end
end

-- Encontra o maior prefixo comum entre strings
local function common_prefix(strings)
    if #strings == 0 then return "" end
    if #strings == 1 then return strings[1] end

    local shortest = strings[1]
    for i = 2, #strings do
        if #strings[i] < #shortest then
            shortest = strings[i]
        end
    end

    local prefix = ""
    for i = 1, #shortest do
        local char = shortest:sub(i,i)
        for _, str in ipairs(strings) do
            if str:sub(i,i) ~= char then
                return prefix
            end
        end
        prefix = prefix .. char
    end
    return prefix
end

-- Encontra matches baseado em um prefixo
local function find_matches(prefix, items)
    local matches = {}
    for _, item in ipairs(items) do
        if item:sub(1, #prefix) == prefix then
            table.insert(matches, item)
        end
    end
    return matches
end

-- Completa comandos
local function complete_command(word)
    return find_matches(word, internal_commands)
end

-- Completa arquivos e diretórios
local function complete_path(word)
    local dir, file = "", word
    if word:find("/") then
        dir, file = word:match("(.*/)(.*)")
        dir = expand_path(dir)
    end

    update_cache(dir == "" and "." or dir)
    local matches = {}

    -- Adiciona diretórios
    for _, d in ipairs(cache.dirs) do
        if d:sub(1, #file) == file then
            table.insert(matches, (dir or "") .. d .. "/")
        end
    end

    -- Adiciona arquivos
    for _, f in ipairs(cache.files) do
        if f:sub(1, #file) == file then
            table.insert(matches, (dir or "") .. f)
        end
    end

    return matches
end

-- Handlers especiais para comandos específicos
local special_handlers = {
    cd = function(args)
        return complete_path(args[#args] or "")
    end,
    ls = function(args)
        return complete_path(args[#args] or "")
    end,
    cat = function(args)
        return complete_path(args[#args] or "")
    end,
    rm = function(args)
        return complete_path(args[#args] or "")
    end,
    cp = function(args)
        return complete_path(args[#args] or "")
    end,
    mv = function(args)
        return complete_path(args[#args] or "")
    end
}

-- Função principal de autocomplete
function autocomplete.complete(line, cursor_pos)
    -- Implementa função split localmente já que utils.split não está disponível
    local function split(str)
        local result = {}
        for match in str:gmatch("%S+") do
            table.insert(result, match)
        end
        return result
    end

    local words = split(line:sub(1, cursor_pos))
    local current_word = words[#words] or ""
    local is_first_word = #words <= 1

    local matches
    if is_first_word then
        matches = complete_command(current_word)
    else
        local cmd = words[1]
        if special_handlers[cmd] then
            matches = special_handlers[cmd](words)
        else
            matches = complete_path(current_word)
        end
    end

    if #matches == 0 then
        return line, cursor_pos
    elseif #matches == 1 then
        local completion = matches[1]
        local prefix_len = #current_word
        local new_line = line:sub(1, cursor_pos - prefix_len) .. completion .. line:sub(cursor_pos + 1)
        return new_line, cursor_pos - prefix_len + #completion
    else
        local common = common_prefix(matches)
        if #common > #current_word then
            local new_line = line:sub(1, cursor_pos - #current_word) .. common .. line:sub(cursor_pos + 1)
            return new_line, cursor_pos - #current_word + #common
        else
            print("\nPossíveis completions:")
            for _, match in ipairs(matches) do
                print(utils.colorize(match, "bright_blue"))
            end
            io.write("\n" .. line)
            return line, cursor_pos
        end
    end
end

-- Função para registrar novos comandos para autocomplete
function autocomplete.register_command(cmd)
    table.insert(internal_commands, cmd)
end

-- Função para registrar handler especial para um comando
function autocomplete.register_special_handler(cmd, handler)
    special_handlers[cmd] = handler
end

return autocomplete