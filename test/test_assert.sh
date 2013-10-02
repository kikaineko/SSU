. ../ssu/SSU.sh

my_assert_log(){
	typeset f=$1
	l=`grep -v 31m $f |grep -i [a-z] |wc -l |cut -c 1`
	assert_num 0 $l
}
test_assert_num(){
	assert_num 0 0
	assert_num 0       0    
	assert_num 1 1
	assert_num 111111 111111
	assert_num -1 -1
	
	h_make_file aa
	assert_exit_code "assert_num 1 2" 99 > aa
	my_assert_log aa
	
	assert_exit_code "assert_num -1 1" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_num 1111111 1111112" 99 > aa
	my_assert_log aa

	h_make_file bb
	assert_exit_code "assert_num aaaa aaaa" 99 > aa 2> bb
	my_assert_log aa
	assert_include_in_file "integer expression expected" bb
	
	#111111111111111111111111111111111111111111111111 is not number(integer)
	assert_exit_code "assert_num 111111111111111111111111111111111111111111111111 111111111111111111111111111111111111111111111111"  99 > aa 2> bb
	my_assert_log aa
	assert_include_in_file "integer expression expected" bb
	
	#ARG
	assert_num -1 -1 pooh
	assert_exit_code "assert_num 1 2 pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	assert_exit_code "assert_num 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	
}
test_assert_not_same_num(){
	assert_not_same_num -1 -2
	assert_not_same_num 0 1
	assert_not_same_num        0               1
	assert_not_same_num 0 10000000000
	
	h_make_file aa
	h_make_file bb
	#111111111111111111111111111111111111111111111111 is not number(integer)
	assert_exit_code "assert_not_same_num 111111111111111111111111111111111111111111111111 111111111111111111111111111111111111111111111111" 99 > aa 2> bb
	my_assert_log aa
	assert_include_in_file "integer expression expected" bb
	
	assert_exit_code "assert_not_same_num 1 1" 99 > aa
	my_assert_log aa
	
	assert_exit_code "assert_not_same_num -1 -1" 99 > aa
	my_assert_log aa
	
	assert_exit_code "assert_not_same_num aaaa bbc" 99 > aa 2> bb
	my_assert_log aa
	assert_include_in_file "integer expression expected" bb
	
	#ARG
	assert_not_same_num 0 10000000000 pooh
	assert_exit_code "assert_not_same_num 1 1 pooh" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_not_same_num 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	
}

test_assert_file(){
	h_make_file aa
	assert_file aa
	if [ -w ../ ];then
		h_mkdir ../gggg
		h_mkdir ../gggg/bb
		h_mkdir ../gggg/bb/cc
		h_mkdir ../gggg/bb/cc/dd
		h_make_file ../gggg/bb/cc/dd/aa
		assert_file ../gggg/bb/cc/dd/aa
	fi
	h_rm aa
	
	h_make_file cc
	assert_exit_code "assert_file aa" 99 > cc
	my_assert_log cc
	
	h_rm ../gggg/bb/cc/dd/aa
	assert_exit_code "assert_file ../gggg/bb/cc/dd/aa" 99 > cc
	my_assert_log cc
	
	if [ -w / ];then
		h_mkdir /gggggg
		h_mkdir /gggggg/uuu
		h_make_file /gggggg/uuu/ii
		assert_file /gggggg/uuu/ii
		h_rm /gggggg/uuu/ii
		assert_exit_code "assert_file /gggggg/uuu/ii" 99 > cc
		my_assert_log cc
	
		h_make_file dd
		assert_exit_code "assert_file /gggggg" 99 > cc
		my_assert_log cc
	fi
	
	#ARG
	assert_file cc pooh
	assert_exit_code "assert_file ../gggg/bb/cc/dd/aa00 pooh" 99 > cc
	my_assert_log cc
	assert_include_in_file pooh cc
	assert_exit_code "assert_file ../gggg/bb/cc/dd/aa00 1 1 1" 99 > cc
	assert_include_in_file "Wrong Arguments" cc
}

test_assert_same_file(){
	h_make_file aa
	h_make_file bb
	
	echo 1111 > aa
	echo 1111 > bb
	
	assert_same_file aa bb
	
	h_cp aa cc
	assert_same_file aa cc
	
	h_mkdir gggggg
	h_mkdir gggggg/uuu
	h_make_file gggggg/uuu/ii
	
	echo 1111 > gggggg/uuu/ii
	
	assert_same_file gggggg/uuu/ii aa
	
	echo 111111 > gggggg/uuu/ii
	
	h_cp gggggg/uuu/ii gggggg/uuu/ii1
	assert_same_file gggggg/uuu/ii gggggg/uuu/ii1
	assert_exit_code "assert_same_file gggggg/uuu/ii aa" 99 > /dev/null 2>&1
	h_rm aa
	assert_exit_code "assert_same_file gggggg/uuu/ii aa" 99 > /dev/null 2>&1
	h_rm gggggg/uuu/ii
	assert_exit_code "assert_same_file gggggg/uuu/ii aa" 99 > /dev/null 2>&1
	h_cp ${SSU_SELFPATH}/ssu.jar hoge.jar
	assert_same_file ${SSU_SELFPATH}/ssu.jar hoge.jar
	
	assert_exit_code "assert_same_file gggggg/uuu gggggg/uuu" 99 > /dev/null 2>&1
	
	
	#ARG
	h_make_file aa
	h_make_file bb
	echo 1111 > aa
	echo 1111 > bb
	assert_same_file aa bb pooh
	echo 22 > bb
	assert_exit_code "assert_same_file aa bb pooh" 99 > /dev/null 2>&1
	
	
	#ARG
	h_make_file aa
	h_make_file bb
	
	echo 1111 > aa
	echo 1111 > bb
	
	assert_same_file aa bb pooh
	assert_same_file aa aa pooh
	assert_exit_code "assert_same_file aa bb pooh" 99 > bb
	my_assert_log bb
	assert_include_in_file pooh bb
	assert_exit_code "assert_same_file aa aa pooh 11" 99 > bb
	assert_include_in_file "Wrong Arguments"  bb
}


