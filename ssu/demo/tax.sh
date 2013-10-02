i=$1
if [ $i -lt 0 ];then
	echo "-1"
fi
i=$(($i*105))
i=$(($i/100))
echo $i




