#!/bin/bash
item="$1"
itemname=${item##*/}
path=`find / -iname "$itemname" 2>/dev/null`
a="["
b="-"
c="n" #for string "not ok"
d="o" #for string "ok"
q=$'\042' #quote
while read -ra output_txt; do
first_character=${output_txt[0]:0:1} #the first character of the line
count=`echo ${output_txt[*]} | gawk 'BEGIN{FS=","}{print NF}'` # count fields of the line
    if [ $first_character == $a ]; then
    #field test name
        testName=`echo ${output_txt[*]} | gawk -F, '{print $1}' | sed -e "s/^.\{,2\}//;s/.\{,2\}$//"`
        echo -e "{\n\t${q}testName${q}: ${q}${testName}${q},\n\t${q}tests${q}: [" >> output.json
        continue
    fi    
    if [ $first_character == $b ]; then
        continue
    fi    
    if [ $first_character == $c ];then
        if [ $count == 2 ]; then
            sname=`echo ${output_txt[*]} | gawk -F, '{print $1}' | cut -c 10-` 
            status="false"
            duration=`echo ${output_txt[*]} | gawk -F, '{print $2}' | sed -e "s/^.//"` 
            echo -e "\t{\n\t\t${q}name${q}: ${q}${sname}${q},\n\t\t${q}status${q}: $status,\n\t\t${q}duration${q}: ${q}$duration${q}\n\t}," >> output.json
            continue
        else
            sname=`echo ${output_txt[*]} | gawk 'BEGIN{FS=","; OFS=","}{print $1,$2}' | cut -c 10-` 
            status="false"
            duration=`echo ${output_txt[*]} | gawk -F, '{print $3}' | sed -e "s/^.//"` 
            echo -e "\t{\n\t\t${q}name${q}: ${q}${sname}${q},\n\t\t${q}status${q}: $status,\n\t\t${q}duration${q}: ${q}$duration${q}\n\t}," >> output.json
            continue
        fi
    fi
    if [ $first_character == $d ];then
        if [ $count == 2 ]; then
            sname=`echo ${output_txt[*]} | gawk -F, '{print $1}' | cut -c 6-` 
            status="true"
            duration=`echo ${output_txt[*]} | gawk -F, '{print $2}' | sed -e "s/^.//"` 
            echo -e "\t{\n\t\t${q}name${q}: ${q}${sname}${q},\n\t\t${q}status${q}: $status,\n\t\t${q}duration${q}: ${q}$duration${q}\n\t}," >> output.json
            continue
        else
            sname=`echo ${output_txt[*]} | gawk 'BEGIN{FS=","; OFS=","}{print $1,$2}' | cut -c 6-` 
            status="true"
            duration=`echo ${output_txt[*]} | gawk -F, '{print $3}' | sed -e "s/^.//"` 
            echo -e "\t{\n\t\t${q}name${q}: ${q}${sname}${q},\n\t\t${q}status${q}: $status,\n\t\t${q}duration${q}: ${q}$duration${q}\n\t}," >> output.json
            continue
        fi
    fi
done <${path}
lastLine=`tail -1 ${path}`
success=${lastLine:0:1}
failed=`echo $lastLine | gawk -F, '{print $2}' | cut -b 2`
rating=`echo $lastLine | gawk -F, '{print $3}' | gawk '{print $NF}' | sed 's/%$//'`
duration=`echo $lastLine | gawk -F, '{print $4}' | gawk '{print $NF}'`
sed -i '$ s/.$//' output.json # remove the comma from the last line 
echo -e "\t],\n\t${q}summary${q}: {\n\t\t${q}success${q}: $success,\n\t\t${q}failed${q}: $failed,\n\t\t${q}rating${q}: $rating,\n\t\t${q}duration${q}: ${q}$duration${q}\n\t}\n}" >> output.json
