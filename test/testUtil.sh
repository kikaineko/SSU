. ../ssu/SSU.sh

beforeTest(){
        . /home/masayuki/ssu/Util.sh
}
test_u_str_capitalize(){
	assert_return_code "u_str_capitalize" 1 > /dev/null
	typeset str=`u_str_capitalize abc`
	assert_str Abc ${str}
	str=`u_str_capitalize XYZ`
	assert_str Xyz ${str}

	str=`u_str_capitalize 123XYZ`
	assert_str 123xyz ${str}

	str=`u_str_capitalize ""`
	assert_str "" "${str}"
}

test_u_str_chop(){
	assert_return_code "u_str_chop" 1 > /dev/null
	typeset str=`u_str_chop " abc  "`
	assert_str " abc " "${str}"
	
	str=" ab  c 

"
	str=`u_str_chop "${str}"`
	assert_str " ab  c" "${str}"

	str=`u_str_chop " abc  x.."`
	assert_str " abc  x." "${str}"
	
	str="";
	str=`u_str_chop "${str}"`
	assert_blank_str "${str}"
	
}

test_u_str_delete(){
	assert_return_code "u_str_delete " 1 > /dev/null
	assert_return_code "u_str_delete aa " 1 > /dev/null
	typeset str=`u_str_delete abc a`
	assert_str "bc" "${str}"
	str=`u_str_delete abc ab`
	assert_str "c" "${str}"
	str=`u_str_delete abcadb ab`
	assert_str "cd" "${str}"
	str=`u_str_delete ABCD123abc A-Z`
	assert_str "123abc" "${str}"
}

test_u_str_downcase(){
	assert_return_code "u_str_downcase " 1 > /dev/null
	typeset str=`u_str_downcase ABC`
	assert_str "abc" "${str}"
	str=`u_str_downcase XYZ12Ab`
	assert_str "xyz12ab" "${str}"
}

test_u_str_isEmpty(){
	assert_return_code "u_str_isEmpty " 1 > /dev/null
	typeset bool=`u_str_isEmpty ""`
	assert_num 0 ${bool}
	bool=`u_str_isEmpty "aa"`
	assert_num 1 ${bool}
}

test_u_str_gsub(){
	assert_return_code "u_str_gsub " 1 > /dev/null
	assert_return_code "u_str_gsub a" 1 > /dev/null
	assert_return_code "u_str_gsub a b" 1 > /dev/null
	typeset str=`u_str_gsub "abc" "a" "X"`
	assert_str "Xbc" "${str}"
	str=`u_str_gsub "abca12" "a" "X"`
	assert_str "XbcX12" "${str}"
	str=`u_str_gsub "abca12" "a" ""`
	assert_str "bc12" "${str}"
}

test_u_str_isInclude(){
	assert_return_code "u_str_isInclude " 1 > /dev/null
	assert_return_code "u_str_isInclude a" 1 > /dev/null
	typeset bool=`u_str_isInclude "abc" "a"`
	assert_num 0 ${bool}
	bool=`u_str_isInclude "abc" ""`
	assert_num 0 ${bool}
	bool=`u_str_isInclude "abc" "x"`
	assert_num 1 ${bool}
}

test_u_str_index(){
	assert_return_code "u_str_index " 1 > /dev/null
	assert_return_code "u_str_index a" 1 > /dev/null
	typeset ind=`u_str_index "abc" "a"`
	assert_num 0 ${ind}
	ind=`u_str_index "abc" "x"`
	assert_num -1 ${ind}
	ind=`u_str_index "abc" "abcd"`
	assert_num -1 ${ind}
	ind=`u_str_index "abc" "bc"`
	assert_num 1 ${ind}
	ind=`u_str_index "xabc98bc9" "bc"`
	assert_num 2 ${ind}
}

