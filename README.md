# esus-install

Shellscript para instalação dos requisitos do sistema de prontuário eSUS-PEC 3.1.12

- Download do JDK 7 (Só funciona com ele) https://download.oracle.com/otn/java/jdk/7/jdk-7-linux-x64.tar.gz?AuthParam=1559225376_628153f3aa386ef2e530360c70cd0bd3
- Todas as versões do esus podem ser encontradas em: http://rangtecnologia.com.br/downloadsEsus.xhtml

O Script habilita FTP,acesso via SSH, e configurações de firewall necessárias para o uso do sistema.
Altera os arquivos solicitados no readme de instalação do esus.

Efetuado o download do JDK, extraia na pasta /opt/ -> ex.: /opt/jdk1.7.0/

O script não executa as linhas de comando a partir da linha 42, a execução do instalador_linux.sh deve ser feita manualmente.
As configurações de postgres a partir da linha 48 são opcionais.

**Testado apenas no ubuntu 18.04 LTS