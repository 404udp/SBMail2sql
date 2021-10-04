#!/bin/bash

for file in /home/shipmail/Maildir/new/*;
do #копируем и перенсим почту в папки
#wc -l $file;
cp $file /2data_rar;
mv $file /1data_copy;
rm $file
done;

for file in /2data_rar/*one;
do #распаковываем письма, после распаковки удаляем
munpack -t $file -C /2data_rar;
##echo $file;
rm $file;
done;
echo "unrar to dir"
for fil in /2data_rar/*;
do # распаковываем файлы
#md /data_unrar/$file;
#fi="${fil%.}"
fi="${fil##*/}"

mkdir -p /3data_unrar/$fi;

#mkdir -p /data_unrar/$file1;
echo "unrar -x $fi /3data_unrar/$fi/";
unrar -x $fil /3data_unrar/$fi/;
rm $fil
done;