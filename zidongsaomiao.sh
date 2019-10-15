#!/bin/bash

read -p "请输入文件地址：" wj

num=`cat $wj |wc -l`
js=0

echo "ip文件总共有行数：$num"

read -p "请输入要扫描的端口：" port 
for ((i=1;i<=$num;i++))
do
   a=`sed -n "$i,$i p" $wj`
   echo "准备执行：masscan -p $port $a --banners --rate 100000000 -oX $a"
   sleep 2
   masscan -p $port $a --banners --rate 100000000 -oX $i
   echo "扫描段：$a完成"
   sleep 1
   para1=`cat $i`
   if [ ! -n "$para1" ]
   then
	echo "IP段：$a 未发现任何符合条件：开启端口$port的主机，已自动为您删除文件!!"
	rm $i
	let js=js+1
   fi
   echo "当前是第$i条IP段，总计$num条"
done

wzjc=`cat *`

if [ $? -eq 0 ]
then
	let js=0
	echo "扫描已经完成！本次扫描有$js个IP段未发现符合条件的ip"
	cat * > hebinghouwenjian
	
	para0=`cat hebinghouwenjian`
	if [ ! -n "$para0" ]
	then
		echo "检测到文件hebinghouwenjian可能为空，已经为您删除"
		rm -rf hebinghouwenjian
	else
		echo "合并完成！！"
	fi
	cat hebinghouwenjian &>/dev/null
	if [ $? -eq 0 ]
	then
		cat hebinghouwenjian | grep 22 | cut -c 43-56 | tr "\"" "\n" | grep -v "a" | grep -v '^\s*$' | sort | uniq > 22
		cat hebinghouwenjian | grep 3389 | cut -c 43-56 | tr "\"" "\n" | grep -v "a" | grep -v '^\s*$' | sort | uniq > 3389
	else
		echo "hebinghouwenjian不存在"	
	fi


   	para2=`cat 22`
   	if [ ! -n "$para2" ]
   	then
		echo "22文件没有任何信息，已自动为您删除文件!!"
		rm 22
		let js=js+1
   	fi
	
	
   	para3=`cat 3389`
   	if [ ! -n "$para3" ]
   	then
		echo "3389文件没有任何信息，已自动为您删除文件!!"
		rm 3389
		let js=js+1
   	fi

	if [ $js -eq 2 ]
	then
		rm -rf hebinghouwenjian
		echo "检测到本次扫描无任何结果，已经为您清空无意义的文件！！"
	fi

	echo "本次扫描完成！！！"

elif [ $js -eq 0 ]
then

	echo "警告！！！！扫描可能不完整，请手动检测！！！"
else
	echo "未知错误!!!可能没有文件"
fi
