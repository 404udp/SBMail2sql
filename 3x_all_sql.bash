#!/bin/bash
ship_dir="/4sudno/137/";
ships_dir="/4data_sudno/";

#ship="137";
i=1;
# табуляцию и двойный пробелы удаляем
#file="adam.data"
pathsql="/5data_sql/"
file_row_index=0 #текущий элемент file_list для соответсвия file_list_n
file_list=("adam.data" "boiler.data" "gps.data" "gpsriver.data" "t.data")   #таблицы для базы
file_list_n=(32 3 8 8 3) #колво первых столбцов для базы
#найти суда(папки), в которых есть интересующие нас данные
for file2ship in ${file_list[@]}
do #тут надо определить папку в которой есть любой из файлов и преобразовать ее путь к идентификатору судна
#echo $file2ship
#for file_path in $ships_dir/
#echo "find $ships_dir -name $file2ship"
file_find=`find $ships_dir -name $file2ship`
file_find2=( $file_find ) #преобразуем строку в массив
for file_path in "${file_find2[@]}" #перебираем пути с указанным файлом
do  #получаем конкретный путь к конкретному файлу
#echo $file_path; 
#echo $testf
#file_path="$ships_dir/145/adam.data"
ship=${file_path:13:3}
echo $ship
#done;

#: << 'end_file2ship'

#нужно найти пути ко всем папкам temp

# убираем второй столбец
###awk '{$2=""; print $0}' gps.data > temp.txt && mv temp.txt gps.data ##убираем дублир дату во втором столюце
###awk '{$2=""; print $0}' gpsriver.data > temp.txt && mv temp.txt gpsriver.data ##убираем дублир дату во втором столбце

#file_list=("adam.data" "boiler.data" "gps.data" "gpsriver.data" "t.data")   #таблицы для базы
#file_list=("gpsriver.data")   #таблицы для базы
#file_list_n=(32 3 8 8 3) #колво первых столбцов для базы
#file_list_n=(8) #колво первых столбцов для базы
#file_row_index=0
#for file in ${file_list[@]}
##04-10-2021
##for file in ${file_list[@]}
##do
file_row_n=${file_list_n[$file_row_index]}
echo $file_row_n
#echo "$file1=${file_list[0]}";
#fi
#done
#убираем херню из конца строки
#`sed -i -e 's/\r$//' $file`
`sed -i -e 's/\r$//' $file_path`
#убираем табуляции и сочетания пробелов
`cat $file_path | awk '{$1=$1}1' > $file_path.mod`

# убираем второй столбец
# если gps то убираем столбец с повтором времени
if [ "$file2ship" == "gps.data" ]
then
awk '{$2=""; print $0}' $file_path.mod > temp.txt && mv temp.txt $file_path.mod ##убираем дублир дату во втором столюце
fi
if [ "$file2ship" == "gpsriver.data" ]
then
awk '{$2=""; print $0}' $file_path.mod > temp.txt && mv temp.txt $file_path.mod ##убираем дублир дату во втором столбце
fi


#читаем содержимое и оставляем только строки с понятными данными
while read stroka
do
IFS=', ' read -r -a s_a <<< "$stroka"
#echo "stroka"
if [ "???" == "${s_a[2]}" ]
then
continue
echo "no ok"
fi
data_sh=""
i=0;
for n in ${s_a[@]}
do
#data_sh = "${data_sh} \'${s_a[$i]}\',"
#if [ "???" == "${s_a[2]}" ] #если начался лишний столбец
#then
#continue
#echo "no ok"
if [ $i -ge $file_row_n ]
then
continue
fi
data_sh+=" '${s_a[$i]}',"
#fi
i=$(($i+1))
done
shablon=""
#echo ${file_list[0]};
if [ "$file2ship" == "${file_list[4]}" ]
then
#echo "tempbox"
shablon="INSERT INTO \"tempbox\" ( \"dat\", \"tim\", \"tma\", \"id_ship\")VALUES ($data_sh ' $ship');";
fi
if [ "$file2ship" == "${file_list[3]}" ]
then
shablon="INSERT INTO \"gpshod\" (\"id_ship\", \"dat\", \"tim\", \"NS\", \"WE\", \"v1\", \"v2\", \"hsea\", \"xz\", \"id_ship\") VALUES ( $data_sh '$ship');";
fi
if [ "$file2ship" == "${file_list[2]}" ]
then
shablon="INSERT INTO \"gps\" ( \"dat\", \"tim\", \"NS\", \"WE\", \"v1\", \"v2\", \"hsea\", \"xz\", \"id_ship\") VALUES ($data_sh '$ship');";
fi
if [ "$file2ship" == "${file_list[1]}" ]
then
shablon="INSERT INTO \"boiler\" ( \"dat\", \"tim\", \"ma\", \"id_ship\") VALUES ( $data_sh '$ship');"
fi
if [ "$file2ship" == "${file_list[0]}" ]
then
#echo "OK<BR>"
shablon="INSERT INTO \"adam\" (\"dat\", \"time\", \"lsp1\", \"lsp2\", \"lsp3\", \"rsp1\", \"rsp2\", \"rsp3\", \"lt1\", \"lt2\", \"lt3\", \"lp1\", \"lp2\", \"lp3\", \"rt1\", \"rt2\", \"rt3\", \"rp1\", \"rp2\", \"rp3\", \"lot1\", \"lot2\", \"lot3\", \"pot1\", \"pot2\", \"pot3\", \"dg11\", \"dg12\", \"dg13\", \"dg21\", \"dg22\", \"dg23\", \"id_ship\") VALUES ($data_sh ' $ship');"
fi
#echo $stroka
#str_arr=$stroka;//в массив
#echo "${s_a[2]}"
#echo $shablon;
#echo $s_a;

#echo "$pathsql$ship$file2ship<BR>"
echo $shablon >> $pathsql$ship$file2ship.sql

done < $file_path.mod;
#done < $mod;

#echo $data_sh
#echo $shablon
##04-10-2021
##done #for file

#end_file2ship
done #для пути файла
#echo ${file_list[0]};
file_row_index=$((file_row_index+1))
done #для судна
