. ../SSU.sh

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

test_timer(){
	timer_on
	sh tax.sh 20000 > /dev/null
	assert_timer 500
	
	typeset cnt=0
	while [ $cnt -lt 10 ]
	do
		plural_timer_on
		sh tax.sh 20000 > /dev/null
		plural_timer_off
		cnt=$(($cnt + 1))
	done
	plural_timer_report
	
	cnt=0
	while [ $cnt -lt 10 ]
	do
		plural_timer_on
		sh tax.sh 20000 > /dev/null
		plural_timer_off
		cnt=$(($cnt + 1))
	done
	plural_timer_report
}

SSU_HOME="../"

date
#DEBUG_MODE=ON
SSU_TEST_PATTERN=test_timer
SSU_TARGET_FOR_COVERAGE="tax.sh"
startSSU;
date

