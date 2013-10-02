. env.sh

beforeTest(){
	h_make_file aa
	u_db_select_to aa 'EMP'
}
afterTest(){
	typeset dummy="";
	u_db_delete 'EMP' > /dev/null
	u_db_insert aa 'EMP'
}

setUp(){
	u_db_delete 'EMP' > /dev/null
}
tearDown(){
	typeset dummy="";
	u_db_delete 'EMP' > /dev/null
}

my_assert_log(){
	typeset f=$1
	typeset l=`wc -l $f`
	assert_not_same_num 0 $l
	l=`grep -v 31m $f |grep -v sql | grep -v Expect |grep -i [a-z] |wc -l |cut -c 1`
	assert_num 0 $l
}


test_assert_db_normal_FROMfile(){
	u_db_delete MANY_TYPES
	h_make_file aa
	h_make_file aa.csv
	echo  "FileReadCodeToDB=utf-8" > aa
	echo  "FileWriteCodeFromDB=utf-8" >> aa
	SSU_CHARCODE=aa
	u_db_insert conv.csv 'MANY_TYPES'
	u_db_select_to aa.csv MANY_TYPES
	SSU_CHARCODE=""
	h_make_file bb
	assert_exit_code "assert_db_include aa.csv MANY_TYPES" 99 > bb 2> /dev/null
	my_assert_log bb
	
	SSU_CHARCODE=aa
	assert_db_include conv.csv MANY_TYPES
	assert_exit_code "assert_db_include conv2.csv MANY_TYPES" 99 > bb 2> /dev/null
	my_assert_log bb
	assert_db_include_with_conv conv2.csv MANY_TYPES
}
test_assert_db_normal(){
	h_make_file bb
	echo "T,EID" > bb
	echo "2009/01/14 14:53:02.906,EID" >> bb
	echo "20090114005302906,x  " >> bb
	echo "20090114005302906,  ." >> bb
	echo "\"20090115 01:53:02.906\",\" y \"" >> bb
	echo "\"2009-01-15 02:53:02\",\" ' \"" >> bb
	echo "\"20090115035302\",\" ''\"" >> bb
	echo "\"20090115 045302.906\",\"'''\"" >> bb
	echo "\"20090115 055302906\",\" ''\"" >> bb
	echo "\"20090115 065302\", \ " >> bb
	echo "\"2009-01-15 07:53:02.906\",\  " >> bb
	echo "\"2009-01-15 07:53:02.906\",\\\ " >> bb
	echo "\"2009-01-15 07:53:02.906\",\\\\ " >> bb
	echo "\"2009-01-15 08:53:02.906\",x\" " >> bb
	echo "\"2009-01-15 09:53:02.906\",x\"\"" >> bb
	echo "\"2009-01-15 09:53:02.906\",\" \"\" \"" >> bb
	
	u_db_insert bb 'EMP'
	
	assert_db_with_conv bb 'EMP'
	
	h_make_file cc
	h_make_file dd
	h_make_file ee
	h_make_file ff
	u_db_select_to cc 'EMP'
	u_db_delete EMP > /dev/null
	u_db_insert bb 'EMP'
	u_db_select_to dd 'EMP'
	u_db_delete EMP > /dev/null
	u_db_insert cc 'EMP'
	assert_db_with_conv bb 'EMP'
	
	u_db_delete EMP > /dev/null
	u_db_insert dd 'EMP'
	u_db_select_to ee 'EMP'
	u_db_delete EMP > /dev/null
	u_db_insert ee 'EMP'
	u_db_select_to ff 'EMP'
	u_db_delete EMP > /dev/null
	u_db_insert ff 'EMP'
	
	assert_db_with_conv bb 'EMP'
	assert_db_with_conv cc 'EMP'
	assert_db_with_conv dd 'EMP'
	
	h_make_file dd
	echo "T,EID" > dd
	echo "2009-01-14 14:53:02.906,EID" >> dd
	
	assert_db_with_conv dd EMP "${SSU_HOME}" "where EID='EID'"
	assert_db_with_conv dd EMP "${SSU_HOME}" "where EID='EID'" pooh
	
	h_make_file ee
	assert_exit_code "assert_db_with_conv dd EMP" 99 > ee 2> /dev/null
	my_assert_log ee
	assert_include_in_file "select T,EID" ee
	
	#assert_exit_code "assert_db_with_conv dd EMP \"$w\" pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_with_conv dd EMP "${SSU_HOME}" "$w" pooh > ee 2> /dev/null &
	typeset jid=$!;
	wait $jid;
	typeset r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file "select T,EID" ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db_with_conv uuu EMP "${SSU_HOME}" "where EID='0'" pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_with_conv uuu EMP "${SSU_HOME}" "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	h_mkdir iii
	#assert_exit_code "assert_db iii EMP "${SSU_HOME}"  'where EID='0'' pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_with_conv iii EMP "${SSU_HOME}" "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db bb EMP99999 "${SSU_HOME}" "where EID='0'" pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_with_conv bb EMP99999 "${SSU_HOME}" "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db bb EMP99999 "${SSU_HOME}" EID='0' pooh 3 2 3" 99 > ee 2> /dev/null
	assert_db_with_conv bb EMP99999 "$w" pooh 3 2 3 > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file "Wrong Arg" ee
	
}

test_assert_db_kanji(){
	#for kanji
	h_make_file hoge
	u_db_insert k.data EMP
	u_db_select_to hoge EMP

	assert_db_with_conv k.data EMP
	assert_db_with_conv hoge EMP
	
	u_db_delete EMP > /dev/null
	u_db_insert hoge EMP
	
	h_make_file aaa
	u_db_select_to aaa EMP
	assert_db_with_conv hoge EMP
	assert_db_with_conv aaa EMP
	
}

SSU_EVIDENCE_BASEDIR="./uuu"
date
#SSU_TEST_PATTERN="test_assert_db_normal_FROMfile"
#SSU_DEBUG_MODE=ON
startSSU;
date