test_u_str_insert(){
	assert_return_code "u_str_insert " 1 > /dev/null
	assert_return_code "u_str_insert a" 1 > /dev/null
	assert_return_code "u_str_insert a 0" 1 > /dev/null
	assert_return_code "u_str_insert ab 3 c" 1 > /dev/null
	assert_return_code "u_str_insert ab -1" 1 > /dev/null
	typeset str=`u_str_insert "foobaz" 3 "bar"`
	assert_str "foobarbaz" "${str}"
	str=`u_str_insert "foobaz" 0 "bar"`
	assert_str "barfoobaz" "${str}"
	str=`u_str_insert "foobaz" 6 "bar"`
	assert_str "foobazbar" "${str}"
}


test_u_str_reverse(){
	assert_return_code "u_str_reverse" 1 > /dev/null
	typeset str=`u_str_reverse "abc"`
	assert_str "cba" "${str}"
	str=`u_str_reverse "a"`
	assert_str "a" "${str}"
	str=`u_str_reverse "x abc 123"`
	assert_str "321 cba x" "${str}"
}

test_u_str_size(){
	assert_return_code "u_str_size" 1 > /dev/null
	typeset num=`u_str_size " abc  "`
	assert_num 6 ${num}
	num=`u_str_size " ab--c  "`
	assert_num 8 ${num}
}

test_u_str_split(){
	assert_return_code "u_str_split" 1 > /dev/null
	assert_return_code "u_str_split aaa" 1 > /dev/null
	assert_return_code "u_str_split aaa 10" 1 > /dev/null
	typeset str=`u_str_split "abc 123" 1`
	assert_str "123" "${str}"
	str=`u_str_split "abc    123" 1`
	assert_str "123" "${str}"
	str=`u_str_split "  abc    123" 1`
	assert_str "123" "${str}"
	str=`u_str_split "  abc    123  " 0`
	assert_str "abc" "${str}"
}

test_u_str_upcase(){
	assert_return_code "u_str_upcase " 1 > /dev/null
	typeset str=`u_str_upcase abc`
	assert_str "ABC" "${str}"
	str=`u_str_upcase XYZ12Ab`
	assert_str "XYZ12AB" "${str}"
}

test_u_str_toFilePermissionNumber(){
	assert_return_code "u_str_toFilePermissionNumber " 1 > /dev/null
	assert_return_code "u_str_toFilePermissionNumber aa " 1 > /dev/null
	assert_return_code "u_str_toFilePermissionNumber rw-r--r--x " 1 > /dev/null
	assert_return_code "u_str_toFilePermissionNumber aaa " 1 > /dev/null
	assert_return_code "u_str_toFilePermissionNumber raa " 1 > /dev/null
	assert_return_code "u_str_toFilePermissionNumber rwa " 1 > /dev/null
	assert_return_code "u_str_toFilePermissionNumber rw+ " 1 > /dev/null
	typeset num=`u_str_toFilePermissionNumber "rw-"`
	assert_num 6 ${num}
	num=`u_str_toFilePermissionNumber "rwxr--r--"`
	assert_num 744 ${num}
	num=`u_str_toFilePermissionNumber "rw-r--r--"`
	assert_num 644 ${num}
	num=`u_str_toFilePermissionNumber "r-xr--r--"`
	assert_num 544 ${num}
	num=`u_str_toFilePermissionNumber "-wxr--r--"`
	assert_num 344 ${num}
	num=`u_str_toFilePermissionNumber "-w-r--r--"`
	assert_num 244 ${num}
	num=`u_str_toFilePermissionNumber "--xr--r--"`
	assert_num 144 ${num}
	num=`u_str_toFilePermissionNumber "---r--r--"`
	assert_num 044 ${num}
	
}

test_u_num_toFilePermission(){
	assert_return_code "u_num_toFilePermission " 1 > /dev/null
	assert_return_code "u_num_toFilePermission 9 " 1 > /dev/null
	assert_return_code "u_num_toFilePermission 6444 " 1 > /dev/null
	typeset s=`u_num_toFilePermission 6`
	assert_str "rw-" ${s}
	s=`u_num_toFilePermission 644`
	assert_str "rw-r--r--" ${s}
	s=`u_num_toFilePermission 7`
	assert_str "rwx" ${s}
	s=`u_num_toFilePermission 6`
	assert_str "rw-" ${s}
	s=`u_num_toFilePermission 5`
	assert_str "r-x" ${s}
	s=`u_num_toFilePermission 4`
	assert_str "r--" ${s}
	s=`u_num_toFilePermission 3`
	assert_str "-wx" ${s}
	s=`u_num_toFilePermission 2`
	assert_str "-w-" ${s}
	s=`u_num_toFilePermission 1`
	assert_str "--x" ${s}
	s=`u_num_toFilePermission 0`
	assert_str "---" ${s}
}

