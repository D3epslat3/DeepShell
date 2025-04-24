
# DeepShell

DeepShell é um shell moderno e flexível escrito em Lua, oferecendo uma experiência de linha de comando aprimorada com recursos como autocompletar, histórico de comandos, atalhos personalizáveis e um prompt customizável.

CARACTERÍSTICAS PRINCIPAIS:
- Interface moderna e amigável
- Prompt customizável e colorido
- Autocompletar inteligente
- Histórico de comandos persistentes
- Atalhos de teclado personalizáveis
- Sistema de plugins
- Integração com Git
- Saída colorida para comandos como ls

REQUISITOS:
- LuaJIT 2.0+
- LuaRocks
- LuaFileSystem

INSTALAÇÃO (LINUX):

Instalação automática:
```bash
git clone https://github.com/seu_usuario/DeepShell.git
cd DeepShell
chmod +x install.sh
./install.sh
```

Instalação manual:
```bash
# Para Debian/Ubuntu:
sudo apt update
sudo apt install luajit luarocks

# Para Fedora:
sudo dnf install luajit luarocks

# Para Arch Linux:
sudo pacman -S luajit luarocks

# Instalar dependências Lua:
sudo luarocks install luafilesystem

# Instalar DeepShell:
git clone https://github.com/seu_usuario/DeepShell.git
sudo cp -r DeepShell /opt/
sudo ln -s /opt/DeepShell/deepshell /usr/local/bin/deepshell
```

USO BÁSICO:
Para iniciar o shell:
```bash
deepshell
```

Comandos disponíveis:
```bash
help       # Mostra ajuda
ls -l      # Lista arquivos com detalhes
cd ~/docs  # Muda para diretório docs
clear      # Limpa a tela
exit       # Sai do shell
```

CONFIGURAÇÃO:
Edite o arquivo de configuração:
```bash
nano ~/.config/deepshell/config.lua
```

Exemplo de configuração:
```bash
-- Configuração básica do DeepShell
return {
    show_git_status = true,
    prompt_style = "minimal",
    theme = "dark"
}
```

ATALHOS DE TECLADO:
```bash
Ctrl+A    # Move cursor para início da linha
Ctrl+E    # Move cursor para fim da linha
Ctrl+R    # Busca no histórico
Ctrl+L    # Limpa a tela
Tab       # Ativa autocompletar
```

LICENÇA:
MIT License

Para atualizar para a versão mais recente:
```bash
cd /opt/DeepShell
git pull origin main
```
