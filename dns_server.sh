#!/bin/sh

# Configurações
IP_LOCAL="192.168.0.101"
IP_BLOCK="0.0.0.0"
PORTA=1053
LISTA="$HOME/lista_bloqueio.txt"
CACHE=""

# 1. Automatização do UPnP (Lógica limpa sem if/else)
echo "Solicitando abertura de porta ao roteador via UPnP..."
upnpc -e "Termux DNS" -a "$IP_LOCAL" "$PORTA" 53 UDP >/dev/null 2>&1 && \
    echo "[OK] Porta 53 redirecionada para $PORTA" || \
    echo "[!] Falha no UPnP"

ip_to_oct() {
    old_ifs="$IFS"; IFS="."; set -- $1; IFS="$old_ifs"
    printf "\\%o\\%o\\%o\\%o" "$1" "$2" "$3" "$4"
}

OCT_LOCAL=$(ip_to_oct "$IP_LOCAL")
OCT_BLOCK=$(ip_to_oct "$IP_BLOCK")

clear
echo "==========================================="
echo "       DNS SERVER (DASH/POSIX)             "
echo "==========================================="
echo " Escutando em: $IP_LOCAL:$PORTA"
[ ! -f "$LISTA" ] && touch "$LISTA"

# Loop Principal (Focado em Performance)
while :; do
    # Captura a query. O timeout -w 1 mantém o loop ágil.
    if query_raw=$(nc -u -l -p "$PORTA" -w 1 2>/dev/null); then
        
        echo "$query_raw" > "$HOME/dns_last_req"
        
        # 1. Extração de ID (Transaction ID)
        id_hex=$(od -An -tx1 -N2 "$HOME/dns_last_req" 2>/dev/null | tr -d ' ')
        [ -z "$id_hex" ] && continue
        
        # Converte Hex para Decimal para o printf octal
        id1=$(printf "%d" "0x${id_hex%??}" 2>/dev/null)
        id2=$(printf "%d" "0x${id_hex#??}" 2>/dev/null)

        # 2. Extração de domínio (Requer binutils/strings)
        dominio=$(strings "$HOME/dns_last_req" | grep '\.' | head -n 1)
        [ -z "$dominio" ] && dominio="query.local"

        # 3. Decisão com 'case' (Mapeamento de Cache)
        case "$CACHE" in
            *"|$dominio|"*)
                TIPO="CACHE"
                IP_RESP="$OCT_BLOCK"
                ;;
            *)
                if grep -qFx "$dominio" "$LISTA"; then
                    TIPO="BLOCK"
                    IP_RESP="$OCT_BLOCK"
                    CACHE="$CACHE|$dominio|"
                else
                    TIPO="ALLOW"
                    IP_RESP="$OCT_LOCAL"
                fi
                ;;
        esac

        echo "[$(date +%H:%M:%S)] $dominio -> $TIPO"

        # 4. Resposta Binária Direta
        (
            printf "\\$(printf '%o' "$id1")\\$(printf '%o' "$id2")"
            printf "\201\200\000\001\000\001\000\000\000\000"
            printf "\300\014\000\001\000\001\000\000\000\074\000\004"
            printf "$IP_RESP"
        ) | nc -u -w 1 "$IP_LOCAL" "$PORTA" >/dev/null 2>&1
    fi
done