test_u_f_isFile(){
	assert_return_code "u_f_isFile " 1 > /dev/null

	h_make_file temptemp_f
	typeset bool=`u_f_isFile temptemp_f`
	assert_num 0 ${bool}
	
	h_rm aa_f
	bool=`u_f_isFile aa_f`
	assert_num 1 ${bool}
}

test_u_f_isDir(){
	assert_return_code "u_f_isDir " 1 > /dev/null

	h_mkdir temptemp_d
	typeset bool=`u_f_isDir temptemp_d`
	assert_num 0 ${bool}
	
	bool=`u_f_isDir ecsdgeiovnxsdxe____d`
	assert_num 1 ${bool}
}

test_u_f_getPermission(){
	assert_return_code "u_f_getPermission " 1 > /dev/null
	assert_return_code "u_f_getPermission xe33sdno4i3rv " 1 > /dev/null

	h_make_file temptemp_f
	chmod 644 temptemp_f
	typeset str=`u_f_getPermission temptemp_f`
	assert_str "rw-r--r--" "${str}"
}

test_u_f_getSize(){
	assert_return_code "u_f_getSize " 1 > /dev/null
	assert_return_code "u_f_getSize xe33sdno4i3rv " 1 > /dev/null
	h_make_file temptemp_f
	typeset s=`u_f_getSize temptemp_f`
	assert_num 0 ${s}
	echo 123 > temptemp_f
	s=`u_f_getSize temptemp_f`
	assert_num 4 ${s}
}

test_u_f_getUser(){
	assert_return_code "u_f_getUser " 1 > /dev/null
	assert_return_code "u_f_getUser xe33sdno4i3rv " 1 > /dev/null

	h_make_file temptemp_f
	typeset s=`u_f_getUser temptemp_f`
	typeset s1=`whoami`
	assert_str "${s1}" "${s}"
}

test_u_f_getGroup(){
	assert_return_code "u_f_getGroup " 1 > /dev/null
	assert_return_code "u_f_getGroup xe33sdno4i3rv " 1 > /dev/null

	h_make_file temptemp_f
	typeset s=`u_f_getGroup temptemp_f`
	typeset u=`whoami`
	typeset g_temp=`groups "${u}"`
	typeset g=`u_str_split "${g_temp}" 2`
	assert_str "${g}" "${s}"
}


test_u_f_getOwn(){
	assert_return_code "u_f_getOwn " 1 > /dev/null
	assert_return_code "u_f_getOwn xe33sdno4i3rv " 1 > /dev/null

	h_make_file temptemp_f
	typeset s=`u_f_getOwn temptemp_f`
	typeset u=`whoami`
	typeset g_temp=`groups "${u}"`
	typeset g=`u_str_split "${g_temp}" 2`
	assert_str "${u}"."${g}" "${s}"
}

test_u_f_getTimestamp(){
	assert_return_code "u_f_getTimestamp " 1 > /dev/null
	assert_return_code "u_f_getTimestamp xe33sdno4i3rv " 1 > /dev/null

	h_make_file temptemp_f
	typeset s=`u_f_getTimestamp temptemp_f`
	typeset t=`echo "${s}" |cut -c 1-19`
	sleep 1
	touch temptemp_f
	assert_FileDateOrder temptemp_f ">" "${t}"
}
#SSU_TEST_PATTERN="^test_u_str_toFilePermissionNumber";
SSU_HOME="../ssu"
#SSU_TARGET_FOR_COVERAGE="Util.sh"
date

#SSU_DEBUG_MODE=ON;
startSSU;
date


