#! /bin/bash

#script para  analizar el registro de auth.log
#Pablo León Alcaide

#el fichero auth.log almacena los accesos al sistema, incluídos los accesos fallídos
echo "MÁQUINA A LA QUE SE ACCEDE: "
cut -f 5 -d ' ' /var/log/auth.log|uniq 
echo " "
echo "MARGEN TEMPORAL DEL REGISTRO: "
cat /var/log/auth.log |head -1 |cut -d ' ' -f -4 
cat /var/log/auth.log |tail -1 |cut -d ' ' -f -4

echo "AUTENTIFICACIONES E INTENTOS EN ESTE PERIODO: "
cat /var/log/auth.log | wc -l

#Comprobamos los accesos por ssh
echo " "
echo "LOGIN CORRECTOS POR SSH "
grep 'sshd.*opened' /var/log/auth.log

echo " "
echo "LOGIN FALLIDOS POR SSH"
grep -i 'sshd.*fail' /var/log/auth.log

echo " "
echo "TOTAL LOGIN CORRECTOS POR SSH: "
grep 'sshd.*opened' /var/log/auth.log |wc -l

echo " "
echo "TOTAL LOGIN INCORRECTOS POR SSH: "
grep -i 'sshd.*fail' /var/log/auth.log |wc -l

#comprobamos si hay usuarios que han tratado de acceder sin éxito
echo " "
echo "USUARIOS CON LOS QUE SE HA TRATADO DE ACCEDER: "
grep 'Invalid.*from.*' /var/log/auth.log|sort|uniq|cut -d ':' -f 4

#comprobamos las veces que se han tratado de conectar con root
echo " "
echo "IPS QUE HAN FALLADO AL CONECTAR COMO ROOT"
grep "Failed password for root" /var/log/auth.log|cut -f 12 -d ' '| sort | uniq -c | sort -g

echo " "
echo "POSIBLES ATAQUES DE FUERZA BRUTA"
grep 'BREAK-IN' /var/log/auth.log

echo " "
echo "RELACIÓN DE IPS QUE PUDIERON REALIZAR LOS ATAQUES"
grep 'BREAK-IN' /var/log/auth.log| cut -d ' ' -f 13|grep '[.*]'|sort|uniq -c | sort -g

#Comprobamos las apariciones de CRON en el registro 
echo " "
echo "REGISTROS DE EJECUCIÓN DE CRON: "
grep "CRON" /var/log/auth.log |wc -l

echo " "
echo "MARGEN TEMPORAL DE LA ÚLTIMA ACTIVIDAD DE CRON: "
grep 'CRON' /var/log/auth.log|cut -d ' ' -f 4|tail -10

echo " "
echo "USUARIOS QUE HAN INTERVENIDO EN TAREAS DE CRON: "
grep "CRON" /var/log/auth.log|cut -d ' ' -f 12|sort | uniq -c

#Comprobamos las conexiones o intentos al servidor ftp
echo " "
echo "CONEXIONES REALIZADAS CON ÉXITO A SERVIDOR FTP: "
grep 'proftpd.*session opened.*' /var/log/auth.log

echo " "
echo "CONEXIONES A SERVIDOR FTP REALIZADAS POR: "
grep 'proftpd' /var/log/auth.log|cut -d ' ' -f 12|sort| uniq	