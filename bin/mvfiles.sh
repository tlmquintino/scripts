#!/bin/bash

# RUN="echo"
ws="$HOME/dev"
dirs="$ws/eckit $ws/odb_api $ws/fdb $ws/mars.client $ws/mars.server"

from="$1"
to="$2"

[[ "$1" = "$2" ]] && echo "source equals destination -- skipping $1" && exit 0

[[ -z $from ]] && echo "missing origin file" && exit 1
[[ -z $to ]]   && echo "missing destination file" && exit 1

from_ns=$(dirname $from)
to_ns=$(dirname $to)

from_h=$( basename $from )
to_h=$( basename $to )

from_cc=$( echo $from_h | sed 's/\.h$/\.cc/' )
to_cc=$( echo $to_h | sed 's/\.h$/\.cc/' )

$RUN mkdir -p $to_ns

[[ -f $from_ns/$from_h ]]  && $RUN git mv $from_ns/$from_h  $to_ns/$to_h
[[ -f $from_ns/$from_cc ]] && $RUN git mv $from_ns/$from_cc $to_ns/$to_cc

$RUN git ci -am "move $from_ns/$from_h to $to_ns/$to_h"

fromfile=$( echo $from_ns/$from_h | sed 's/\.h$//' )
tofile=$( echo $to_ns/$to_h | sed 's/\.h$//' )

for d in $dirs
do
    echo $d

    find $d \(   \
        -iname "CMakeLists.txt" \
    -or -iname "*.cmake" \
    -or -iname "*.h"   \
    -or -iname "*.c"   \
    -or -iname "*.l"   \
    -or -iname "*.y"   \
    -or -iname "*.cpp" \
    -or -iname "*.cxx" \
    -or -iname "*.cc" \) -exec $RUN perl -pi -e "s#\b$fromfile\b#$tofile#g" {} \;

done

