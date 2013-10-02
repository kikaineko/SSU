#!/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
# either express or implied. See the License for the specific language
# governing permissions and limitations under the License.
#
################################################################################

################################################################################
# runs Each assert
################################################################################
_ssu_AssertSetUp(){
        _ssu_CurrentAssertIndex=$((${_ssu_CurrentAssertIndex}+1));
        _ssu_util_old_to_new
}

################################################################################
# fail
# $1 comment (option)
################################################################################
fail(){
	_ssu_AssertSetUp;
	typeset __fail_comment=" ";

	if [ $# = 1 ]
	then
		__fail_comment="${1}";
	fi
	
	_ssu_FailLog_fail "fail" "${__fail_comment}"
}


################################################################################
# assert_num
# number check function
# $1 expect Value
# $2 actual Value 
# $3 comment (option)
################################################################################
assert_num(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_num";
	fi

	typeset __assert_num_expect="${1}";
	typeset __assert_num_actual="${2}";
	typeset __assert_num_comment=" ";

	if [ $# = 3 ]
	then
		__assert_num_comment="${3}";
	fi
	
	if [ ${__assert_num_expect} -eq ${__assert_num_actual} ]
	then
		_ssu_succeedLog "assert_num" "${__assert_num_comment}";
	else
		_ssu_FailLog_Base  "assert_num" "${__assert_num_expect}" "${__assert_num_actual}" "${__assert_num_comment}";
	fi
}

################################################################################
# assert_str
# string check function
# $1 expect Value
# $2 actual Value 
# $3 comment (option)
################################################################################
assert_str(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_str";
	fi
	typeset __assert_str_expect="${1}";
	typeset __assert_str_actual="${2}";
	typeset __assert_str_comment=" ";
	if [ $# = 3 ]
	then
		__assert_str_comment="${3}";
	fi
	
	if [ x"$__assert_str_expect" != x"$__assert_str_actual" ]
	then 
		_ssu_FailLog_Base  "assert_str" "${__assert_str_expect}" "${__assert_str_actual}" "${__assert_str_comment}";

	else
		_ssu_succeedLog "assert_str" "${__assert_str_comment}";
	fi
}

################################################################################
# assert_not_same_num
# false check function (${1} != ${2} => true)
# $1 unexpect Value
# $2 actual Value
# $3 comment (option)
################################################################################
assert_not_same_num(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_same_num";
	fi
	typeset __assert_not_same_num_unexpect_value="${1}"
	typeset __assert_not_same_num_actual_value="${2}"
	typeset __assert_not_same_num_comment=" ";
	if [ $# = 3 ]
	then
		__assert_not_same_num_comment=$3
	fi

	if [ $__assert_not_same_num_unexpect_value -ne $__assert_not_same_num_actual_value ]
	then 
		_ssu_succeedLog "assert_not_same_num" "${__assert_not_same_num_comment}";
	else
		_ssu_FailLog_False "assert_not_same_num" "${__assert_not_same_num_unexpect_value}" "${__assert_not_same_num_actual_value}" "${__assert_not_same_num_comment}";
	fi
}

################################################################################
# assert_not_same_str
# false check function (${1} != ${2} => true)
# $1 unexpect Value
# $2 actual Value
# $3 comment (option)
################################################################################
assert_not_same_str(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_same_str";
	fi
	typeset __assert_not_same_str_unexpect_value=x"${1}"
	typeset __assert_not_same_str_actual_value=x"${2}"
	typeset __assert_not_same_str_comment=" ";
	if [ $# = 3 ]
	then
		__assert_not_same_str_comment=$3
	fi

	if [ "$__assert_not_same_str_unexpect_value" = "$__assert_not_same_str_actual_value" ]
	then 
		_ssu_FailLog_False "assert_not_same_str" "${__assert_not_same_str_unexpect_value}" "${__assert_not_same_str_actual_value}" "${__assert_not_same_str_comment}";

	else
		_ssu_succeedLog "assert_not_same_str" "${__assert_not_same_str_comment}";
	fi
}

################################################################################
# assert_return_code
# return code check function
# $1 command
# $2 return code
# $3 comment (option)
################################################################################
assert_return_code(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_return_code";
	fi

	typeset __assert_return_code_command="${1}";
	typeset __assert_return_code_expect_ret_value="${2}";
	typeset __assert_return_code_comment=" ";

	if [ $# = 3 ]
	then
		__assert_return_code_comment="${3}";
	fi

	${__assert_return_code_command}
	typeset __assert_return_code_actual_value=$?

	if [ ${__assert_return_code_expect_ret_value} -ne ${__assert_return_code_actual_value} ]
	then 
		_ssu_FailLog_Base  "assert_return_code" "${__assert_return_code_expect_ret_value}" "${__assert_return_code_actual_value}" "${__assert_return_code_comment}";

	else
		_ssu_succeedLog "assert_return_code" "${__assert_return_code_comment}";
	fi
}


################################################################################
# assert_exit_code
# exit code check function
# $1 command
# $2 exit code
# $3 comment (option)
################################################################################
assert_exit_code(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_exit_code";
	fi

	typeset __assert_exit_code_command="${1}";
	typeset __assert_exit_code_expect_ret_value="${2}";
	typeset __assert_exit_code_comment=" ";

	if [ $# = 3 ]
	then
		__assert_exit_code_comment="${3}";
	fi

	${__assert_exit_code_command} &
	typeset __assert_exit_code_jid=$!;
	wait $__assert_exit_code_jid;
	typeset __assert_exit_code_actual_value=$?

	if [ ${__assert_exit_code_expect_ret_value} -ne ${__assert_exit_code_actual_value} ]
	then 
		_ssu_FailLog_Base  "assert_exit_code" "${__assert_exit_code_expect_ret_value}" "${__assert_exit_code_actual_value}" "${__assert_exit_code_comment}";
	else
		_ssu_succeedLog "assert_exit_code" "${__assert_exit_code_comment}";
	fi
}



################################################################################
# assert_true
# condition check function
# $1 condition
# $2 comment (option)
# example : assert_true "1 > 0"
################################################################################
assert_true(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_true";
	fi

	typeset __assert_true_condition="${1}";
	typeset __assert_true_comment=" ";

	if [ $# = 2 ]
	then
		__assert_true_comment="${2}";
	fi

	if [ ${__assert_true_condition} ]
	then 
		_ssu_succeedLog "assert_true" "${__assert_true_comment}";

	else
		_ssu_FailLog_Base  "assert_true" "${__assert_true_condition}" "true" "${__assert_true_comment}";
	fi
}

################################################################################
# assert_false
# condition check function
# $1 condition
# $2 comment (option)
# example : assert_false "1 < 0"
################################################################################
assert_false(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_false";
	fi

	typeset __assert_false_condition="${1}";
	typeset __assert_false_comment=" ";

	if [ $# = 2 ]
	then
		__assert_false_comment="${2}";
	fi

	if [ ! ${__assert_false_condition} ]
	then 
		_ssu_succeedLog "assert_false" "${__assert_false_comment}";

	else
		_ssu_FailLog_Base "assert_false" "${__assert_false_condition}" "false" "${__assert_false_comment}";
	fi
}

################################################################################
# assert_dir
# Directory exist check function
# $1 directory name
# $2 comment(option)
################################################################################
assert_dir(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_dir";
	fi
	typeset __assert_dir_dir="${1}";
	typeset __assert_dir_comment=" ";
	if [ $# = 2 ]
	then
		__assert_dir_comment="${2}";
	fi

	if [ ! -d "${__assert_dir_dir}" ]; then 
		_ssu_FailLog_File "assert_dir" "${__assert_dir_dir}" "${__assert_dir_comment}";
	else
		_ssu_succeedLog "assert_dir" "${__assert_dir_comment}";
	fi
}

################################################################################
# assert_not_found_dir
# Directory not found check function
# $1 directory name
# $2 comment(option)
################################################################################
assert_not_found_dir(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_not_found_dir";
	fi
	typeset __assert_not_found_dir_dir="${1}";
	typeset __assert_not_found_dir_comment=" ";
	if [ $# = 2 ]
	then
		__assert_not_found_dir_comment="${2}";
	fi

	if [ -d "${__assert_not_found_dir_dir}" ]; then 
		_ssu_FailLog_NotFoundFile "assert_not_found_dir" "${__assert_not_found_dir_dir}" "${__assert_not_found_dir_comment}";
	else
		_ssu_succeedLog "assert_not_found_dir" "${__assert_not_found_dir_comment}";
	fi
}
################################################################################
# assert_file
# File exist check function
# $1 file name
# $2 comment (option)
################################################################################
assert_file(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_file";
	fi
	typeset __assert_file_file="${1}";
	typeset __assert_file_comment=" ";
	if [ $# = 2 ]
	then
		__assert_file_comment="${2}";
	fi

	if [ ! -f "${__assert_file_file}" ]; then 
		_ssu_FailLog_File  "assert_file" "${__assert_file_file}" "${__assert_file_comment}";
	else 
		_ssu_succeedLog "assert_file" "${__assert_file_comment}";
	fi
}

################################################################################
# assert_not_found_file
# File not found check function
# $1 file name
# $2 comment (option)
################################################################################
assert_not_found_file(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_not_found_file";
	fi
	typeset __assert_not_found_file_file="${1}";
	typeset __assert_not_found_file_comment=" ";
	if [ $# = 2 ]
	then
		__assert_not_found_file_comment="${2}";
	fi

	if [ -f "${__assert_not_found_file_file}" ]; then 
		_ssu_FailLog_NotFoundFile "assert_not_found_file" "${__assert_not_found_file_file}" "${__assert_not_found_file_comment}";
	else 
		_ssu_succeedLog "assert_not_found_file" "${__assert_not_found_file_comment}";
	fi
}

################################################################################
# assert_blank_str
# blank( "" ) check function
# $1 string
# $2 comment (option)
################################################################################
assert_blank_str(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_blank_str";
	fi
	typeset __assert_blank_str_str="${1}";
	typeset __assert_blank_str_comment=" ";
	if [ $# = 2 ]
	then
		__assert_blank_str_comment="${2}";
	fi

	if [ ! -z "${__assert_blank_str_str}" ]; then
		_ssu_FailLog_Blank "assert_blank_str" "${__assert_blank_str_str}" "${__assert_blank_str_comment}";
	else
		_ssu_succeedLog "assert_blank_str" "${__assert_blank_str_comment}";
	fi 
}

################################################################################
# assert_blank_file
# blank file(0byte) check function
# $1 file
# $2 comment (option)
################################################################################
assert_blank_file(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_blank_file";
	fi
	typeset __assert_blank_file_file="${1}";
	typeset __assert_blank_file_comment=" ";
	if [ $# = 2 ]
	then
		__assert_blank_file_comment="${2}";
	fi

	if [ -s "${__assert_blank_file_file}" ]; then
		_ssu_FailLog_Blank  "assert_blank_file" "${__assert_blank_file_file}" "${__assert_blank_file_comment}";
	else
		if [ -f "${__assert_blank_file_file}" ]; then
			_ssu_succeedLog "assert_blank_file" "${__assert_blank_file_comment}";
		else
			_ssu_FailLog_File  "assert_blank_file" "${__assert_blank_file_file}" "${__assert_blank_file_comment}";
		fi
	fi 
}

################################################################################
# assert_include
# 
# $1 string
# $2 target
# $3 comment (option)
################################################################################
assert_include(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_include";
	fi
	typeset __assert_include_str="${1}";
	typeset __assert_include_target="${2}";
	typeset __assert_include_comment=" ";
	if [ $# = 3 ]
	then
		__assert_include_comment="${3}";
	fi
	typeset __assert_include__count_line=`echo "${__assert_include_target}" | grep -c "${__assert_include_str}"`;
	if [ ${__assert_include__count_line} -eq 0 ];then
		_ssu_FailLog_Include "assert_include" "${__assert_include_str}" "${__assert_include_target}" "${__assert_include_comment}";
	else
		_ssu_succeedLog "assert_include" "${__assert_include_comment}";
	fi
}

################################################################################
# assert_include_in_file
# 
# $1 string
# $2 file
# $3 comment (option)
################################################################################
assert_include_in_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_include_in_file";
	fi
	typeset __assert_include_in_file_str="${1}";
	typeset __assert_include_in_file_target="${2}";
	typeset __assert_include_in_file_comment=" ";
	if [ $# = 3 ]
	then
		__assert_include_in_file_comment="${3}";
	fi
	typeset __assert_include_in_file__count_line=0
	if [ -f ${__assert_include_in_file_target} ];then
		typeset __assert_include_in_file_ll=`echo "$__assert_include_in_file_str" | wc -l`
		if [ $__assert_include_in_file_ll -eq 0 ];then
			__assert_include_in_file__count_line=`grep -c "${__assert_include_in_file_str}" "${__assert_include_in_file_target}"`;
		else
			__assert_include_in_file__count_line=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilincludeinfile" "${__assert_include_in_file_str}" "${__assert_include_in_file_target}"`
		fi
	else
		_ssu_ErrExit "assert_include_in_file";
	fi
	if [ ${__assert_include_in_file__count_line} -eq 0 ];then
		_ssu_FailLog_Include "assert_include_in_file" "${__assert_include_in_file_str}" "${__assert_include_in_file_target}" "${__assert_include_in_file_comment}";
	else
		_ssu_succeedLog "assert_include_in_file" "${__assert_include_in_file_comment}";
	fi
}

################################################################################
# assert_not_include
# $1 string
# $2 target
# $3 comment (option)
################################################################################
assert_not_include(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_include";
	fi
	typeset __assert_not_include_str="${1}";
	typeset __assert_not_include_target="${2}";
	typeset __assert_not_include_comment=" ";
	if [ $# = 3 ]
	then
		__assert_not_include_comment="${3}";
	fi
	typeset __assert_not_include__count_line=`echo "${__assert_not_include_target}" | grep -c "${__assert_not_include_str}"`;
	if [ ${__assert_not_include__count_line} -ne 0 ];then
		_ssu_FailLog_NotInclude "assert_not_include" "${__assert_not_include_str}" "${__assert_not_include_target}" "${__assert_not_include_comment}";
	else
		_ssu_succeedLog "assert_not_include" "${__assert_not_include_comment}";
	fi
}

################################################################################
# assert_not_include_in_file
# $1 string
# $2 file
# $3 comment (option)
################################################################################
assert_not_include_in_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_include_in_file";
	fi
	typeset __assert_not_include_in_file_str="${1}";
	typeset __assert_not_include_in_file_target="${2}";
	typeset __assert_not_include_in_file_comment=" ";
	if [ $# = 3 ]
	then
		__assert_not_include_in_file_comment="${3}";
	fi
	
	typeset __assert_not_include_in_file__count_line=0
	if [ -f ${__assert_not_include_in_file_target} ];then
		typeset __assert_not_include_in_file_ll=`echo "$__assert_not_include_in_file_str" | wc -l`
		if [ $__assert_not_include_in_file_ll -eq 0 ];then
			__assert_not_include_in_file__count_line=`grep -c "${__assert_not_include_in_file_str}" "${__assert_not_include_in_file_target}"`;
		else
			__assert_not_include_in_file__count_line=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilincludeinfile" "${__assert_not_include_in_file_str}" "${__assert_not_include_in_file_target}"`
		fi
	else
		_ssu_ErrExit "assert_not_include_in_file";
	fi
	if [ ${__assert_not_include_in_file__count_line} -ne 0 ];then
		_ssu_FailLog_NotInclude "assert_not_include_in_file" "${__assert_not_include_in_file_str}" "${__assert_not_include_in_file_target}" "${__assert_not_include_in_file_comment}";
	else
		_ssu_succeedLog "assert_not_include_in_file" "${__assert_not_include_in_file_comment}";
	fi
}


################################################################################
# assert_same_file
# $1 expect file
# $2 other file
# $3 comment (option)
################################################################################
assert_same_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_same_file";
	fi
	typeset __assert_same_file_expect_file="${1}";
	typeset __assert_same_file_other_file="${2}";
	typeset __assert_same_file_comment=" ";
	if [ $# = 3 ]
	then
		__assert_same_file_comment="${3}";
	fi

	#diff "${__assert_same_file_expect_file}" "${__assert_same_file_other_file}" > /dev/null
	typeset __assert_same_file_same=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilfilesame" "${__assert_same_file_expect_file}" "${__assert_same_file_other_file}"`
	typeset __assert_same_file_r=`echo "${__assert_same_file_same}" | wc -c`
	if [ ${__assert_same_file_r} -gt 3 ]; then
		_ssu_FailLog_SameFile "assert_same_file" "${__assert_same_file_expect_file}" "${__assert_same_file_other_file}" "${__assert_same_file_comment}";
	else
		if [ "${__assert_same_file_same}" = "1" ]
		then
			_ssu_FailLog_SameFile "assert_same_file" "${__assert_same_file_expect_file}" "${__assert_same_file_other_file}" "${__assert_same_file_comment}";
		else
			_ssu_succeedLog "assert_same_file" "${__assert_same_file_comment}";
		fi
	fi
}

################################################################################
# assert_not_same_file
# $1 expect file
# $2 other file
# $3 comment (option)
################################################################################
assert_not_same_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_same_file";
	fi
	typeset __assert_not_same_file_expect_file="${1}";
	typeset __assert_not_same_file_other_file="${2}";
	typeset __assert_not_same_file_comment=" ";
	if [ $# = 3 ]
	then
		__assert_not_same_file_comment="${3}";
	fi

	typeset __assert_not_same_file_same=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilfilesame" "${__assert_not_same_file_expect_file}" "${__assert_not_same_file_other_file}"`
	typeset __assert_not_same_file_r=`echo "${__assert_not_same_file_same}" | wc -c`
	if [ ${__assert_not_same_file_r} -gt 3 ]; then
		_ssu_FailLog_SameFile "assert_not_same_file" "${__assert_not_same_file_expect_file}" "${__assert_not_same_file_other_file}" "${__assert_not_same_file_comment}";
	else
		if [ "${__assert_not_same_file_same}" = "0" ]
		then
			_ssu_FailLog_SameFile "assert_not_same_file" "${__assert_not_same_file_expect_file}" "${__assert_not_same_file_other_file}" "${__assert_not_same_file_comment}";
		else
			_ssu_succeedLog "assert_not_same_file" "${__assert_not_same_file_comment}";
		fi
	fi
}


################################################################################
# assert_FileDateOrder
# $1 target file name
# $2 operaete ("<" ,">" ,"=" ,"!=" ,"<=" ,">=" )
# $3 timestamp (YYYY-MM-DD HH:MI:SS or YYYY/MM/DD HH:MI:SS)
# $4 comment (option)
# example : assert_FileDateOrder foo.data > "2006-07-01 00:00:00"
################################################################################
assert_FileDateOrder(){
	_ssu_AssertSetUp;
	if [[ $# -ne 3 && $# -ne 4 ]]
	then
		_ssu_ErrExit "assert_FileDateOrder";
	fi
	typeset __assert_FileDateOrder_file="${1}";
	typeset __assert_FileDateOrder_ope="${2}"
	typeset __assert_FileDateOrder_time="${3}"
	typeset __assert_FileDateOrder_comment=" ";
	if [ $# = 4 ]
	then
		__assert_FileDateOrder_comment="${4}";
	fi
	
	typeset __assert_FileDateOrder_f_t=`_ssu_LsFulltime "${__assert_FileDateOrder_file}"`
	typeset __assert_FileDateOrder_f_num=`_ssu_FromDateStyleToInt "${__assert_FileDateOrder_f_t}"`
	typeset __assert_FileDateOrder_t_num=`_ssu_FromDateStyleToInt "${__assert_FileDateOrder_time}"`
	typeset __assert_FileDateOrder_result_flag=1;
	
	case "${__assert_FileDateOrder_ope}" in
	"<")
		if [ ${__assert_FileDateOrder_f_num} -lt ${__assert_FileDateOrder_t_num} ];then
			__assert_FileDateOrder_result_flag=0;
		fi
	;;
	">")
		if [ ${__assert_FileDateOrder_f_num} -gt ${__assert_FileDateOrder_t_num} ];then
			__assert_FileDateOrder_result_flag=0;
		fi
	;;
	"=")
		if [ ${__assert_FileDateOrder_f_num} -eq ${__assert_FileDateOrder_t_num} ];then
			__assert_FileDateOrder_result_flag=0;
		fi
	;;
	"!=")
		if [ ${__assert_FileDateOrder_f_num} -ne ${__assert_FileDateOrder_t_num} ];then
			__assert_FileDateOrder_result_flag=0;
		fi
	;;
	"<=")
		if [ ${__assert_FileDateOrder_f_num} -le ${__assert_FileDateOrder_t_num} ];then
			__assert_FileDateOrder_result_flag=0;
		fi
	;;
	">=")
		if [ ${__assert_FileDateOrder_f_num} -ge ${__assert_FileDateOrder_t_num} ];then
			__assert_FileDateOrder_result_flag=0;
		fi
	;;
	esac

	if [ ${__assert_FileDateOrder_result_flag} -ne 0 ];then
		_ssu_FailLog_FileDateOrder "assert_FileDateOrder" "${__assert_FileDateOrder_f_t} ${__assert_FileDateOrder_ope}" "${__assert_FileDateOrder_time}" "${__assert_FileDateOrder_comment}";
	else
		_ssu_succeedLog "assert_FileDateOrder" "${__assert_FileDateOrder_comment}";
	fi
}

################################################################################
#
# Log functions
#
################################################################################
_ssu_FailLog_Base(){
	typeset ___ssu_FailLog_Base_assert_name="${1}";
	typeset ___ssu_FailLog_Base_message1="expect Value : ${2}";
	typeset ___ssu_FailLog_Base_message2="actual Value : ${3}";
	typeset ___ssu_FailLog_Base_comment="${4}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_Base_assert_name}" "${___ssu_FailLog_Base_message1}" "${___ssu_FailLog_Base_message2}" "${___ssu_FailLog_Base_comment}"
}
_ssu_FailLog_Base_nonExit(){
	typeset ___ssu_FailLog_Base_nonExit_assert_name="${1}";
	typeset ___ssu_FailLog_Base_nonExit_message1="expect Value : ${2}";
	typeset ___ssu_FailLog_Base_nonExit_message2="actual Value : ${3}";
	typeset ___ssu_FailLog_Base_nonExit_comment="${4}";
	_ssu_outputFailLogAndFailSet_nonExit "${___ssu_FailLog_Base_nonExit_assert_name}" "${___ssu_FailLog_Base_nonExit_message1}" "${___ssu_FailLog_Base_nonExit_message2}" "${___ssu_FailLog_Base_nonExit_comment}"
}
_ssu_FailLog_False(){
	typeset ___ssu_FailLog_False_assert_name="${1}";
	typeset ___ssu_FailLog_False_message1="unexpect Value : ${2}";
	typeset ___ssu_FailLog_False_message2="actual Value : ${3}";
	typeset ___ssu_FailLog_False_comment="${4}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_False_assert_name}" "${___ssu_FailLog_False_message1}" "${___ssu_FailLog_False_message2}" "${___ssu_FailLog_False_comment}"
}
_ssu_FailLog_File(){
	typeset ___ssu_FailLog_File_assert_name="${1}";
	typeset ___ssu_FailLog_File_message1="not found or directory? : ${2}";
	typeset ___ssu_FailLog_File_comment="${3}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_File_assert_name}" "${___ssu_FailLog_File_message1}" " " "${___ssu_FailLog_File_comment}"
}
_ssu_FailLog_NotFoundFile(){
	typeset ___ssu_FailLog_NotFoundFile_assert_name="${1}";
	typeset ___ssu_FailLog_NotFoundFile_message1="exist : ${2}";
	typeset ___ssu_FailLog_NotFoundFile_comment="${3}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_NotFoundFile_assert_name}" "${___ssu_FailLog_NotFoundFile_message1}" " " "${___ssu_FailLog_NotFoundFile_comment}"
}
_ssu_FailLog_Blank(){
	typeset ___ssu_FailLog_Blank_assert_name="${1}";
	typeset ___ssu_FailLog_Blank_message1="not blank : ${2}";
	typeset ___ssu_FailLog_Blank_comment="${3}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_Blank_assert_name}" "${___ssu_FailLog_Blank_message1}" " " "${___ssu_FailLog_Blank_comment}"
}
_ssu_FailLog_Include(){
	typeset ___ssu_FailLog_Include_assert_name="${1}";
	typeset ___ssu_FailLog_Include_message1="not find \"${2}\" in ${3}";
	typeset ___ssu_FailLog_Include_comment="${4}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_Include_assert_name}" "${___ssu_FailLog_Include_message1}" " " "${___ssu_FailLog_Include_comment}"
}
_ssu_FailLog_NotInclude(){
	typeset ___ssu_FailLog_NotInclude_assert_name="${1}";
	typeset ___ssu_FailLog_NotInclude_message1="find \" ${2} \" in ${3}";
	typeset ___ssu_FailLog_NotInclude_comment="${4}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_NotInclude_assert_name}" "${___ssu_FailLog_NotInclude_message1}" " " "${___ssu_FailLog_NotInclude_comment}"
}
_ssu_FailLog_SameFile(){
	typeset ___ssu_FailLog_SameFile_assert_name="${1}";
	typeset ___ssu_FailLog_SameFile_message1="expect File : ${2}";
	typeset ___ssu_FailLog_SameFile_message2="actual File : ${3}";
	typeset ___ssu_FailLog_SameFile_comment="${4}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_SameFile_assert_name}" "${___ssu_FailLog_SameFile_message1}" "${___ssu_FailLog_SameFile_message2}" "${___ssu_FailLog_SameFile_comment}"
}
_ssu_FailLog_FileDateOrder(){
	typeset ___ssu_FailLog_FileDateOrder_assert_name="${1}";
	typeset ___ssu_FailLog_FileDateOrder_message1="expect time : ${2}";
	typeset ___ssu_FailLog_FileDateOrder_message2="actual time : ${3}";
	typeset ___ssu_FailLog_FileDateOrder_comment="${4}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_FileDateOrder_assert_name}" "${___ssu_FailLog_FileDateOrder_message1}" "${___ssu_FailLog_FileDateOrder_message2}" "${___ssu_FailLog_FileDateOrder_comment}"
}
_ssu_FailLog_DB(){
	typeset ___ssu_FailLog_DB_assert_name="${1}";
	typeset ___ssu_FailLog_DB_message1="${2}";
	typeset ___ssu_FailLog_DB_comment="${3}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_DB_assert_name}" "${___ssu_FailLog_DB_message1}" " " "${___ssu_FailLog_DB_comment}"
}

_ssu_FailLog_fail(){
	typeset ___ssu_FailLog_fail_assert_name="${1}";
	typeset ___ssu_FailLog_fail_comment="${2}";
	_ssu_outputFailLogAndFailSet "${___ssu_FailLog_fail_assert_name}" "${___ssu_FailLog_fail_comment}" " " " "
}
_ssu_outputFailLogAndFailSet_nonExit(){
	typeset ___ssu_outputFailLogAndFailSet_nonExit_assert_name="${1}";
	typeset ___ssu_outputFailLogAndFailSet_nonExit_message1="${2}";
	typeset ___ssu_outputFailLogAndFailSet_nonExit_message2="${3}";
	typeset ___ssu_outputFailLogAndFailSet_nonExit_comment="${4}";
	if [ "${___ssu_outputFailLogAndFailSet_nonExit_comment}" = " " ]
	then
		___ssu_outputFailLogAndFailSet_nonExit_comment="";
	fi
	printf "\n";
	printf "\033[1;31m!!  Assert Fail !!!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m\n" -e
	printf "\033[1;31mTEST_CASE = ${_ssu_casename}\033[0m\n" -e
	printf "\033[1;31mTEST_NAME = ${_ssu_CurrentTestName}\033[0m\n" -e
	printf "\033[1;31mASSERT_NAME = ${___ssu_outputFailLogAndFailSet_nonExit_assert_name}\033[0m\n" -e
	printf "\033[1;31mASSERT_INDEX = ${_ssu_CurrentAssertIndex}\033[0m\n" -e
	printf "\033[1;31m${___ssu_outputFailLogAndFailSet_nonExit_message1}\033[0m\n" -e
	if [ ${#___ssu_outputFailLogAndFailSet_nonExit_message2} -ne 0 ]
	then
		printf "\033[1;31m${___ssu_outputFailLogAndFailSet_nonExit_message2}\033[0m\n" -e
	fi
	
	if [ ${#___ssu_outputFailLogAndFailSet_nonExit_comment} -ne 0 ]
	then
		printf "\033[1;31m${___ssu_outputFailLogAndFailSet_nonExit_comment}\033[0m\n" -e
	fi
	printf "\033[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m\n" -e
	printf "\n";
}
_ssu_outputFailLogAndFailSet(){
	_ssu_outputFailLogAndFailSet_nonExit "$1" "$2" "$3" "$4"
	exit 99;
}

_ssu_ErrExit(){
	printf "\033[1;31m${1} Wrong Arguments in ${_ssu_CurrentTestName}@${_ssu_casename}\033[0m\n" -e
	if [[ $# == 2 ]]
	then
		printf "\033[1;31m${2}\033[0m\n" -e
	fi
	printf "\033[1;31mThis test-shell exit!!\033[0m\n" -e
	exit 99;
}
_ssu_ErrExit2(){
	printf "\033[1;31mError!! in ${_ssu_CurrentTestName}@${_ssu_casename}\033[0m\n" -e
	printf "\033[1;31m${1}\033[0m\n" -e
	printf "\033[1;31mThis test-shell exit!!\033[0m\n" -e
	exit 99;
}

################################################################################
# _ssu_succeedLog
# $1 comment
################################################################################
_ssu_succeedLog(){
	${_ssu_succeedLog_INNER} "$*"
}

_ssu_succeedLog_DEBUG(){
	typeset ___ssu_succeedLog_DEBUG_mes=${2}
	if [ "${___ssu_succeedLog_DEBUG_mes}" = " " ]
	then
		___ssu_succeedLog_DEBUG_mes="";
	fi

	if [ "${SSU_DEBUG_MODE}" = "ON" ]; then
		echo "";
		echo "************   Assertion   ******************";
		echo " ${1} is passed."
		if [ ${#___ssu_succeedLog_DEBUG_mes} -ne 0 ]
		then
			echo "${___ssu_succeedLog_DEBUG_mes}";
		fi
		echo "*********************************************";
		echo "";
	fi
}

_ssu_succeedLog_NOT_DEBUG(){
	typeset ___ssu_succeedLog_NOT_DEBUG_dummy="";
}


################################################################################
## assert util
################################################################################
_ssu_TempFileName(){
	typeset ___ssu_TempFileName_name=`basename $1`
	typeset ___ssu_TempFileName_tempName=${___ssu_TempFileName_name}"__"
	typeset ___ssu_TempFileName_i=1
	while [[ -a ${_ssu_WorkDir}/"${___ssu_TempFileName_tempName}${___ssu_TempFileName_i}" ]] 
	do
		___ssu_TempFileName_i=$((${___ssu_TempFileName_i}+1))
	done
	touch ${_ssu_WorkDir}/"${___ssu_TempFileName_tempName}${___ssu_TempFileName_i}"
	echo ${_ssu_WorkDir}/"${___ssu_TempFileName_tempName}${___ssu_TempFileName_i}"
}

_ssu_FindModByNum(){
	typeset ___ssu_FindModByNum_m=`ls -l ${1} |cut -d " " -f 1`
	typeset ___ssu_FindModByNum_t=`echo ${___ssu_FindModByNum_m} | cut  -c 2-4`
	typeset ___ssu_FindModByNum_num=`_ssu_ModToNum ${___ssu_FindModByNum_t}`
	___ssu_FindModByNum_t=`echo ${___ssu_FindModByNum_m} | cut  -c 5-7`
	typeset ___ssu_FindModByNum_temp=`_ssu_ModToNum ${___ssu_FindModByNum_t}`
	___ssu_FindModByNum_num=${___ssu_FindModByNum_num}${___ssu_FindModByNum_temp}
	___ssu_FindModByNum_t=`echo ${___ssu_FindModByNum_m} | cut  -c 8-`
	___ssu_FindModByNum_temp=`_ssu_ModToNum ${___ssu_FindModByNum_t}`
	___ssu_FindModByNum_num=${___ssu_FindModByNum_num}${___ssu_FindModByNum_temp}
	echo $___ssu_FindModByNum_num
}

_ssu_ModToNum(){
	typeset ___ssu_ModToNum_i=0;
	typeset ___ssu_ModToNum_t=`echo ${1} | cut -c 1`
	if [ ${___ssu_ModToNum_t} = "r" ];then
		___ssu_ModToNum_i=$((${___ssu_ModToNum_i}+4))
	fi
	___ssu_ModToNum_t=`echo ${1} | cut -c 2`
	if [ ${___ssu_ModToNum_t} = "w" ];then
		___ssu_ModToNum_i=$((${___ssu_ModToNum_i}+2))
	fi
	___ssu_ModToNum_t=`echo ${1} | cut -c 3`
	if [ ${___ssu_ModToNum_t} = "x" ];then
		___ssu_ModToNum_i=$((${___ssu_ModToNum_i}+1))
	fi
	echo ${___ssu_ModToNum_i}
}

_ssu_LsFulltime(){
	typeset ___ssu_LsFulltime_file="${1}"
	typeset ___ssu_LsFulltime_op="${2}"
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "util" "file-time" "${___ssu_LsFulltime_file}"
}

_ssu_FromDateStyleToInt(){
	echo ${1} |tr -d "-" |tr -d "/" | tr -d " " |tr -d ":"
}



