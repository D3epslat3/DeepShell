local utils = require("modulos.utils")
local lfs = require("lfs")

local M = {}

-- Função para expandir o caminho
local function expand_path(path)
    if path:sub(1,1) == "~" then
        return os.getenv("HOME") .. path:sub(2)
    end
    return path
end

-- Função para executar comando e capturar saída
local function execute_and_capture(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- Remove espaços no final
end

-- Comandos internos
M.comandos = {
    cd = function(args)
        local dir = args[1] or os.getenv("HOME")
        dir = expand_path(dir)

        -- Verifica se o diretório existe usando lfs
        if not lfs.attributes(dir, "mode") == "directory" then
            print(utils.colorize("Erro: Diretório não encontrado: " .. dir, "red"))
            return false
        end

        -- Muda o diretório usando lfs
        local success, err = lfs.chdir(dir)
        if success then
            -- Atualiza PWD
            os.setenv("PWD", dir)
            return true
        else
            print(utils.colorize("Erro ao mudar diretório: " .. err, "red"))
            return false
        end
    end,

    pwd = function()
        local current_dir = execute_and_capture("pwd")
        print(current_dir)
    end,

    ls = function(args)
        local cmd = "ls --color=auto " .. table.concat(args, " ")
        os.execute(cmd)
    end,

    mkdir = function(args)
        if #args == 0 then
            print(utils.colorize("Erro: mkdir precisa de um argumento", "red"))
            return
        end
        os.execute("mkdir -p " .. table.concat(args, " "))
    end,

    rm = function(args)
        if #args == 0 then
            print(utils.colorize("Erro: rm precisa de um argumento", "red"))
            return
        end
        os.execute("rm " .. table.concat(args, " "))
    end,

    cp = function(args)
        if #args < 2 then
            print(utils.colorize("Erro: cp precisa de origem e destino", "red"))
            return
        end
        os.execute("cp " .. table.concat(args, " "))
    end,

    mv = function(args)
        if #args < 2 then
            print(utils.colorize("Erro: mv precisa de origem e destino", "red"))
            return
        end
        os.execute("mv " .. table.concat(args, " "))
    end,

    cat = function(args)
        if #args == 0 then
            print(utils.colorize("Erro: cat precisa de um arquivo", "red"))
            return
        end
        os.execute("cat " .. table.concat(args, " "))
    end,

    clear = function()
        os.execute("clear")
    end,

    exit = function()
        print(utils.colorize("Saindo...", "bright_blue"))
        os.exit(0)
    end,

    su = function(args)
        local shell_path = arg[0] -- Pega o caminho do shell atual
        if #args > 0 then
            -- Se houver argumentos, passa-os para o su
            os.execute("sudo su -c " .. shell_path .. " " .. table.concat(args, " "))
        else
            -- Se não houver argumentos, apenas inicia o shell como root
            os.execute("sudo su -c " .. shell_path)
        end
    end,

    help = function()
        print(utils.colorize("Comandos disponíveis:", "bright_yellow"))
        print("\nNavegação e Arquivos:")
        print("  ls      - Listar arquivos")
        print("  cd      - Mudar diretório")
        print("  pwd     - Mostrar diretório atual")
        print("  mkdir   - Criar diretório")
        print("  rm      - Remover arquivo/diretório")
        print("  cp      - Copiar arquivo")
        print("  mv      - Mover arquivo")
        print("  cat     - Mostrar conteúdo de arquivo")
        print("\nGerenciamento do Shell:")
        print("  clear   - Limpar tela")
        print("  exit    - Sair do shell")
        print("  help    - Mostrar esta ajuda")
    end
}

-- Função auxiliar para definir variável de ambiente
function os.setenv(name, value)
    if value then
        os.execute(string.format('export %s="%s"', name, value))
    else
        os.execute(string.format('unset %s', name))
    end
end

return M