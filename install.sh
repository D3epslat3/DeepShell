#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Iniciando instalação do DeepShell...${NC}\n"

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para instalar pacotes baseado na distribuição
install_package() {
    if command_exists apt-get; then
        sudo apt-get install -y "$1"
    elif command_exists dnf; then
        sudo dnf install -y "$1"
    elif command_exists pacman; then
        sudo pacman -S --noconfirm "$1"
    else
        echo -e "${RED}Não foi possível identificar o gerenciador de pacotes.${NC}"
        exit 1
    fi
}

# Verifica e instala Lua
if ! command_exists lua; then
    echo -e "${YELLOW}Instalando Lua...${NC}"
    install_package lua5.3
    install_package liblua5.3-dev
fi

# Verifica e instala LuaRocks
if ! command_exists luarocks; then
    echo -e "${YELLOW}Instalando LuaRocks...${NC}"
    install_package luarocks
fi

# Instala dependências via LuaRocks
echo -e "${YELLOW}Instalando dependências via LuaRocks...${NC}"
sudo luarocks install luafilesystem

# Cria diretório de instalação
INSTALL_DIR="/usr/local/share/deepshell"
sudo mkdir -p "$INSTALL_DIR"

# Copia os arquivos do shell
echo -e "${YELLOW}Copiando arquivos do DeepShell...${NC}"
sudo cp -r ./* "$INSTALL_DIR/"

# Cria o script executável
EXEC_PATH="/usr/local/bin/deepshell"
echo -e "${YELLOW}Criando executável...${NC}"

cat << EOF | sudo tee "$EXEC_PATH"
#!/bin/bash
exec luajit "$INSTALL_DIR/main.lua" "\$@"
EOF

# Garante as permissões corretas
sudo chmod 755 "$INSTALL_DIR"
sudo chmod 644 "$INSTALL_DIR"/*.lua
sudo chmod 644 "$INSTALL_DIR"/modulos/*.lua
sudo chmod 755 "$EXEC_PATH"

# Cria diretório para histórico e configurações do usuário
mkdir -p "$HOME/.config/deepshell"
touch "$HOME/.deepshell_history"

# Copia arquivo de configuração para o diretório do usuário
cp "$INSTALL_DIR/config.lua" "$HOME/.config/deepshell/config.lua"

# Adiciona o shell à lista de shells válidos
if ! grep -q "$EXEC_PATH" /etc/shells; then
    echo "$EXEC_PATH" | sudo tee -a /etc/shells
fi

echo -e "${GREEN}DeepShell foi instalado com sucesso!${NC}"
echo -e "${YELLOW}Digite 'deepshell' para iniciar.${NC}"