test_assert_not_same_file(){
	h_make_file aa
	h_make_file bb
	
	echo 1111 > aa
	echo 11 > bb
	
	assert_not_same_file aa bb
	
	h_cp aa cc
	assert_exit_code "assert_not_same_file cc aa" 99 > /dev/null 2>&1
	
	h_mkdir gggggg
	h_mkdir gggggg/uuu
	h_make_file gggggg/uuu/ii
	
	echo 1111222 > gggggg/uuu/ii
	assert_not_same_file aa gggggg/uuu/ii
	
	echo 111111 >> gggggg/uuu/ii
	
	h_cp gggggg/uuu/ii gggggg/uuu/ii1
	assert_exit_code "assert_not_same_file gggggg/uuu/ii gggggg/uuu/ii1" 99 > /dev/null 2>&1
	
	h_rm aa
	assert_exit_code "assert_not_same_file gggggg/uuu/ii aa" 99 > /dev/null 2>&1
	
	h_rm gggggg/uuu/ii
	assert_exit_code "assert_not_same_file gggggg/uuu/ii aa" 99 > /dev/null 2>&1
	
	h_cp ${SSU_SELFPATH}/ssu.jar hoge.jar
	assert_exit_code "assert_not_same_file ${SSU_SELFPATH}/ssu.jar hoge.jar" 99 > /dev/null 2>&1
	
	#ARG
	h_make_file aa
	h_make_file bb
	
	echo 1111 > aa
	echo 22 > bb
	
	assert_not_same_file aa bb pooh
	assert_exit_code "assert_not_same_file aa aa pooh" 99 > bb
	my_assert_log bb
	assert_include_in_file pooh bb
	assert_exit_code "assert_not_same_file aa aa pooh 11" 99 > bb
	assert_include_in_file "Wrong Arguments"  bb
}

test_assert_blank_file(){
	h_make_file aa
	assert_blank_file aa
	
	echo 1 > aa
	
	assert_exit_code "assert_blank_file aa" 99 > /dev/null 2>&1
	
	h_make_file bb
	assert_blank_file bb
	h_rm bb
	assert_exit_code "assert_blank_file bb" 99 > /dev/null 2>&1
	
	h_mkdir uuuu
	h_make_file uuuu/ii
	assert_blank_file  uuuu/ii
	echo 1 > uuuu/ii
	assert_exit_code "assert_blank_file  uuuu/ii" 99 > /dev/null 2>&1
	assert_exit_code "assert_blank_file  uuuu" 99  > /dev/null 2>&1
	
	#ARG
	h_make_file bb
	h_make_file uuuu/ii
	assert_blank_file  uuuu/ii pooh
	assert_exit_code "assert_blank_file aa0 pooh" 99 > bb
	my_assert_log bb
	assert_include_in_file pooh bb
	
	assert_exit_code "assert_blank_file  aa0 pooh 1" 99 > bb
	my_assert_log bb
	assert_include_in_file "Wrong Arguments" bb
}

test_assert_include_in_file(){
	h_make_file aa
	echo 1111 > aa
	assert_include_in_file 11 aa
	assert_exit_code "assert_include_in_file 22 aa" 99 > /dev/null 2>&1
	
	h_mkdir uuuu
	h_make_file uuuu/ii
	echo 1111 > uuuu/ii
	echo 2222 >> uuuu/ii
	assert_include_in_file 11 uuuu/ii
	assert_exit_code "assert_include_in_file 33 uuuu/ii" 99 > /dev/null 2>&1
	assert_exit_code "assert_include_in_file 11 uuuu" 99 > /dev/null 2>&1
	
	assert_exit_code "assert_include_in_file poohpoohpooh ${SSU_SELFPATH}/ssu.jar" 99 > /dev/null 2>&1
	
	h_make_file aa
	echo "uu" > aa
	echo "ii" >> aa
	
	h_make_file bb
	echo "u" > bb
	echo "i" >> bb
	typeset s=`cat bb`
	assert_include_in_file "$s" aa
	
	echo "u" > bb
	echo "i3" >> bb
	s=`cat bb`
	assert_include_in_file "$s" aa  > /dev/null &
	typeset jid=$!;
	wait $jid;
	typeset r=$?
	assert_num 99 $r
	
	#ARG
	assert_include_in_file 11 uuuu/ii pooh
	echo 111 > uuuu/ii
	
	assert_exit_code "assert_include_in_file poohpoohpooh ${SSU_SELFPATH}/ssu.jar pooh" 99 > aa 2> /dev/null
	my_assert_log aa
	assert_include_in_file pooh aa
	
	assert_exit_code "assert_include_in_file poohpoohpooh ${SSU_SELFPATH}/ssu.jar pooh 1" 99 > aa 2> /dev/null
	assert_include_in_file "Wrong Arguments" aa
	
	h_make_file vv
	assert_exit_code "assert_include_in_file poohpoohpooh vv pooh" 99 > aa 2> /dev/null
	my_assert_log aa
	assert_include_in_file pooh aa
	
}
SSU_HOME="../ssu"
date
#SSU_TEST_PATTERN="test_assert_include_in_file"
#SSU_DEBUG_MODE=ON
startSSU;
date

