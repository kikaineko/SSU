. env.sh

test_many_types(){
	u_db_delete MANY_TYPES > /dev/null
	u_db_insert manyt.data MANY_TYPES
	assert_db manyt.data MANY_TYPES
	
	h_make_file aa
	
	u_db_select_to aa MANY_TYPES
	assert_db aa MANY_TYPES
	u_db_delete MANY_TYPES > /dev/null
	u_db_insert aa MANY_TYPES
	assert_db aa MANY_TYPES
	assert_db manyt.data MANY_TYPES
	
	h_make_file bb
	
	u_db_select_to bb MANY_TYPES
	assert_db bb MANY_TYPES
	u_db_delete MANY_TYPES > /dev/null
	u_db_insert bb MANY_TYPES
	assert_db bb MANY_TYPES
	assert_db aa MANY_TYPES
	assert_db manyt.data MANY_TYPES
	assert_db_ordered sorted.data MANY_TYPES "where DCHAR='8234567'"

	cnt=`u_db_delete MANY_TYPES "where  DCHAR='8234567'"`
	assert_not_same_num 0 $cnt

	h_make_file cc
	assert_db_ordered sorted_err.data MANY_TYPES "where DCHAR='8234567'"  > cc 2> /dev/null &
	typeset jid=$!;
	wait $jid;
	typeset r=$?
	assert_num 99 $r
}

date
#SSU_TEST_PATTERN="test_assert_db_normal"
#SSU_DEBUG_MODE=ON
startSSU;
date

