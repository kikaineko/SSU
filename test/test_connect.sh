. ../ssu/SSU.sh

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


test_assert_db_sql_q(){
	h_make_file aa
	echo "select count(1) from EMPe" > aa
	u_db_sql_query aa 
	echo "insert into EMP (EID) values ('111')" > aa
	u_db_sql_exec aa
	echo "select count(1) from EMP" > aa
	u_db_sql_query aa
}



test_assert_db_normal(){
	h_make_file bb
	echo "T,EID" > bb
	echo "2009/01/14 14:53:02.906,EID" >> bb
	echo "2009011400530290,x  " >> bb
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
	
	assert_db bb 'EMP'
	
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
	assert_db bb 'EMP'
	
	u_db_delete EMP > /dev/null
	u_db_insert dd 'EMP'
	u_db_select_to ee 'EMP'
	u_db_delete EMP > /dev/null
	u_db_insert ee 'EMP'
	u_db_select_to ff 'EMP'
	u_db_delete EMP > /dev/null
	u_db_insert ff 'EMP'
	
	assert_db bb 'EMP'
	assert_db cc 'EMP'
	assert_db dd 'EMP'
	
	h_make_file dd
	echo "T,EID" > dd
	echo "2009-01-14 14:53:02.906,EID" >> dd
	
	assert_db dd EMP "where EID='EID'"
	assert_db dd EMP "where EID='EID'" pooh
	
	h_make_file ee
	assert_exit_code "assert_db dd EMP" 99 > ee 2> /dev/null
	my_assert_log ee
	assert_include_in_file "select T,EID" ee
	
	#assert_exit_code "assert_db dd EMP \"$w\" pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db dd EMP "$w" pooh > ee 2> /dev/null &
	typeset jid=$!;
	wait $jid;
	typeset r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file "select T,EID" ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db uuu EMP "where EID='0'" pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db uuu EMP "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	h_mkdir iii
	#assert_exit_code "assert_db iii EMP 'where EID='0'' pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db iii EMP "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db bb EMP99999 "where EID='0'" pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db bb EMP99999 "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db bb EMP99999 EID='0' pooh 3 2 3" 99 > ee 2> /dev/null
	assert_db bb EMP99999 "$w" pooh 3 2 3 > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file "Wrong Arg" ee
	
}

test_assert1_db_count(){
	u_db_delete 'EMP' > /dev/null
	assert_db_count 0 EMP
	
	h_make_file bb
	echo "T,EID" > bb
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	
	u_db_insert bb 'EMP'
	
	assert_db_count 3 'EMP'
	assert_db_count 1 EMP "where EID='x  '"
	assert_db_count 1 EMP "where EID='x  '" pooh
	
	
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	
	u_db_delete EMP > /dev/null
	u_db_insert bb 'EMP'
	
	assert_db_count 12 EMP
	
	h_make_file ee
	assert_exit_code "assert_db_count 0 EMP" 99 > ee 2> /dev/null
	my_assert_log ee
	assert_exit_code "assert_db_count a EMP" 99 > ee 2> /dev/null
	my_assert_log ee
	assert_exit_code "assert_db_count 0 EMP999" 99 > ee 2> /dev/null
	my_assert_log ee
	#assert_exit_code "assert_db_count 100 EMP EID='0' pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_count 100 EMP "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db_count bb EMP99999 EID='0' pooh 3 2 3" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_count bb 100 EMP99999 "$w" pooh 3 2 3 > ee 2> /dev/null &jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file "Wrong Arg" ee
	
	
	u_evi_file ee
	
}

test_assert_db_not_same_count(){
	u_db_delete 'EMP' > /dev/null
	assert_db_not_same_count 10 EMP
	
	h_make_file bb
	echo "T,EID" > bb
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	
	u_db_insert bb 'EMP'
	
	assert_db_not_same_count 4 'EMP'
	assert_db_not_same_count 0 EMP "where EID='x  '"
	assert_db_not_same_count 10 EMP "where EID='x  '" pooh
	
	
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	echo "2009-01-14 14:53:02.906,EID" >> bb
	echo "2009-01-14 00:53:02.906,x  " >> bb
	echo "\"2009-01-15 00:53:02.906\",\" y \"" >> bb
	
	u_db_delete EMP > /dev/null
	u_db_insert bb 'EMP'
	
	assert_db_count 12 EMP
	assert_db_not_same_count 120 EMP
	
	h_make_file ee
	assert_db_count 12 EMP
	assert_exit_code "assert_db_not_same_count 12 EMP" 99 > ee 2> /dev/null
	my_assert_log ee
	assert_exit_code "assert_db_not_same_count a EMP" 99 > ee 2> /dev/null
	my_assert_log ee
	assert_exit_code "assert_db_not_same_count 0 EMP999" 99 > ee 2> /dev/null
	my_assert_log ee
	#assert_exit_code "assert_db_not_same_count 200 EMP EID='0' pooh" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_count 0 EMP "$w" pooh
	assert_db_not_same_count 0 EMP "$w" pooh > ee 2> /dev/null &
	jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file pooh ee
	
	#assert_exit_code "assert_db_not_same_count bb EMP99999 EID='0' pooh 3 2 3" 99 > ee 2> /dev/null
	w="where EID='0'"
	assert_db_not_same_count bb 100 EMP99999 "$w" pooh 3 2 3 > ee 2> /dev/null &jid=$!;
	wait $jid;
	r=$?
	
	assert_num 99 $r
	my_assert_log ee
	assert_include_in_file "Wrong Arg" ee
	
	
	u_evi_file ee
	
}
test_assert_db_kanji(){
	#for kanji
	h_make_file hoge
	u_db_insert k.data EMP
	u_db_select_to hoge EMP

	assert_db k.data EMP
	assert_db hoge EMP
	
	u_db_delete EMP > /dev/null
	u_db_insert hoge EMP
	
	h_make_file aaa
	u_db_select_to aaa EMP
	assert_db hoge EMP
	assert_db aaa EMP
	
	assert_db_connect
}


test_assert_db_connect2(){
  assert_db_connect
}

SSU_HOME="../ssu"

SSU_JDBC_JAR="oracle/ojdbc14.jar";
SSU_JDBC_CLASS="oracle.jdbc.driver.OracleDriver";
SSU_JDBC_URL="jdbc:oracle:thin:@localhost:1521:xe";
SSU_JDBC_USER="system";
SSU_JDBC_PASSWORD="tiger";

SSU_EVIDENCE_BASEDIR="./uuu"
date
SSU_TEST_PATTERN="test_assert_db_sql_q"
#SSU_DEBUG_MODE=ON
startSSU;
date

