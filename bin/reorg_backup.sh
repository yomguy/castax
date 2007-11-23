#!/bin/sh
# 
# reorg_bckp.sh : reorganized data tree of the backups with symlinks
#		  recursively
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
# USAGE:
#
# $1 is the folder of the backup
# $2 is the folder of the new tree
#
# -------------------------------------------


if [ ! -d $2 ]; then
 mkdir $2
fi


for geo in `ls $1/`; do
 for freq in `ls $1/$geo`; do
   for umax in `ls $1/$geo/$freq`; do
    
    if [ ! -d $2/$umax ]; then
      mkdir $2/$umax
    fi
    if [ ! -d $2/$umax/$freq ]; then
      mkdir $2/$umax/$freq
    fi
    if [ ! -d $2/$umax/$freq/$geo ]; then
      ln -s $1/$geo/$freq/$umax $2/$umax/$freq/$geo
    fi


    done
  done
done

# end of reorg_bckp.sh
