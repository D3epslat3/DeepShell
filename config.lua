return {
    shell_name = "DeepShell",
    version = "1.0.0",
    prompt_style = "fancy",
    history_file = os.getenv("HOME") .. "/.deepshell_history",
    colors = {
        prompt_user = "green",
        prompt_host = "blue",
        prompt_dir = "cyan",
        error = "red",
        success = "green",
        root = "red"    -- Cor para quando for root
    },
    symbols = {
        user_prompt = "➜",      -- Símbolo para usuário normal
        root_prompt = "⚡",      -- Símbolo para root
        separator = " ⟫ ",        -- Separador entre host e diretório
        home_symbol = "="       -- Símbolo para o diretório home
    },
    -- Configurações de prompt
    prompt = {
        show_user = true,      -- Mostrar nome do usuário
        show_host = false,      -- Mostrar hostname
        show_dir = true,       -- Mostrar diretório atual
        show_git = true,       -- Mostrar informações do git (se disponível)
    },
    -- Configurações de cores para ls
    ls_colors = {
        enabled = true,  -- Habilita/desabilita cores no ls
        custom_colors = {
            -- Tipos de arquivo
            dir = "01;34",        -- Diretórios
            exe = "01;32",        -- Executáveis
            link = "01;36",       -- Links simbólicos
            archive = "01;31",    -- Arquivos compactados
            media = "01;35",      -- Arquivos de mídia
            special = "01;33",    -- Arquivos especiais

            -- Extensões específicas
            extensions = {
                -- Texto e programação
                [".txt"] = "00;37",
                [".lua"] = "00;36",
                [".py"] = "00;35",
                [".js"] = "00;33",
                [".json"] = "00;37",

                -- Arquivos compactados
                [".zip"] = "01;31",
                [".tar"] = "01;31",
                [".gz"] = "01;31",

                -- Mídia
                [".mp3"] = "01;35",
                [".mp4"] = "01;35",
                [".jpg"] = "01;35",
                [".png"] = "01;35"
            }
        }
    }
}