. /home/masayuki/ssu/SSU.sh

doo(){
	typeset t=$1
	typeset i=0
	echo "===="
	date
	echo "$t"
	while [ $i -ne 1000 ]
	do
		$t
		i=$((${i}+1))
	done
	date
}
test_u_str_capitalize(){
	doo "assert_num 1 1"
	doo "assert_not_same_num 1 2"
	
	doo "assert_str '1' '1'"
	doo "assert_not_same_str '2' '1'"
	
	#doo "assert_blank_str $a "
	doo "assert_include 2 21"
	doo "assert_not_include '2' '1'"
	
	h_mkdir aa
	doo "assert_dir aa"
	doo "assert_not_found_dir aa1"
	
	h_make_file bb
	doo "assert_file bb"
	doo "assert_not_found_file bb1"
	doo "assert_blank_file bb"
	echo 11 > bb
	doo "assert_include_in_file 1 bb"
	doo "assert_not_include_in_file 2 bb"
	
	h_cp bb cc
	doo "assert_same_file cc bb"
	#assert_FileDateOrder pooh.data > "2006/07/01 00:00:00"
	
}

SSU_SELFPATH="."
#DEBUG_MODE=ON;
startSSU;



