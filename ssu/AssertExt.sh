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
# plural_timer_on
################################################################################
plural_timer_on(){
	if [ x"$_ssu_plural_TimerStart" = "x" ];then
		_ssu_plural_TimerStart=`_ssu_TempFileName "timerstart"`
		_ssu_plural_TimerEnd=`_ssu_TempFileName "timerend"`
		_ssu_plural_TimerDStart=`_ssu_TempFileName "timerstart"`
		_ssu_plural_TimerDEnd=`_ssu_TempFileName "timerend"`
		_ssu_plural_Times=`_ssu_TempFileName "times"`
	fi
	touch "$_ssu_plural_TimerStart"
}
################################################################################
# plural_timer_off
################################################################################
plural_timer_off(){
	touch "$_ssu_plural_TimerEnd"
	typeset __plural_timer_off_r=$?
	if [ $__plural_timer_off_r -ne 0 ];then
		_ssu_ErrExit "plural_timer_off";
	fi
	
	touch "$_ssu_plural_TimerDStart"
	touch "$_ssu_plural_TimerDEnd"
	
	typeset __plural_timer_off_actual_time=0
	__plural_timer_off_actual_time=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "gettime" "${_ssu_plural_TimerStart}" "${_ssu_plural_TimerEnd}" "$_ssu_plural_TimerDStart" "$_ssu_plural_TimerDEnd"`
	echo $__plural_timer_off_actual_time >> "$_ssu_plural_Times"
}

################################################################################
# plural_timer_report
################################################################################
plural_timer_report(){
	if [ ! -f "$_ssu_plural_Times" ];then
		_ssu_ErrExit "plural_timer_report";
	fi
	_ssu_plural_TimerStart=""
	typeset __plural_timer_report_flag=".";
	if [ $# = 1 ];then
		__plural_timer_report_flag="${1}"
	fi
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "timer_report" "$__plural_timer_report_flag" "$_ssu_plural_Times"
}
################################################################################
# assert_plural_timer
################################################################################
assert_plural_timer(){
	if [ ! -f "$_ssu_plural_Times" ];then
		_ssu_ErrExit "assert_plural_timer";
	fi
	_ssu_plural_TimerStart=""

	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_plural_timer";
	fi
	typeset __assert_plural_timer_expect="${1}";
	typeset __assert_plural_timer_comment=" ";
	if [ $# = 2 ]
	then
		__assert_plural_timer_comment="${2}";
	fi
	touch "$_ssu_TimerDStart"
	touch "$_ssu_TimerDEnd"
	typeset __assert_plural_timer_actual=0
	__assert_plural_timer_actual=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "timer_ave" "$__assert_plural_timer_expect" "$_ssu_plural_Times"`
	_ssu_TimerEnd=""
	if [ "${__assert_plural_timer_actual}" = "0" ]
	then
		_ssu_succeedLog "assert_plural_timer" "${__assert_plural_timer_expect}";
	else
		_ssu_FailLog_Base  "assert_plural_timer" "${__assert_plural_timer_expect}" "${__assert_plural_timer_actual}" "${__assert_plural_timer_comment}";
	fi
}
################################################################################
# check_plural_timer
################################################################################
check_plural_timer(){
	if [ ! -f "$_ssu_plural_Times" ];then
		_ssu_ErrExit "check_plural_timer";
	fi
	_ssu_plural_TimerStart=""

	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "check_plural_timer";
	fi
	typeset __check_plural_timer_expect="${1}";
	typeset __check_plural_timer_comment=" ";
	if [ $# = 2 ]
	then
		__check_plural_timer_comment="${2}";
	fi
	touch "$_ssu_TimerDStart"
	touch "$_ssu_TimerDEnd"
	typeset __check_plural_timer_actual_time=0
	__check_plural_timer_actual_time=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "timer_ave" "$__check_plural_timer_expect" "$_ssu_plural_Times"`
	_ssu_TimerEnd=""
	if [ "${__check_plural_timer_actual_time}" = "0" ]
	then
		_ssu_succeedLog "check_plural_timer" "${__check_plural_timer_comment}";
	else
		_ssu_FailLog_Base_nonExit  "check_plural_timer" "${__check_plural_timer_expect}" "${__check_plural_timer_actual_time}" "${__check_plural_timer_comment}";
	fi
}

################################################################################
# timer_on
################################################################################
timer_on(){
	_ssu_TimerStart=`_ssu_TempFileName "timerstart"`
	_ssu_TimerEnd=`_ssu_TempFileName "timerend"`
	_ssu_TimerDStart=`_ssu_TempFileName "timerstart"`
	_ssu_TimerDEnd=`_ssu_TempFileName "timerend"`
	touch "$_ssu_TimerStart"
}
################################################################################
# assert_timer
# $1 time [millis]
# $2 comment (option)
################################################################################
assert_timer(){
	touch "$_ssu_TimerEnd"
	typeset __assert_timer_r=$?
	_ssu_AssertSetUp;
	if [ $__assert_timer_r -ne 0 ];then
		_ssu_ErrExit "assert_timer";
	fi
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_timer";
	fi
	typeset __assert_timer_expect="${1}";
	typeset __assert_timer_comment=" ";
	if [ $# = 2 ]
	then
		__assert_timer_comment="${2}";
	fi
	touch "$_ssu_TimerDStart"
	touch "$_ssu_TimerDEnd"
	typeset __assert_timer_actual=0
	__assert_timer_actual=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "timer" "$__assert_timer_expect" "${_ssu_TimerStart}" "${_ssu_TimerEnd}" "$_ssu_TimerDStart" "$_ssu_TimerDEnd"`
	_ssu_TimerEnd=""
	if [ "${__assert_timer_actual}" = "0" ]
	then
		_ssu_succeedLog "assert_timer" "${__assert_timer_comment}";
	else
		_ssu_FailLog_Base  "assert_timer" "${__assert_timer_expect}" "${__assert_timer_actual}" "${__assert_timer_comment}";
	fi
}

################################################################################
# check_timer
# $1 time [millis]
# $2 comment (option)
################################################################################
check_timer(){
	touch "$_ssu_TimerEnd"
	typeset __check_timer_r=$?
	_ssu_AssertSetUp;
	if [ $__check_timer_r -ne 0 ];then
		_ssu_ErrExit "check_timer";
	fi
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "check_timer";
	fi
	typeset __check_timer_expect="${1}";
	typeset __check_timer_comment=" ";
	if [ $# = 2 ]
	then
		__check_timer_comment="${2}";
	fi
	touch "$_ssu_TimerDStart"
	touch "$_ssu_TimerDEnd"
	typeset __check_timer_actual=0
	__check_timer_actual=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "timer" "$__check_timer_expect" "${_ssu_TimerStart}" "${_ssu_TimerEnd}" "$_ssu_TimerDStart" "$_ssu_TimerDEnd"`
	_ssu_TimerEnd=""
	if [ "${__check_timer_actual}" = "0" ]
	then
		_ssu_succeedLog "check_timer" "${__check_timer_comment}";
	else
		_ssu_FailLog_Base_nonExit  "check_timer" "${__check_timer_expect}" "${__check_timer_actual}" "${__check_timer_comment}";
	fi
}


################################################################################
# assert_db
# 
# $1 expect file
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db";
	fi
	typeset __assert_db_file="${1}";
	typeset __assert_db_table="${2}";
	typeset __assert_db_where=" ";
	typeset __assert_db_comment=" ";
	if [ $# = 3 ]
	then
		__assert_db_where="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_where="${3}";
		__assert_db_comment="${4}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectComp" "${__assert_db_file}" "${__assert_db_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}`
	typeset __assert_db_rc=$?
	if [ ${__assert_db_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db" "${__assert_db_comment}";
	else
		_ssu_FailLog_DB "assert_db" "${_ssu_TempVar}" "${__assert_db_comment}";
	fi
}

################################################################################
# assert_db_with_conv
# 
# $1 expect file
# $2 table
# $3 convert_prop_file_path (option)
# $4 where-condition (option)
# $5 comment (option) require where-condition
################################################################################
assert_db_with_conv(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 && $# != 5 ]]
	then
		_ssu_ErrExit "assert_db_with_conv";
	fi
	typeset __assert_db_with_conv_file="${1}";
	typeset __assert_db_with_conv_table="${2}";
	typeset __assert_db_with_conv_cp_path="${SSU_HOME}";
	typeset __assert_db_with_conv_where='.';
	typeset __assert_db_with_conv_comment=" ";
	if [ $# = 3 ]
	then
		__assert_db_with_conv_cp_path="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_with_conv_cp_path="${3}";
		__assert_db_with_conv_where="${4}";
	fi
	if [ $# = 5 ]
	then
		__assert_db_with_conv_cp_path="${3}";
		__assert_db_with_conv_where="${4}";
		__assert_db_with_conv_comment="${5}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectComp.conv" "${__assert_db_with_conv_file}" "${__assert_db_with_conv_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_with_conv_where}" "${SSU_JDBC_USER}" "${SSU_JDBC_PASSWORD}" "${__assert_db_with_conv_cp_path}"`
	typeset __assert_db_with_conv_rc=$?
	if [ ${__assert_db_with_conv_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_with_conv" "${__assert_db_with_conv_comment}";
	else
		_ssu_FailLog_DB "assert_db_with_conv" "${_ssu_TempVar}" "${__assert_db_with_conv_comment}";
	fi
}

################################################################################
# assert_db_ordered
# 
# $1 expect file
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_ordered(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db_ordered";
	fi
	typeset __assert_db_ordered_file="${1}";
	typeset __assert_db_ordered_table="${2}";
	typeset __assert_db_ordered_where=" ";
	typeset __assert_db_ordered_comment=" ";
	if [ $# = 3 ]
	then
		__assert_db_ordered_where="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_ordered_where="${3}";
		__assert_db_ordered_comment="${4}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectCompOrder" "${__assert_db_ordered_file}" "${__assert_db_ordered_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_ordered_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}`
	typeset __assert_db_ordered_rc=$?
	if [ ${__assert_db_ordered_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_ordered" "${__assert_db_ordered_comment}";
	else
		_ssu_FailLog_DB "assert_db_ordered" "${_ssu_TempVar}" "${__assert_db_ordered_comment}";
	fi
}

################################################################################
# assert_db_ordered_with_conv
# 
# $1 expect file
# $2 table
# $3 convert_prop_file_path (option)
# $4 where-condition (option)
# $5 comment (option) require where-condition
################################################################################
assert_db_ordered_with_conv(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 && $# != 5 ]]
	then
		_ssu_ErrExit "assert_db_ordered_with_conv";
	fi
	typeset __assert_db_ordered_with_conv_file="${1}";
	typeset __assert_db_ordered_with_conv_table="${2}";
	typeset __assert_db_ordered_with_conv_cp_path="${SSU_HOME}";
	typeset __assert_db_ordered_with_conv_where='.';
	typeset __assert_db_ordered_with_conv_comment=" ";
	
	if [ $# = 3 ]
	then
		__assert_db_ordered_with_conv_cp_path="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_ordered_with_conv_cp_path="${3}";
		__assert_db_ordered_with_conv_where="${4}";
	fi
	if [ $# = 5 ]
	then
		__assert_db_ordered_with_conv_cp_path="${3}";
		__assert_db_ordered_with_conv_where="${4}";
		__assert_db_ordered_with_conv_comment="${5}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectCompOrder.conv" "${__assert_db_ordered_with_conv_file}" "${__assert_db_ordered_with_conv_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_ordered_with_conv_where}" "${SSU_JDBC_USER}" "${SSU_JDBC_PASSWORD}" "${__assert_db_ordered_with_conv_cp_path}"`
	typeset __assert_db_ordered_with_conv_rc=$?
	if [ ${__assert_db_ordered_with_conv_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_ordered_with_conv" "${__assert_db_ordered_with_conv_comment}";
	else
		_ssu_FailLog_DB "assert_db_ordered_with_conv" "${_ssu_TempVar}" "${__assert_db_ordered_with_conv_comment}";
	fi
}

################################################################################
# assert_db_include
# 
# $1 expect file
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_include(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db";
	fi
	typeset __assert_db_include_file="${1}";
	typeset __assert_db_include_table="${2}";
	typeset __assert_db_include_where=" ";
	typeset __assert_db_include_comment=" ";
	if [ $# = 3 ]
	then
		__assert_db_include_where="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_include_where="${3}";
		__assert_db_include_comment="${4}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectInc" "${__assert_db_include_file}" "${__assert_db_include_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_include_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}`
	typeset __assert_db_include_rc=$?
	if [ ${__assert_db_include_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_include" "${__assert_db_include_comment}";
	else
		_ssu_FailLog_DB "assert_db_include" "${_ssu_TempVar}" "${__assert_db_include_comment}";
	fi
}


################################################################################
# assert_db_include_with_conv
# 
# $1 expect file
# $2 table
# $3 convert_prop_file_path (option)
# $4 where-condition (option)
# $5 comment (option) require where-condition
################################################################################
assert_db_include_with_conv(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 && $# != 5 ]]
	then
		_ssu_ErrExit "assert_db_include_with_conv";
	fi
	typeset __assert_db_include_with_conv_file="${1}";
	typeset __assert_db_include_with_conv_table="${2}";
	typeset __assert_db_include_with_conv_cp_path="${SSU_HOME}";
	typeset __assert_db_include_with_conv_where='.';
	typeset __assert_db_include_with_conv_comment=" ";
	
	if [ $# = 3 ]
	then
		__assert_db_include_with_conv_cp_path="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_include_with_conv_cp_path="${3}";
		__assert_db_include_with_conv_where="${4}";
	fi
	if [ $# = 5 ]
	then
		__assert_db_include_with_conv_cp_path="${3}";
		__assert_db_include_with_conv_where="${4}";
		__assert_db_include_with_conv_comment="${5}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectInc.conv" "${__assert_db_include_with_conv_file}" "${__assert_db_include_with_conv_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_include_with_conv_where}" "${SSU_JDBC_USER}" "${SSU_JDBC_PASSWORD}" "${__assert_db_include_with_conv_cp_path}"`
	typeset __assert_db_include_with_conv_rc=$?
	if [ ${__assert_db_include_with_conv_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_include_with_conv" "${__assert_db_include_with_conv_comment}";
	else
		_ssu_FailLog_DB "assert_db_include_with_conv" "${_ssu_TempVar}" "${__assert_db_include_with_conv_comment}";
	fi
}


################################################################################
# assert_db_count
# 
# $1 expect count
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_count(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db_count";
	fi
	typeset __assert_db_count_count="${1}";
	typeset __assert_db_count_table="${2}";
	typeset __assert_db_count_where=" ";
	typeset __assert_db_count_comment=" ";
	if [ $# = 3 ]
	then
		__assert_db_count_where="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_count_where="${3}";
		__assert_db_count_comment="${4}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "count" "${__assert_db_count_count}" "${__assert_db_count_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_count_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}`
	typeset __assert_db_count_rc=$?
	if [ ${__assert_db_count_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_count" "${__assert_db_count_comment}";
	else
		_ssu_FailLog_DB "assert_db_count" "${_ssu_TempVar}" "${__assert_db_count_comment}";
	fi
}

################################################################################
# assert_db_not_same_count
# 
# $1 not expect count
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_not_same_count(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db_not_same_count";
	fi
	typeset __assert_db_not_same_count_count="${1}";
	typeset __assert_db_not_same_count_table="${2}";
	typeset __assert_db_not_same_count_where=" ";
	typeset __assert_db_not_same_count_comment=" ";
	if [ $# = 3 ]
	then
		__assert_db_not_same_count_where="${3}";
	fi
	if [ $# = 4 ]
	then
		__assert_db_not_same_count_where="${3}";
		__assert_db_not_same_count_comment="${4}";
	fi
	_ssu_TempVar=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "countnot" "${__assert_db_not_same_count_count}" "${__assert_db_not_same_count_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__assert_db_not_same_count_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}`
	typeset __assert_db_not_same_count_rc=$?
	if [ ${__assert_db_not_same_count_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_not_same_count" "${__assert_db_not_same_count_comment}";
	else
		_ssu_FailLog_DB "assert_db_not_same_count" "${_ssu_TempVar}" "${__assert_db_not_same_count_comment}";
	fi
}


################################################################################
# assert_db_connect
# 
################################################################################
assert_db_connect(){
	_ssu_AssertSetUp;
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBConnectTest "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD};
	typeset __assert_db_connect_rc=$?
	if [ ${__assert_db_connect_rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_connect" "";
	else
		_ssu_FailLog_DB "assert_db_connect" "${SSU_JDBC_URL}" "";
	fi
}

