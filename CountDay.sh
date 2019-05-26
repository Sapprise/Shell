#!/bin/bash

allday=0
i=0
styear=$1
endyear=$2

function _run_year_ {
    for((i=${styear};i<=${endyear};i++ ));do
        if [[ (i%100 -ne 0 && i%4 -eq 0) || i%400 -eq 0 ]];then
            allday=$[ ${allday}+366 ]
        else
            allday=$[ ${allday}+365 ]
        fi
    done
return 
}

_run_year_
echo ${allday}


