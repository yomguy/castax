#!/bin/bash
# 
# pstompg_chpo: a script to transform castax .ps 2D isov results into mpg videos
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
# =======================================================================

# array of result prefixes (of postscsript files)
isof=( p_ c_ r_ vy_ vx_ tr_ hy_)
nf=${#isof[*]}
#($2 is the 2nd prefix)

# creates directory names
if [ $1 = "." ]; then
dirin=`pwd`
else
dirin=$1
fi
if [ $3 = "." ]; then
dirout=`pwd`
else
dirout=$3
fi

# checks if *.ps files exist
if [ ! -d $dirin/ps ]; then
cd $dirin
tar xzf ps.tgz
fi

if [ ! -d $dirout/videos ]; then
mkdir $dirout/videos
fi

cd $dirin/ps

# computes
for (( j = 0; j <= ($nf - 1); j++ )); do
echo "converting ${isof[$j]}$2(...).ps to mpeg video (maybe in background...)"
pstompg -q 1 -s 2 -n $4 ${isof[$j]}$2*
done

mv *.mpg $dirout/videos

echo $nf "Videos created"
date

# end of pstompg_all

