#!/bin/bash
# Adaptar ambiente para hospedagem, É IMPORTANTE LEMBRAR DE LIBERAR AS PORTAS TAMBÉM NO FIREWALL DA VM
#1.modificar o arquivo /etc/ssh/sshd_config para acesso via shell e criar o usuario de acesso
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service ssh restart
adduser prontuario
echo 'Senha do usuário prontuario'
usermod -aG sudo prontuario
apt update
#1.FTP
apt -q -y install proftpd
sed -i 's/"Debian"/"Prontuario"/g' /etc/proftpd/proftpd.conf
sed -i 's/# DefaultRoot/DefaultRoot/g' /etc/proftpd/proftpd.conf
sed -i 's/# RequireValidShell/RequireValidShell/g' /etc/proftpd/proftpd.conf
chmod 777 /etc/proftpd/proftpd.conf
echo "CreateHome                      on" >> /etc/proftpd/proftpd.conf
chmod 755 /etc/proftpd/proftpd.conf
systemctl restart proftpd
#1.Firewall
ufw allow 22/tcp
ufw allow 5432/tcp
ufw allow 5433/tcp
ufw allow 80/tcp
ufw allow 8080/tcp
ufw allow 21/tcp
ufw allow 443/tcp
ufw allow 49152:65534/tcp
ufw enable
#teste de portas
snap install nmap
passwd -l root
#E-SUS
apt -q -y install unzip
touch /etc/java.conf
chmod 777 /etc/java.conf
echo "JAVA_HOME=/opt/jdk1.7.0/" >> /etc/java.conf
chmod 755 /etc/java.conf
sed -i 's/# pt_BR.UTF-8 UTF-8/  pt_BR.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo 'Instalação concluída, reiniciando o sistema...'
reboot 
#EXECUTAR APÓS O REBOOT
#Link do JDK https://download.oracle.com/otn/java/jdk/7/jdk-7-linux-x64.tar.gz?AuthParam=1559225376_628153f3aa386ef2e530360c70cd0bd3
#tar xvzf jdk-7-linux-x64.tar.gz (Na pasta /opt)
sh instalador_linux.sh
sudo sh /opt/e-SUS/jboss-as-7.2.0.Final/bin/init.d/jboss-as-standalone-lsb.sh start
##################################################################################################
#CONFIGURAÇÃO DO POSTGRES PARA ACESSAR REMOTAMENTE
sed -i 's,127.0.0.1/32,0.0.0.0/0,g' /opt/e-SUS/jboss-as-7.2.0.Final/PostgreSQL/9.3/data/pg_hba.conf
#configurado para acessar sem senha (reverter depois)
sed -i 's,md5,trust,g' /opt/e-SUS/jboss-as-7.2.0.Final/PostgreSQL/9.3/data/pg_hba.conf
sed -i "s/listen_addresses = 'localhost'/listen_addresses = '*'/g" /opt/e-SUS/jboss-as-7.2.0.Final/PostgreSQL/9.3/data/postgresql.conf
sudo service e-SUS-AB-PostgreSQL restart
#PARA ACESSAR -> IPDOSERVIDOR:8080/esus
#TESTAR CONEXOES (Ex.: Postgres 5433)
#telnet IPDOSERVIDOR 5433
#psql -h IPDOSERVIDOR -p 5433 -U postgres
#nmap -p 5433 IPDOSERVIDOR
#netstat -anpt | grep LISTEN (deve estar 0.0.0.0:5433)
#/sbin/iptables -L -n -v | grep 8080