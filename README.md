# DashHole 🛡
__DashHole__ é um servidor DNS Sinkhole leve e performático, escrito inteiramente em __pure POSIX Shell (Dash)__. Ele foi projetado para rodar em ambientes minimalistas como o __Termux__ (Android), utilizando automação __UPnP__ para contornar restrições de rede sem necessidade de acesso Root.
# 🎯 Por que DashHole?
Diferente de soluções pesadas, o DashHole foca na simplicidade e eficiência:
- __Zero Bashismos:__ Compatível com ```/bin/sh``` (Dash), ideal para Busybox e Alpine Linux.

- __Redução de Condicionais:__ Lógica de decisão otimizada com ```case``` para maior legibilidade e velocidade.

- __Cache em Memória:__ Armazena domínios bloqueados em variáveis para evitar I/O excessivo no disco.

- __Automação de Rede:__ Utiliza UPnP para mapeamento dinâmico de portas no roteador.
# 🛠️ Requisitos

No Termux, instale as dependências necessárias:
```Bash

pkg update
pkg install binutils busybox miniupnpc dnsutils
```
- __binutils:__ Necessário para o comando ```strings``` (extração de domínios).

- __busybox:__ Utilitários de sistema leves.

- __miniupnpc:__ Para o comando ```upnpc``` (configuração do roteador).

- __dnsutils:__ Ferramentas de teste como ```nslookup``` e ```dig```.
