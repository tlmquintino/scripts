#!/bin/bash
if [ ! "$1" ] ; then
    echo "Usage: $0 <search>";
    exit
fi

# doesnt search hidden files or directories
# filters out "data files" 

find . \( ! -regex '.*/\..*' \) -and -type f -print0 \
  | xargs -0 file \
  | awk '{ if ($2 != "data") print $1 }' \
  | cut -d: -f1 \
  | xargs -i% grep -Pil "$1" "%"
