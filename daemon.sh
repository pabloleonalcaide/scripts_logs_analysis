#! /bin/bash

#script para  analizar el registro de daemon.log
#Pablo León Alcaide

echo " "
echo "MARGEN TEMPORAL DEL LOG: "
cat /var/log/daemon.log |head -1|cut -d ' ' -f -4
cat /var/log/daemon.log |tail -1|cut -d ' ' -f -4

echo " "
echo "NÚMERO DE REGISTROS: "
cat /var/log/daemon.log |wc -l
#Comprobamos las transferencias realizadas con éxito
echo " "
echo "REGISTRO DE TRANSFERENCIAS COMPLETAS REALIZADAS: "
grep 'transfer.*AXFR' /var/log/daemon.log| cut -d ' ' -f 8,11

echo " "
echo "REGISTRO DE TRANSFERENCIAS INCREMENTALES REALIZADAS: "
grep 'transfer.*IXFR' /var/log/daemon.log| cut -d ' ' -f 8,11

#mostramos el total de transferencias denegadas
echo " "
echo "REGISTRO DE TRANSFERENCIAS DENEGADAS: "
grep 'denied' /var/log/daemon.log|cut -d ' ' -f 8,11|sort|uniq -c|sort -g

#mostramos si se han realizado búsquedas dns inversas
echo " "
echo "BÚSQUEDAS DNS INVERSA: "
grep 'in-addr.arpa' /var/log/daemon.log
echo " "
echo "DIRECCIONES IP INVOLUCRADAS EN PETICIONES DENEGADAS: "
grep -v 'transfer' /var/log/daemon.log |cut -d ' ' -f 8|sort|uniq -c|sort -g

echo " "
IP=$(grep 'denied' /var/log/daemon.log |cut -d ' ' -f 8|sort|uniq -c|sort|tail -1| tr -s ' ' ' ' |cut -d ' ' -f 3)
echo " "
echo "DIRECCION IP CON MÁS PETICIONES DENEGADAS: " $IP

echo " " 
echo "ESTA IP HA REALIZADO PETICIONES A LOS SIGUIENTES DOMINIOS: "
grep $IP /var/log/daemon.log| cut -d ' ' -f 11|sort|uniq -c|sort -g

echo " "
echo "REGISTROS DE DIRECCIONES IPV4 (A):"
grep '/A/' /var/log/daemon.log
echo "REGISTROS DE DIRECCIONES IPV6 (AAAA):"
grep '/AAAAA/' /var/log/daemon.log
echo "REGISTROS DE TODOS LOS DATOS (ANY):"
grep '/ANY/' /var/log/daemon.log
echo "REGISTROS DE SERVIDOR DE NOMBRES (NS):"
grep '/NS/' /var/log/daemon.log
echo "REGISTROS DE INTERCAMBIO DE CORREO:"
grep '/MX/' /var/log/daemon.log
