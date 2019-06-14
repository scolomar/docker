#!/bin/sh
while true;
 do 
  date=$(date +%F_%Hh%Mm%Ss);
  qrencode -o $(hostname).$date.png $date;
  sleep 100;
 done
