#! /bin/bash

#script para  analizar el registro de proftpd.log
#Pablo León Alcaide

echo " "
echo "MARGEN TEMPORAL DEL LOG: " 
cat daemon.log |head -1|cut -d ' ' -f -4
cat daemon.log |tail -1|cut -d ' ' -f -4

echo " "
echo "NÚMERO DE REGISTROS EN ESTE MARGEN TEMPORAL: "
cat /var/log/proftpd.log| wc -l

#comprobamos si se han producido violaciones de seguridad
echo " "
echo "VIOLACIONES DE SEGURIDAD: "
grep -i 'violation' /var/log/proftpd.log

#comprobamos si se han abierto conexiones ftp
echo " "
echo "COMUNICACIONES FTP ABIERTAS CON ÉXITO: "
grep 'FTP session opened' /var/log/proftpd.log

echo " "
echo "LOGIN REALIZADOS CON ÉXITO: "
grep 'Login successful' /var/log/proftpd.log

#comprobamos si se han intentado conectar con usuarios no encontrados
echo " "
echo "USUARIOS CON LOS QUE SE HA TRATADO DE ESTABLECER COMUNICACIÓN: "
grep 'no such user found' /var/log/proftpd.log|cut -d ' ' -f 8,9,14- |sort |uniq -c|sort -g

#comprobamos si se han abierto conexiones vpn
echo " "
echo "CONEXIONES MEDIANTE VPN: "
grep 'vpn.*opened' /var/log/proftpd.log

#comprobamos las operaciones con chroot realizadas,
echo " "
echo "OPERACIONES CON CHROOT: "
grep 'chroot' /var/log/proftpd.log

#comprobamos los directorios implicados en las operaciones de chroot
echo " "
echo "DIRECTORIOS ENJAULADOS CON CHROOT: "
grep 'chroot' /var/log/proftpd.log| cut -d '/' -f 2-|sort|uniq
