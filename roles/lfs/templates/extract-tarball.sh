#!/bin/bash

for _fn in `ls /mnt/lfs/sources/*.tar.*`
do

    if [ ${_fn##*.} == "gz" ]; then
        echo "tar -xvzf $fn"
    elif [ ${_fn##*.} == "xz" ]; then
        echo "tar -xvJf $fn"
    elif [ ${_fn##*.} == "bz2" ]; then
        echo "tar -xvjf $fn"
    else
        echo "No options for ${_fn##*.} extension"
    fi

    fn=${_fn##*/}
    echo ${fn%%.tar*}
done

