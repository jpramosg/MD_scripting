#!/bin/bash 
## primer comando para editar el archivo de los archivos .str y .prm 
## seleccion linea final de .str y .prm, 
## lo que esta en (  ) es lo seleccionado 
## \1 significa utilizar el string extraido de (  ) y agregarlo alli
## \ escape los metacaracteres 
## \s es un espacio en blanco 

## autor == Jean Pierre Ramos 

## Probar que existan ambos directorios 

if [ -d "run" ] && [ -d "setup" ] 
then
	echo "Existe ambos directorios"
#mkdir 01_Mini 02_Anneal 03_EQ 04_SMD files toppar 
else 
	echo "Error !!! run or/and setup folder doesnt exist"
	exit 1

## ajustar las condiciones de temperatura 
## Modificar solo anneling.conf 

cd run

sed "s/\(binVelocities\)/#\1/g" Annealing.conf > tmp.conf && rm Annealing.conf && mv tmp.conf Annealing.conf  
sed "s/#\(temperature\)/\1/g" Annealing.conf > tmp.conf && rm Annealing.conf && mv tmp.conf Annealing.conf 



## Modificate files .conf 

## & añade string despues de la coincidencia 
## "0,/conditions/ es el rango especificador, buscar desde cero hasta la primera coincidencia
## conditions y luego match con conditions agregar set replica 
for file in *.conf; do
	## agregar la ruta de los archivos de topologia y de referencia 
	sed 's/\s\(.*\.str\|.*\.prm\)/ \.\.\/toppar\/\1/g' $file > tmp.conf && rm $file && mv tmp.conf $file   
    sed 's/\s\(.*\.pdb\|.*\.psf\)/ \.\.\/files\/\1/g' $file > tmp.conf && rm $file && mv tmp.conf $file
    # cambiamos el tiempo de cada 2 ps a 5 ps 
    sed "/\sOutput\s/,/\sThermostat\s/s/1000/2500/" $file > tmp.conf && rm $file && mv tmp.conf $file  
    sed "s/.*dedfreq\s1/&\nstepspercycle 10/"
  
done 

## Move the files to folder create 
mv Minimization.conf ../01_Mini 
mv Minimization.xsc ../01_Mini 
mv Annealing.conf ../02_Anneal
mv Equilibration.conf ../03_EQ  
mv SMD.conf ../04_SMD 
mv *.psf ../files
mv *.pdb ../files 
mv *.prm ../toppar 
mv *.str ../toppar 

cd .. 

rm -r setup 
rm -r run 


## agregar la variable replica 
 #sed "/\sOutput\s/,/\sThermostat\s/s/\sMinimization/&_\$replica/" $file > tmp.conf && rm $file && mv tmp.conf $file 
 #sed "/\sScript/,$ s/\sMinimization/&_\$replica/g" $file > tmp.conf && rm $file && mv tmp.conf $file

