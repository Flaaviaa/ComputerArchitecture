#!/bin/bash

# Verifica se o número de argumentos é igual a 1
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <arquivo>"
    exit 1
fi

# Armazena o nome do arquivo
arquivo="$1"

# Compila o arquivo VHDL
ghdl -a "$arquivo".vhd

# Elabora o arquivo compilado
ghdl -e "$arquivo"

# Executa o arquivo elaborado e cria o arquivo de ondas
ghdl -r "$arquivo" --wave="$arquivo".ghw
