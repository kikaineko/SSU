. ../ssu/SSU.sh

my_assert_log(){
	typeset f=$1
	l=`grep -v 31m $f |grep -i [a-z] |wc -l |cut -c 1`
	assert_num 0 $l
}
test_assert_str(){
	assert_str 0 0
	assert_str 0       0    
	assert_str 1 1
	assert_str 111111 111111
	assert_str -1 -1
	
	assert_str "sddddddd" "sddddddd"
	assert_str sddddddd "sddddddd"
	assert_str "sddddddd" sddddddd
	
	assert_str 'sddddddd' 'sddddddd'
	assert_str sddddddd 'sddddddd'
	assert_str 'sddddddd' sddddddd
	
	assert_str sddddddd sddddddd
	
	typeset s=777poiewofw4930vmw,.ewp11397208rowcs-9p^mv11
	s=$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s
	s=$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s
	s=$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s$s
	assert_str $s $s
	
	h_make_file aa
	assert_exit_code "assert_str 1 2" 99 > aa
	my_assert_log aa
	
	assert_exit_code "assert_str -1 1" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_str 1111111 1111112" 99 > aa
	my_assert_log aa

	
	#ARG
	assert_num -1 -1 pooh
	assert_exit_code "assert_str 1 2 pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	assert_exit_code "assert_str 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	
	assert_exit_code "assert_str" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
}

test_assert_not_same_str(){
	assert_not_same_str -1 -2
	assert_not_same_str 0 1
	assert_not_same_str        0               1
	assert_not_same_str 0 10000000000
	
	h_make_file aa
	assert_exit_code "assert_not_same_str 1 1" 99 > aa
	my_assert_log aa
	
	assert_exit_code "assert_not_same_str -1 -1" 99 > aa
	my_assert_log aa
		
	#ARG
	assert_not_same_num 0 10000000000 pooh
	assert_exit_code "assert_not_same_str 1 1 pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	assert_exit_code "assert_not_same_str 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	
	assert_exit_code "assert_not_same_str" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
}

test_assert_blank_str(){
	assert_blank_str ""
	
	typeset s=""
	assert_blank_str "$s"
	assert_blank_str "$s" pooh
	
	h_make_file aa
	#ARG
	assert_exit_code "assert_blank_str 0 1 pooh" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_blank_str 0 pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	assert_exit_code "assert_blank_str pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	
	assert_exit_code "assert_blank_str 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	assert_exit_code "assert_blank_str" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
}

test_assert_include(){
	assert_include 11 x1122
	assert_include 11 11
	assert_include "s s" "x11s s22"
	assert_include " s" "x11s s22"
	assert_include " s " "x11s s 22"
	assert_include " s " " s 22"
	assert_include " s " "eee s "
	assert_include ' s ' ' s '
	assert_include "  " "eee s  "
	
	assert_include "  ‚  " "eee s  ‚  "
	
	h_make_file aa
	assert_exit_code "assert_include 2 1" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_include 21 1" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_include 21 1 pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	
	assert_exit_code "assert_include 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	assert_exit_code "assert_include" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
}

test_assert_not_include(){
	assert_not_include s x1122
	assert_not_include " s" "s"
	
	h_make_file aa
	assert_exit_code "assert_not_include 1 1" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_not_include 1 1 pooh" 99 > aa
	my_assert_log aa
	assert_include_in_file pooh aa
	
	assert_exit_code "assert_not_include 1 1 1 1" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
	assert_exit_code "assert_not_include" 99 > aa
	assert_include_in_file "Wrong Arguments" aa
}

test_assert_not_include_in_file(){
	h_make_file aa
	assert_not_include_in_file ui aa
	echo uu > aa
	assert_not_include_in_file ui aa
	echo "uu" > aa
	echo "ii" >> aa
	h_make_file bb
	echo "s" > bb
	echo "i" >> bb
	echo "j" >> bb
	typeset s=`cat bb`
	assert_not_include_in_file "$s" aa
	
	assert_exit_code "assert_not_include_in_file 1 1 1 1" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_not_include_in_file s bb" 99 > aa
	my_assert_log aa
	assert_exit_code "assert_not_include_in_file s9 bbc" 99 > aa
	my_assert_log aa
}

test_assert_timer(){
	h_make_file aa
	echo 11111 > aa
	h_cp aa bb
	timer_on
	assert_same_file aa bb
	check_timer 1000
	
	timer_on
	assert_num 1 1
	assert_timer 50
	
	typeset cnt=0
	while [ $cnt -lt 10 ]
	do
		plural_timer_on
		assert_num 1 1
		plural_timer_off
		cnt=$(($cnt + 1))
	done
	plural_timer_report "ave"
	echo ""
	plural_timer_report "max"
	echo ""
	plural_timer_report "min"
	echo ""
	plural_timer_report "sd"
	echo ""
	plural_timer_report "count"
	echo ""
	assert_plural_timer 40
	plural_timer_report "s"
}

SSU_HOME="../ssu"
date
#SSU_TEST_PATTERN="test_assert_timer"
#SSU_DEBUG_MODE=ON
startSSU;
date

