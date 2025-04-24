local M = {}
local autocomplete = require("modulos.autocomplete")

-- Tabela de códigos de teclas especiais
M.KEYS = {
    CTRL_A = '\001',  -- Ctrl+A
    CTRL_B = '\002',  -- Ctrl+B 
    CTRL_C = '\003',  -- Ctrl+C
    CTRL_D = '\004',  -- Ctrl+D
    CTRL_E = '\005',  -- Ctrl+E
    CTRL_F = '\006',  -- Ctrl+F
    CTRL_L = '\012',  -- Ctrl+L
    CTRL_U = '\021',  -- Ctrl+U
    CTRL_W = '\027',  -- Ctrl+W
    BACKSPACE = '\127', -- Backspace
    ESC = '\027',      -- ESC
    TAB = '\t'         -- Tab
}

-- Buffer para armazenar o histórico de comandos
M.history = {}
M.history_pos = 0 
M.history_size = 100

-- Função para ler um caractere sem eco
function M.getch()
    os.execute("stty raw -echo")
    local char = io.read(1)
    os.execute("stty sane")
    return char
end

-- Função para limpar a linha atual
function M.clear_line()
    io.write("\r\027[K") -- Retorna ao início da linha e limpa
    io.flush()
end

-- Função para mover o cursor
function M.move_cursor(n)
    if n > 0 then
        io.write(string.format("\027[%dC", n)) -- Move para direita
    elseif n < 0 then
        io.write(string.format("\027[%dD", -n)) -- Move para esquerda
    end
    io.flush()
end

-- Função para adicionar comando ao histórico
function M.add_to_history(cmd)
    if cmd and cmd:match("%S") then
        table.insert(M.history, cmd)
        if #M.history > M.history_size then
            table.remove(M.history, 1)
        end
        M.history_pos = #M.history + 1
    end
end

-- Função para navegar no histórico
function M.navigate_history(direction)
    if #M.history == 0 then return nil end

    if direction == "up" then
        M.history_pos = math.max(1, M.history_pos - 1)
    else
        M.history_pos = math.min(#M.history + 1, M.history_pos + 1)
    end

    if M.history_pos <= #M.history then
        return M.history[M.history_pos]
    end
    return ""
end

-- Função principal de leitura com suporte a atalhos
function M.read_line(prompt)
    local buffer = ""
    local pos = 0

    io.write(prompt)
    io.flush()

    while true do
        local char = M.getch()

        if char == M.KEYS.CTRL_C then
            print("^C")
            return nil

        elseif char == M.KEYS.CTRL_D and buffer == "" then
            return nil

        elseif char == M.KEYS.TAB then
            buffer, pos = autocomplete.complete(buffer, pos)
            M.clear_line()
            io.write(prompt .. buffer)
            M.move_cursor(pos - #buffer)

        elseif char == M.KEYS.BACKSPACE then
            if pos > 0 then
                buffer = buffer:sub(1, pos - 1) .. buffer:sub(pos + 1)
                pos = pos - 1
                M.clear_line()
                io.write(prompt .. buffer)
                M.move_cursor(pos - #buffer)
            end

        elseif char == M.KEYS.CTRL_A then
            -- Início da linha
            M.move_cursor(-pos)
            pos = 0

        elseif char == M.KEYS.CTRL_E then
            -- Fim da linha
            M.move_cursor(#buffer - pos)
            pos = #buffer

        elseif char == M.KEYS.CTRL_L then
            -- Limpar tela
            os.execute("clear")
            io.write(prompt .. buffer)
            M.move_cursor(pos - #buffer)

        elseif char == M.KEYS.CTRL_U then
            -- Limpar linha atual
            buffer = buffer:sub(pos + 1)
            pos = 0
            M.clear_line()
            io.write(prompt .. buffer)

        elseif char == M.KEYS.ESC then
            -- Teclas de seta (navegação no histórico)
            local next_char = M.getch()
            if next_char == '[' then
                local arrow = M.getch()
                if arrow == 'A' then -- Seta para cima
                    local hist_cmd = M.navigate_history("up")
                    if hist_cmd then
                        buffer = hist_cmd
                        pos = #buffer
                        M.clear_line()
                        io.write(prompt .. buffer)
                    end
                elseif arrow == 'B' then -- Seta para baixo
                    local hist_cmd = M.navigate_history("down")
                    if hist_cmd then
                        buffer = hist_cmd
                        pos = #buffer
                        M.clear_line()
                        io.write(prompt .. buffer)
                    end
                end
            end

        elseif char == '\r' or char == '\n' then
            -- Enter
            print("")
            M.add_to_history(buffer)
            return buffer

        elseif char:byte() >= 32 then
            -- Caracteres normais
            buffer = buffer:sub(1, pos) .. char .. buffer:sub(pos + 1)
            pos = pos + 1
            M.clear_line()
            io.write(prompt .. buffer)
            M.move_cursor(pos - #buffer)
        end

        io.flush()
    end
end

-- Comandos built-in adicionais
M.built_in_commands = {
    ls = function(args)
        os.execute("ls " .. table.concat(args, " "))
    end,

    echo = function(args)
        print(table.concat(args, " "))
    end
}

return M