. ../ssu/SSU.sh

SSU_HOME="../ssu"
beforeTest(){
        . /home/masayuki/ssu/Util.sh
}
test_aa(){
	assert_num 1 1
}
test_bb(){
	assert_num 10 10
}
test_cc(){
	assert_num 1 1
	h_make_file aa
	echo 234 > aa
	u_evi_file aa bb
	echo 234 >> aa
	u_evi_file aa bb
}
test_cc111111111111111111111(){
	assert_num 1 1
}
test_cc111111111111111111112(){
	assert_num 1 1
}
test_cc111111111111111111113(){
	assert_num 1 1
}
test_aaaadd(){
	typeset s=""
	s=`mmm "ls -l testa.sh "`
	assert_str "testa.sh" $s
	s=`mmm "sh -x testa.sh test_assert.sh"`
	assert_str "testa.sh" $s
	s=`mmm "bash test_assert.sh testa.sh"`
	assert_str "test_assert.sh" $s
	s=`mmm "./test_assert.sh testa.sh"`
	assert_str "test_assert.sh" $s
}
mmm(){
	typeset a="$1"
	_ssu_find_shell_name $a
}
#SSU_DEBUG_MODE="ON"
#SSU_TEST_PATTERN="test_aaaadd"
date
startSSU;
date

