#!/bin/bash

max=1000
all=0
tot=0
function _chushihu_ {
    for ((i=0; i<=max; i++ ));do
        a[i]=0
        b[i]=0
    done
    return
}

function _xianxinsai_ {
    for ((j=2; j <= ${max}; j++));do
        if [[ a[j] -ne 1 ]]; then
            b[${tot}]=${j}
            all=$[ ${all}+${j} ]
            tot=$[ ${tot}+1 ]
        fi
        for (( m=0; m < ${tot}; ++m ));do
            if [[ $[ ${j} * ${b[m]} ] -gt ${max} ]]; then
                break
            fi
            a[$[ ${j} * ${b[m]} ]]=1
            if [[ $[ ${j} % ${b[m]} ] -eq 0 ]]; then
                break
            fi
        done
    done
}


_chushihu_
_xianxinsai_
echo ${all}
