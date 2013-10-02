. ../../ssu/SSU.sh
SSU_HOME="../../ssu"

#beforeTest(){
#}

test_h_mv(){
	# 引数足りない
	h_make_file pp
	assert_exit_code "h_mv" 99 > pp
	assert_include_in_file "Wrong Arguments" pp

	# ファイルがない
	assert_exit_code "h_mv no_exist_file no_exist_file.tmp" 99 > pp
	assert_include_in_file "not found file" pp

	# そんなオプションない
	h_make_file aa
	h_make_file qq
	assert_exit_code "h_mv aa bb -no_exist_option" 99 > pp 2> qq
	assert_include_in_file "Fail" pp
	assert_include_in_file "mv --help" qq

	# 正常系
	h_make_file cc
	h_mv cc dd
	assert_not_found_file cc
	assert_file dd

	# ファイルがなければ上書き確認しない
	h_mv dd ee -i
	assert_not_found_file dd
	assert_file ee

	# 上書き確認なし
	h_make_file ff
	h_make_file gg
	echo "hagemaru" > ff
	h_mv ff gg -f
        assert_not_found_file ff
        assert_file gg
	assert_include_in_file "hagemaru" gg

	# サブディレクトリ
	h_mkdir AA
	h_make_file AA/aa
	h_mv AA/aa AA/bb
	h_mv AA/bb bb
}

test_h_chmod(){
	# 引数が足りない
	h_make_file aa
	assert_exit_code "h_chmod" 99 > aa
	assert_include_in_file "wrong argument" aa

	assert_exit_code "h_chmod hoge" 99 > aa
	assert_include_in_file "wrong argument" aa

	# 引数が多い
	h_make_file bb
	assert_exit_code "h_chmod 777 aa bb" 99 > aa
	assert_include_in_file "wrong argument" aa

	# 同一行にコメントも使えない
	assert_exit_code "h_chmod 777 aa # hoge" 99 > aa
	assert_include_in_file "wrong argument" aa

	# ファイルがない
	assert_exit_code "h_chmod 666 no_exist_file" 99 > aa
	assert_include_in_file "cannot access or not file" aa

	# 引数の指定が誤り
	h_make_file pp
	h_make_file bb
	assert_exit_code "h_chmod 888 pp" 99 > aa 2> bb
	assert_include_in_file "Fail" aa
	assert_include_in_file "chmod --help" bb

	# 正常系	
	h_chmod 764 pp
	assert_str "rwxrw-r--" `u_f_getPermission pp`
	h_chmod +x pp
	assert_str "rwxrwxr-x" `u_f_getPermission pp`
	h_chmod g-w pp
	assert_str "rwxr-xr-x" `u_f_getPermission pp`
}


test_h_cp(){
	# 引数が足りない
	h_make_file aa
	assert_exit_code "h_cp" 99 > aa
	assert_include_in_file "Wrong Arguments" aa

	assert_exit_code "h_cp aa" 99 > aa
	assert_include_in_file "Wrong Arguments" aa

	# ファイルがない
	assert_exit_code "h_cp no_exist_file hoge" 99 > aa
	assert_include_in_file "not found" aa

	# そんなオプションない
	h_make_file bb
	assert_exit_code "h_cp aa bb -no_exist_op" 99 > aa 2> bb
	assert_include_in_file "Fail" aa
	assert_include_in_file "cp --help" bb

	# 正常系
	h_make_file pp
	h_make_file xx
	h_make_file yy
	echo "puyopuyo" > pp
	h_cp pp qq
	assert_include_in_file "puyopuyo" qq
	
	h_cp qq rr -p
	u_f_getTimestamp qq > xx
	u_f_getTimestamp rr > yy
	assert_same_file xx yy

	# サブディレクトリ
	h_mkdir AA
	h_make_file AA/mm
	h_cp AA/mm AA/nn
	assert_file AA/nn
}

: << '#__COMMENT_OUT__'

test_h_rm(){
	assert_exit_code "h_rm" 99 > /dev/null
	assert_exit_code "h_rm no_exist_file" 1 2&> /dev/null
	assert_exit_code "h_rm tmp_0.txt tmp_1.txt -f" 99 &> /dev/null
}

test_h_cd(){
	assert_exit_code "h_cd" 99 > /dev/null
	assert_exit_code "h_cd no_exist_dir" 99 &> /dev/null
	assert_exit_code "h_cd tmp_dir no_exist_option" 99 &> /dev/null
	assert_exit_code "h_cd tmp_dir -P aaa" 99 &> /dev/null

	cur_dir=`pwd`

	h_cd tmp_dir
	tmp_dir=`pwd`

	assert_not_same_str ${cur_dir} ${tmp_dir}

	h_mkdir tmp_sub_dir
	ln -s tmp_sub_dir hoge

	h_cd tmp_sub_dir
	h_cd ../hoge
	h_cd ..
	h_rm -r hoge

	h_cd - > /dev/null
	h_cd ~
        h_mkdir aaaaaa
        h_cd aaaaaa
}

test_h_mkdir(){

}

test_h_file_name(){

}

test_h_chown(){
        assert_exit_code "h_chown" 99 > /dev/null
        assert_exit_code "h_chown no_exit_user tmp_0.txt" 99 &> /dev/null
}

afterTest(){
	assert_include_in_file "0" tmp_0.txt
}

#__COMMENT_OUT__

date
startSSU
date

