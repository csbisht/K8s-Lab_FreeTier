#!/bin/bash

getckalabscript=( `ls $HOME/K8s-Lab-Questions/Start_CKA_Lab*.sh |cut -d'/' -f5` )


echo -e "There are ${#getckalabscript[@]} CKA Labs right now"
for i in ${!getckalabscript[@]}
do
labnum=`expr "$i" + 1`
echo "$labnum) Lab"$labnum""
done
echo "please type Lab number to run. Start from First lab if first time:"
read CKA

checkusrout=`echo ${getckalabscript[@]} |grep -w Start_CKA_Lab"${CKA}".sh`
usrout="$?"
if [ "${usrout}" = 0 ];then
####run lab
$HOME/K8s-Lab-Questions/Start_CKA_Lab"${CKA}".sh
else
echo "please re-run script and share correct lab number"
fi
