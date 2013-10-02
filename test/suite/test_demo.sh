. ../../ssu/SSU.sh

test_normal(){
	h_make_file aa
	sh tax.sh 100 > aa
	assert_num 0 $?
	assert_include_in_file 105 aa
}
test_normal_big(){
	h_make_file aa
	sh tax.sh 100000000 > aa
	assert_num 0 $?
	assert_include_in_file 105000000 aa
}
test_err(){
	h_make_file aa
	sh tax.sh 10a > aa 2> /dev/null
	assert_num 1 $?
}

SSU_SELFPATH="../../ssu/"

#DEBUG_MODE=ON
startSSU;

