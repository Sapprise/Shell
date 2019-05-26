#!/bin/bash

MAXString=(0 0 0)
NameString=(0 0 0)
LenString=(0 0 0)

function _File_() {
    i_file=`cat $1 | tr -c "a-zA-Z" " " |tr -t " " "\n" |grep -v "^$" | wc -l`
    for(( j_file=1; j_file <= ${i_file}; j_file++ ));do
        str=`cat $1 | tr -c "a-zA-Z" " " | tr -t " " "\n" | grep -v "^$" | head -n ${j_file} | tail -n 1`
        len=${#str}
        if [[ ${len} -gt ${LenString[0]} ]]; then
            LenString[2]=${LenString[1]}
            LenString[1]=${LenString[0]}
            LenString[0]=${len}
            MAXString[2]=${MAXString[1]}
            MAXString[1]=${MAXString[0]}
            MAXString[0]=${str}
            NameString[2]=${NameString[1]}
            NameString[1]=${NameString[0]}
            NameString[0]=$1
        elif [[ ${len} -gt ${LenString[1]} ]]; then
            LenString[2]=${LenString[1]}
            LenString[1]=${len}
            MAXString[2]=${MAXString[1]}
            MAXString[1]=${str}
            NameString[2]=${NameString[1]}
            NameString[1]=$1
        elif [[ ${len} -gt ${LenString[2]} ]]; then
            LenString[2]=${len}
            MAXString[2]=${str}
            NameString[2]=$1
        fi
    done
}

function _Dir_(){
     local i_dir=`ls -A $1 | tr -t " " "\n" | wc -l`
     local j_dir=0
    for(( j_dir=1; j_dir<=${i_dir}; j_dir++ ));do
        dir_str=`ls -A $1 | tr -t " " "\n" | head -n ${j_dir} | tail -n 1`
        dir_str=`cd $1;pwd`/${dir_str}
        _Second_ ${dir_str} 1 ${numargv}
        if [[ -d ${dir_str} ]]; then
            _Dir_ ${dir_str}
        else
            _File_ ${dir_str}
        fi
    done
}
lon=0
function _Second_() {
    for((lon=$2; lon<=$3; lon++));do
        if [[ $1 -ef ${Argv[lon]} ]];then
            continue
        else
            return 0
        fi
    done
}

for i in $@;do
    if [[ -d $i || -f $i ]];then
        Argv+=($i)
    else
        exit
    fi
done

numargv=$#
for(( j=0; j<=numargv; j++));do
    j_num=$[ ${j} ]
    _Second_ ${Argv[j]} ${j_num} ${numargv}
    if [[ $? -eq 0 ]];then
        if [[ -d ${Argv[j]} ]];then
            _Dir_ ${Argv[j]}
        else
            _File_${Argv[j]}
        fi
    fi
done

echo "${LenString[0]}:${MAXString[0]}:${NameString[0]}:`grep -n "${MAXString[0]}" ${NameString[0]} | cut -d ":" -f 1`"
echo "${LenString[1]}:${MAXString[1]}:${NameString[1]}:`grep -n "${MAXString[1]}" ${NameString[1]} | cut -d ":" -f 1`"
echo "${LenString[2]}:${MAXString[2]}:${NameString[2]}:`grep -n "${MAXString[2]}" ${NameString[2]} | cut -d ":" -f 1`"
