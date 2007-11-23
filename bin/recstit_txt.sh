#!/bin/sh
# 
# recstit_txt.sh : restitute txt datas recursively for an entire result folder 
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

	if [ ! -d txt ]; then
          echo "extracting txt/* ..."
	  tar xzf txt.tgz
	        # old bug
		if [ ! -s txt ]; then
		    mv $geo/$freq/$umax/txt .
		    rm -rf $geo
		fi
	fi

    done
  done
done
