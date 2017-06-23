#! /bin/bash

#script para  analizar el registro de peticiones en access.log
#Pablo León Alcaide


#comprobamos la primera y última fecha del registro
echo "MARGEN TEMPORAL DEL REGISTRO: "
cut -f 4 -d ' ' /var/log/apache2/access.log| cut -f 1 -d ':' |head -1|tr -d [
cut -f 4 -d ' ' /var/log/apache2/access.log| cut -f 1 -d ':' |tail -1|tr -d [

#comprobamos el número de peticiones, ignorando las peticiones locales de control (::1)
echo " "
echo "NÚMERO DE PETICIONES EN ESE PERIODO: "
cat /var/log/apache2/access.log |grep -v '::1'|wc -l 

#comprobamos, dentro de las urls, aquellas que más peticiones de acceso han tenido
echo " "
echo "EL MAYOR NÚMERO DE PETICIONES SE HAN REALIZADO A LAS SIGUIENTES DIRECCIONES: "
cat /var/log/apache2/access.log |cut -f 7 -d ' '|sort| uniq -c| sort -g |grep -v '*' |tail -5| cut -f 6 -d ' '

#comprobamos, dentro de las ips que han realizado peticiones, aquella que más veces se repite
IP=$(cut -d ' ' -f 1 /var/log/apache2/access.log | sort | uniq -c | sort -g |grep -v '::1' |tail -1 |cut -d ' ' -f 4)

echo " "
echo "IP CON MAYOR NÚMERO DE PETICIONES:" $IP

echo " "
echo "ESTA IP HA REALIZADO MAYOR NÚMERO DE PETICIONES A:"
#filtramos la búsqueda por la ip que ha realizado más peticiones
grep $IP /var/log/apache2/access.log |cut -f 7 -d ' '|sort| uniq -c| sort -g | tail -5 | cut -f 8 -d ' '

#con la ip filtrada, comprobamos desde que navegador se ha accedido
echo " "
echo "ACCESOS REALIZADOS DESDE: "
grep $IP /var/log/apache2/access.log| cut -f 4 -d '-'|grep '" "'|cut -f 2 -d ' '|sort| uniq


echo " "
echo "LAS IPS QUE MÁS PETICIONES HAN REALIZADO FUERON: "
echo "cantidad IP"
cut -d ' ' -f 1 /var/log/apache2/access.log | sort | uniq -c | sort -g |grep -v '::1' |tail -10 
