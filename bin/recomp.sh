#!/bin/sh
# 
# recomp - recomputes data recursively for an entire result folder 
#
# This program is part of Castax.
#
# Copyright (C) 2002-2005 by Guillaume Pellerin <pellerin@ccr.jussieu.fr>
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software.  You can  use, 
# modify and/ or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info". 
# 
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability. 
# 
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or 
# data to be ensured and,  more generally, to use and operate it in the 
# same conditions as regards security. 
# 
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.
# ------------------------------------------
#
# $1 is the result folder
# $2 is the dgibi script for recomputing
#
# -------------------------------------------

cd $1

for geo in `ls`; do
 cd $1/$geo
 pwd
 for freq in `ls`; do
  cd $1/$geo/$freq
  pwd
   for umax in `ls`; do
    cd $1/$geo/$freq/$umax
    pwd

	# checks directories, untar and executes

	if [ ! -d recomp ]; then

	    if [ ! -e data.sauv ]; then
		echo "extracting data.sauv..."
		tar xzvf data.tgz
		if [ ! -e data.sauv ]; then
		    mv $geo/$freq/$umax/data.sauv ./
		    rm -rf $geo
		fi
	    fi
	
	    if [ -e output.tgz ]; then
		echo "extracting output.txt..."
		tar xzvf output.tgz
	    fi
	
	echo "creating recomp/ folder"
	mkdir recomp
	
	# verify if computing has been done
	# here : TRAX
	#if [ -e output.txt ]; then
	# comp=`cat output.txt | grep "TRAX"`
	#fi
	#if [ ! $comp = /dev/null -o ! -e output.txt ]; then
	
	# get the lastest utilproc.dgibi and tools
	cat $CASTAX/proc/*.dgibi > $CASTAX/tmp/utilproc.dgibi
	cp -a $CASTAX/tmp/utilproc.dgibi .
	cp $CASTAX/dgibi/$2 .
	#
	# gives procedures
	cat utilproc.dgibi $2 > castax_recomp.dgibi
	#
	# start cast3m
	castem castax_recomp.dgibi &&
	#
	# creates videos
	#for post in recomp/; do
	  cd recomp
	  pstompg -q 1 -s 2 -n 4 *.ps &
	  cd ..
	#done
	# remove temp files
	if [ -e data.tgz ]; then
	  rm data.sauv
	fi
	
	rm r_rest*
	rm UTIL*
	rm castax_recomp.dgibi
	
	#fi
	fi

    done
  done
done
