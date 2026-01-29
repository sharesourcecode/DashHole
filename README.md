# DashHole 🛡
DashHole é um servidor DNS Sinkhole leve e performático, escrito inteiramente em pure POSIX Shell (Dash). Ele foi projetado para rodar em ambientes minimalistas como o Termux (Android), utilizando automação UPnP para contornar restrições de rede sem necessidade de acesso Root.
# 🎯 Por que DashHole?
Diferente de soluções pesadas, o DashHole foca na simplicidade e eficiência:
 __● Zero Bashismos:__ Compatível com /bin/sh (Dash), ideal para Busybox e Alpine Linux.

 __● Redução de Condicionais:__ Lógica de decisão otimizada com case para maior legibilidade e velocidade.

 __● Cache em Memória:__ Armazena domínios bloqueados em variáveis para evitar I/O excessivo no disco.

 __● Automação de Rede:__ Utiliza UPnP para mapeamento dinâmico de portas no roteador.
