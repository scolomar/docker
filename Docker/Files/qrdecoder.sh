#!/bin/sh
while true;
 do 
  sleep 100;
  for x in $(ls *.png);
   do
    [ -n "$x" ]&&[ ! -f "${x%.png}.txt" ]&&zbarimg -q $x 1>${x%.png}.txt;
   done;
 done;
