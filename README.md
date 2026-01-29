# DashHole 🛡
DashHole é um servidor DNS Sinkhole leve e performático, escrito inteiramente em pure POSIX Shell (Dash). Ele foi projetado para rodar em ambientes minimalistas como o Termux (Android), utilizando automação UPnP para contornar restrições de rede sem necessidade de acesso Root.
# 🎯 Por que DashHole?
Diferente de soluções pesadas, o DashHole foca na simplicidade e eficiência:

  Zero Bashismos: Compatível com /bin/sh (Dash), ideal para Busybox e Alpine Linux.

  Redução de Condicionais: Lógica de decisão otimizada com case para maior legibilidade e velocidade.

  Cache em Memória: Armazena domínios bloqueados em variáveis para evitar I/O excessivo no disco.

  Automação de Rede: Utiliza UPnP para mapeamento dinâmico de portas no roteador.
