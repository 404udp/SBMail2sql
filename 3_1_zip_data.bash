#!/bin/bash

dat=`date +"%d%m%y%H%M"`
echo $dat
7z a -mx9 /4data_sudno_arh/$dat.7z /4data_sudno
rm -r /3data_unrar/*
rm -r /4data_sudno/*
