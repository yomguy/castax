#!/bin/sh
#
# comptprofil.sh counts the number of points defining a 2D profile 
# in a given text file
# It is part of Castax
#
# Usage : comptprofil.sh $1
#         where $1 is the text file.
# G. Pellerin

i=0
while [ true ]
 do
 read coorx coory
 if [ $? -ne 0 -o $? = END ]; then echo $i; break; fi
 i=$(echo "$i + 1" | bc)
done < $1