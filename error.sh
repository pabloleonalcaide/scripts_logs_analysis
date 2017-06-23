#! /bin/bash

#script para  analizar el registro de peticiones en /var/log/apache2/error.log
#Pablo León Alcaide

#comprobamos el margen de tiempo desde el inicio al fin del registro
echo "MARGEN TEMPORAL DEL REGISTRO: "
cut -f 4 -d ' ' /var/log/apache2/error.log| cut -f 1 -d ':' |head -1|tr -d [
cut -f 4 -d ' ' /var/log/apache2/error.log| cut -f 1 -d ':' |tail -1|tr -d [

#comprobamos el número de entradas de error en el registro
echo " "
echo "NÚMERO DE REGISTROS DE ERROR: "
cat /var/log/apache2/error.log |wc -l 

#filtramos las entradas según el tipo de aviso 
echo " "
echo "NÚMERO Y TIPO DE ENTRADAS: "
cat /var/log/apache2/error.log |cut -f 3 -d '['|sort|uniq -c|sort -g|tr -d ]

#comprobamos que mensaje se repite en más ocasiones dentro del registro
echo " "
echo "ERROR/WARNING'MÁS REPETIDO: "
cat /var/log/apache2/error.log|cut -f 4 -d ']'|sort|uniq -c|sort -g|tail -1


#comporobamos la dirección que ha provocado mayor número de errores
client=$(cat /var/log/apache2/error.log|cut -f 4 -d '['|cut -f 1 -d ']'|sort|uniq -c|sort -g|tail -1|cut -f 6 -d ' ')
echo " "
echo "CLIENTE CON MÁS ENTRADAS EN EL REGISTRO: " $client


#comprobamos y agrupamos el tipo de errores lanzados por ésta ip
echo " "
echo "ERRORES LANZADOS POR ESTA IP: "
grep $client /var/log/apache2/error.log |cut -f 4 -d ']'|sort| uniq


#comprobamos las direcciones que más errores provocan, en este caso ignoramos el error sh: 1: /usr/bin/convert: not found 
#dado que no es un error propio de php, sino de una librería que utiliza ImageMagick
echo " "
echo "DIRECCIONES IP CON MAYOR REGISTRO DE ERRORES: "
cat /var/log/apache2/error.log|cut -f 4 -d '['|cut -f 1 -d ']'|sort|uniq -c|sort -g|grep -v 'sh'|	tail -10|tr -s ' ' ' '|cut -f 4 -d ' '