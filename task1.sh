#!/bin/bash
getEmail(){ 
        local IFS=' ' 
        oldemail1=( ${oldcsv[2]} )
        firstA1=${oldcsv[2]:0:1}
        NewEmail1=${firstA1,,}${oldemail1[1],,}
        echo $NewEmail1
        }
IFS=,
while read -ra oldcsv; do
    if [ "${oldcsv[0]}" == "id" ]; then
        echo "${oldcsv[0]},${oldcsv[1]},${oldcsv[2]},${oldcsv[3]},${oldcsv[4]},${oldcsv[5]}" >> accounts_new.csv
    else
        coincidence=0 
        Id=${oldcsv[0]}
        Location_Id=${oldcsv[1]}
        uppercase() {
        local IFS=' ' 
        oldname=( ${oldcsv[2]} )
        for nami in "${oldname[@]}"; do
            NewName+=( "${nami^}" )
        done
        }
        uppercase
        t='"'
        if [[ ${oldcsv[*]} =~ .*${t}.* ]]; then
            Title_=${oldcsv[3]},${oldcsv[4]}
            Department_=${oldcsv[6]}
        else Title_=${oldcsv[3]}
            Department_=${oldcsv[5]}
        fi
        n='@'
        if [[ ${oldcsv[*]} =~ .*${n}.* ]]; then
            NewEmail=${oldcsv[4]}
        else account=`getEmail`
            suffix1="@abc.com"
            NewEmail=${account}${Location_Id}${suffix1}
        fi
        echo "$Id,$Location_Id,${NewName[@]},$Title_,$NewEmail,$Department_" >> accounts_new.csv 
        unset NewName
    fi
done <$1
