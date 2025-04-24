local utils = require("modulos.utils")
local comandos = require("modulos.comandos")

local M = {}

function M.executar(parsed_command)
    if not parsed_command then return end

    local cmd = parsed_command.command
    local args = parsed_command.args or {}

    -- Verifica se é um comando interno
    if comandos.comandos[cmd] then
        return comandos.comandos[cmd](args)
    end

    -- Monta o comando com seus argumentos
    local full_command = cmd
    for _, arg in ipairs(args) do
        full_command = full_command .. " " .. arg
    end

    -- Executa comando externo
    local success = os.execute(full_command)
    if not success then
        print(utils.colorize("Erro ao executar: " .. cmd, "red"))
    end
end

return M