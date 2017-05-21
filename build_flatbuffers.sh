#!/bin/sh

cd `dirname $0`

read -p "Input '1234' to comfirm: " code
if [ $code != "1234" ] ;  then  
  echo "Bad input!!"
  exit 1
fi

cur_dir=`pwd`
IDL_dir=$cur_dir"/fbs/"  
source_dir=$cur_dir"/Example/MyFlatBuffers/src/"  

rm -rf ${source_dir}  
mkdir -p ${source_dir} 

cd $IDL_dir

cd $source_dir
fp=$cur_dir"/flatc/flatc"

for d in `ls $IDL_dir`
do
	dir="$IDL_dir"${d}
	for k in `ls $dir`
	do
		if [ ${k##*.} == 'fbs' ] ; then 
			path=" -sw ""${k}"
			command=`${fp}${path}`
			$command
		fi
	done
done

pod update --no-repo-update

