#!/bin/bash

url="https://gnews.io/api/v4/top-headlines"
key="af81b153fbf013040bd55c61f2436f85"
categoria="technology"
idioma="en"
pais="us"
max=5

respuesta=$(curl -s "$url?category=$categoria&lang=$idioma&country=$pais&max=$max&apikey=$key")
i=0
j=1
directorio="Noticias"
archivo="Resumen"
contador=1

if [ -d $directorio ]
then
	cd $directorio
	comparador=$(echo $(ls) | awk '{print $NF}')
	if [ -f $comparador ]
	then
		contador=${comparador:0:1}
		((contador++))
	fi
else
	mkdir $directorio
	cd $directorio
fi


if [ $(echo $(ls) | awk '{print $NF}')  ]
then
	validador=1
	echo "Contiene"
else
	validador=0
	echo "Vacio"
fi


while [ $i -lt $max ];
do	
	titulo=$(echo $respuesta | jq ".articles[$i].title")
	descripcion=$(echo $respuesta | jq ".articles[$i].description")
	titulo=${titulo//'"'}
	titulo=${titulo//'/'}
	titulo=${titulo//'\'}
	descripcion=${descripcion//'"'}
	descripcion=${descripcion//'/'}
	descripcion=${descripcion//'\'}
	if [ $validador -eq 0 ]
	then
		echo "Noticia" $j >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
		echo "Titulo:" $titulo >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
		echo -e "Descripcion:" $descripcion "\n" >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
		((j++))
	else
		for var in $(ls); do
			tituloComp=$(grep "$titulo" $var)
			if [ -z "$tituloComp" ];
			then
				echo "No existe"
				val=1
			else
				echo "Ya existe la noticia"
				val=0
				break
			fi
		done
		if [ $val -eq 1 ];
		then
			echo "Noticia" $j >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
			echo "Titulo:" $titulo >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
			echo -e "Descripcion:" $descripcion "\n" >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
			((j++))
		fi
	fi
	((i++))
done

#respuesta=$(curl -s "https://pokeapi.co/api/v2/pokemon")

#while [ $i -lt $max ];
#do
#	titulo=$(echo $respuesta | jq ".results[$i].name")
#	descripcion=$(echo $respuesta | jq ".results[$i].url")
#	titulo=${titulo//'"'}
#	descripcion=${descripcion//'"'}
#	if [ $validador -eq 0 ]
#	then
#		echo "Noticia" $j >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
#		echo "Titulo:" $titulo >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
#		echo -e "Descripcion:" $descripcion "\n" >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
#	else
#		for var in $(ls); do
#			tituloComp=$(grep $titulo $var)
#			echo $tituloComp
#			if [ -z "$tituloComp" ];
#			then
#				echo "No existe"
#				val=1
#			else
#				echo "Ya existe la noticia"
#				val=0
#				break
#			fi
#		done
#		if [ $val -eq 1 ];
#		then
#			echo "Noticia" $j >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
#			echo "Titulo:" $titulo >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
#			echo -e "Descripcion:" $descripcion "\n" >> $contador$archivo"_"$(date '+%d-%m-%Y').txt
#			break
#		fi
#	fi
#	((i++,j++))
#done

#cat resumen.txt



