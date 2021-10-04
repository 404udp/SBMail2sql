#!/bin/bash
dir2sudno="/4data_sudno/"
#сортируем по папкам суден
for filer in /3data_unrar/*/*/*/*.data;
do
d=${filer:13:3}
#узнаем папку с идентификатором судна 
# имя файла
d2=${filer:49}

# папка куда записывать данные судна
fil2="$dir2sudno$d/$d2"
#echo $dir2sudno$d
#проверяем есть ли папка, если нет то создаем
if ! [ -d $dir2sudno$d ]
then
echo "making shipdir"
mkdir $dir2sudno$d
fi
#если нет файла то создаем пустой
if [[ ! -e "$fil2" ]]; then
cat /dev/null >  $fil2
echo "ok"
fi
#объединяем файлы
cat $filer >> $fil2
#rm $filer
done;

#for dir2del in /3data_unrar/*;
#do
rm -r /3data_unrar/*
#done
