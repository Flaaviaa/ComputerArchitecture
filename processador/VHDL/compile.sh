#!/bin/bash

# Verifica se o número de argumentos é igual a 1
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <arquivo>"
    exit 1
fi

# Armazena o nome completo do arquivo com extensão
arquivo_completo="$1"

# Remove a extensão do arquivo
arquivo="${arquivo_completo%.*}"

# Compila o arquivo VHDL
ghdl -a "$arquivo".vhd

# Elabora o arquivo compilado
ghdl -e "$arquivo"

# Verifica se o nome do arquivo termina com "_tb"
if [[ "$arquivo" == *_tb ]]; then
    # Executa o arquivo elaborado e cria o arquivo de ondas
    ghdl -r "$arquivo" --wave="$arquivo".ghw
fi
if [[ "$arquivo" == *_TB ]]; then
    # Executa o arquivo elaborado e cria o arquivo de ondas
    ghdl -r "$arquivo" --wave="$arquivo".ghw
fi