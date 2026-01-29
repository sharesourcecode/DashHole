#!/bin/sh

# Configurações
# Utilizando a lista StevenBlack (famosa por agregar várias fontes como OISD)
URL_LISTA="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
ARQUIVO_DESTINO="$HOME/lista_bloqueio.txt"
ARQUIVO_TEMP="$HOME/lista_bloqueio.tmp"

# Cores para o terminal (compatível com printf)
VERDE='\033[0;32m'
AZUL='\033[0;34m'
RESET='\033[0m'

printf "${AZUL}Iniciando atualização da lista de bloqueio...${RESET}\n"

# 1. Baixar a lista usando curl
# -s: silencioso
# -L: segue redirecionamentos
if ! curl -sL "$URL_LISTA" -o "$ARQUIVO_TEMP"; then
    printf "Erro: Não foi possível baixar a lista. Verifique a conexão.\n"
    exit 1
fi

# 2. Processamento POSIX (Lógica de filtragem)
# grep '^0.0.0.0': pega apenas linhas que começam com o IP de bloqueio
# awk '{print $2}': extrai apenas a segunda coluna (o domínio)
# sed: remove possíveis caracteres de retorno de carro (\r) do Windows
grep '^0.0.0.0' "$ARQUIVO_TEMP" | \
    grep -v 'localhost' | \
    awk '{print $2}' | \
    sed 's/\r//g' | \
    sort -u > "$ARQUIVO_DESTINO"

# 3. Limpeza
rm "$ARQUIVO_TEMP"

TOTAL=$(wc -l < "$ARQUIVO_DESTINO")

printf "${VERDE}Sucesso!${RESET} Lista atualizada.\n"
printf "Arquivo: $ARQUIVO_DESTINO\n"
printf "Total de domínios bloqueados: ${AZUL}$TOTAL${RESET}\n"

# Sugestão de próximo passo para o usuário
printf "\nPara aplicar as mudanças, reinicie o seu dns_server.sh\n"
