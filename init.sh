#!/bin/bash

# Configura o ambiente
eval $(luarocks path --bin)

# Executa o shell
luajit main.lua
