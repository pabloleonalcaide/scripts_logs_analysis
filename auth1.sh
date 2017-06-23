#! /bin/bash

#script para  analizar el registro de /var/log/auth.log.1
#Pablo León Alcaide

echo "/var/log/MÁQUINA A LA QUE SE ACCEDE: "
cat /var/log/auth.log.1 | tr -s ' ' ' '|cut -d ' ' -f4|sort|uniq
echo " "
echo "MARGEN TEMPORAL DEL REGISTRO: "
cat /var/log/auth.log.1 | tr -s ' ' ' '|cut -d ' ' -f -3|head -1
cat /var/log/auth.log.1 | tr -s ' ' ' '|cut -d ' ' -f -3|tail -1
echo " "
echo "AUTENTIFICACIONES E INTENTOS EN ESTE PERIODO: "
cat /var/log/auth.log.1 | wc -l

#Comprobamos los accesos por ssh
echo " "
echo "LOGIN CORRECTOS POR SSH "
cat /var/log/auth.log.1 | grep 'sshd.*opened'

echo " "
echo "LOGIN FALLIDOS POR SSH"
grep -i 'sshd.*fail' /var/log/auth.log.1

echo " "
echo "TOTAL LOGIN CORRECTOS POR SSH: "
cat /var/log/auth.log.1 | grep 'sshd.*opened'|wc -l

echo " "
echo "TOTAL LOGIN INCORRECTOS POR SSH: "
grep -i 'sshd.*fail' /var/log/auth.log.1 |wc -l

echo " "
echo "USUARIOS CON LOS QUE SE HA TRATADO DE ACCEDER: "
grep 'Invalid.*from.*' /var/log/auth.log.1|sort|uniq|cut -d ':' -f 4

echo " "
echo "IPS QUE HAN FALLADO AL CONECTAR COMO ROOT"  
grep "Failed password for root" /var/log/auth.log.1|cut -f 12 -d ' '| sort | uniq -c | sort -g

echo " "
echo "POSIBLES ATAQUES DE FUERZA BRUTA"
grep 'BREAK-IN' /var/log/auth.log.1

echo " "
echo "RELACIÓN DE IPS QUE PUDIERON REALIZAR LOS ATAQUES"
grep 'BREAK-IN' /var/log/auth.log.1| cut -d ' ' -f 13|grep '[.*]'|sort|uniq -c | sort -g

#Comprobamos las apariciones de CRON en el registro 
echo " "
echo "REGISTROS DE EJECUCIÓN DE CRON: "
grep "CRON" /var/log/auth.log.1 |wc -l

echo " "
echo "MARGEN TEMPORAL DE LA ÚLTIMA ACTIVIDAD DE CRON: "
grep 'CRON' /var/log/auth.log.1|cut -d ' ' -f 4|tail -10

echo " "
echo "USUARIOS QUE HAN INTERVENIDO EN TAREAS DE CRON: "
grep "CRON" /var/log/auth.log.1|cut -d ' ' -f 12|sort | uniq -c   

#Comprobamos las conexiones o intentos al servidor ftp
echo " "
echo "CONEXIONES REALIZADAS CON ÉXITO A SERVIDOR FTP: "
grep 'proftpd.*session opened.*' /var/log/auth.log.1

echo " "
echo "CONEXIONES FALLIDAS A SERVIDOR FTP: "
grep 'proftpd.*failure.*' /var/log/auth.log.1

echo " "
echo "CONEXIONES A SERVIDOR FTP REALIZADAS POR: " 
grep 'proftpd.*session opened.*' auth.log|cut -d ' ' -f 12|sort|uniq
