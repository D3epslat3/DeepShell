#!/usr/bin/env luajit

-- Determina o diretório base do shell
local function get_shell_base_dir()
    return "/usr/local/share/deepshell/"
end

-- Configura o path para módulos
local base_dir = get_shell_base_dir()
package.path = base_dir .. "?.lua;" .. 
               base_dir .. "modulos/?.lua;" .. 
               package.path

-- Adiciona logger para debug
local logger = require("modulos.logger")
logger.log("Iniciando DeepShell")
logger.log("Package path: " .. package.path)
logger.log("Base dir: " .. base_dir)

local check_deps = require("modulos.check_deps")
if not check_deps.check_dependencies() then
    print("Por favor, instale as dependências faltantes")
    os.exit(1)
end

-- Importação de módulos
local configs = require("modulos.configs")
local parser = require("modulos.parser")
local executor = require("modulos.executor")
local prompt = require("modulos.prompt")
local utils = require("modulos.utils")
local atalhos = require("modulos.atalhos")
local autocomplete = require("modulos.autocomplete")

-- Configuração inicial do terminal
local function configure_terminal()
    -- Temporariamente volta ao modo normal para a mensagem de boas-vindas
    os.execute("stty sane")

    -- Exibe mensagem de boas-vindas
    os.execute("clear") -- Limpa a tela antes de mostrar a mensagem
    print(utils.colorize(configs.CONFIG.shell_name .. " v" .. configs.CONFIG.version, "bright_yellow"))
    print(utils.colorize("Digite 'help' para ver os comandos disponíveis", "dim"))
    print("") -- Linha em branco para melhor espaçamento

    -- Configura modo raw para o shell
    os.execute("stty raw -echo")
end

-- Restaura configurações do terminal
local function restore_terminal()
    os.execute("stty sane")
end

-- Configura manipulador de saída
local function setup_exit_handler()
    local old_handler = os.exit
    os.exit = function(code)
        restore_terminal()
        old_handler(code)
    end
end

-- Inicialização
configure_terminal()
setup_exit_handler()

-- Loop principal
while true do
    local input = atalhos.read_line(prompt.get_prompt())

    if input then
        local parsed = parser.parse_command(input)
        if parsed then
            -- Temporariamente restaura o terminal para a execução do comando
            restore_terminal()

            local success, err = pcall(executor.executar, parsed)
            if not success then
                print(utils.colorize("Erro: " .. tostring(err), "red"))
            end

            -- Volta para modo raw
            os.execute("stty raw -echo")
        end
    end
end