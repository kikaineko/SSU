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
#
# SSU : ShellScript Unit
# You can use this tool as xUnit.
# This tool requires Asser.sh,  ssu.jar and Util.sh
#
# author : Masayuki Ioki,Takumi Hosaka,Teruyuki Takazawa
# Version : 0.5
_ssu_version="0.5_2009.03.06"
################################################################################
################################################################################
## You MUST Define "SSU_HOME" in your test_case.
## SSU_HOME is relative path-name from your test_case to SSU.
## like SSU_HOME="../test" (/home/foo/test/SSU.sh , /home/foo/testcase/test.sh)

#SSU_SELFPATH is an old version var.
SSU_SELFPATH=""
SSU_HOME=""

################################################################################
## Options -start-

if [ x"$_ssu_SUITE_DEBUG_MODE" = "x" ];then
	_ssu_SUITE_DEBUG_MODE="";
fi
SSU_DEBUG_MODE=OFF;
DEBUG_MODE=OFF;
SSU_TEST_PATTERN="^test";
TARGET_TEST_PATTERN="^test";
SSU_EVIDENCE_BASEDIR="";
SSU_CHARCODE=""

if [ x"$_ssu_SUITE_REPORT" = "x" ];then
	_ssu_SUITE_REPORT="";
fi
SSU_REPORT=OFF
_ssu_REPORT_FILE="report.txt"

## SSU requires Java.
## Please define Your JavaPath.
## eg. SSU_JAVA_CMD="/opt/java/bin/java"
JAVA_CMD="java";
JAVA_OPTION=""
SSU_JAVA_CMD="java";
SSU_JAVA_OPTION=""

## If you use assert_db*, please set these vars.
## e.g. SSU_JDBC_JAR="/opt/oraclexe/app/oracle/product/10.2.0/server/jdbc/lib/ojdbc14.jar";
##      SSU_JDBC_EXT_JAR="/opt/ibm/db2/V9.1/java/db2jcc_license_cu.jar"
##      SSU_JDBC_CLASS="oracle.jdbc.driver.OracleDriver";
##      SSU_JDBC_URL="jdbc:oracle:thin:@localhost:1521:xe";
##      SSU_JDBC_USER="pooh";
##      SSU_JDBC_PASSWORD="piglet";
JDBC_JAR="";
JDBC_CLASS="";
JDBC_URL="";
JDBC_USER="";
JDBC_PASSWORD="";

SSU_JDBC_JAR="";
SSU_JDBC_EXT_JAR="";
SSU_JDBC_CLASS="";
SSU_JDBC_URL="";
SSU_JDBC_USER="";
SSU_JDBC_PASSWORD="";

## Options -end-
################################################################################
################################################################################
################################################################################
################################################################################

_ssu_old_to_new(){
	if [ "$SSU_HOME" = "" ];then
		SSU_HOME="$SSU_SELFPATH"
	fi
	
	if [ "$SSU_DEBUG_MODE" = "OFF" ];then
		SSU_DEBUG_MODE="$DEBUG_MODE"
	fi
	if [ "$SSU_TEST_PATTERN" = "^test" ];then
		SSU_TEST_PATTERN="$TARGET_TEST_PATTERN"
	fi
	
	if [ "$SSU_JAVA_CMD" = "java" ];then
		SSU_JAVA_CMD="$JAVA_CMD"
	fi
	if [ "$SSU_JAVA_OPTION" = "" ];then
		SSU_JAVA_OPTION="$JAVA_OPTION"
	fi
	
	if [ "$SSU_JDBC_JAR" = "" ];then
		SSU_JDBC_JAR="$JDBC_JAR"
	fi
	if [ "$SSU_JDBC_CLASS" = "" ];then
		SSU_JDBC_CLASS="$JDBC_CLASS"
	fi
	if [ "$SSU_JDBC_URL" = "" ];then
		SSU_JDBC_URL="$JDBC_URL"
	fi
	if [ "$SSU_JDBC_USER" = "" ];then
		SSU_JDBC_USER="$JDBC_USER"
	fi
	if [ "$SSU_JDBC_PASSWORD" = "" ];then
		SSU_JDBC_PASSWORD="$JDBC_PASSWORD"
	fi
}

_ssu_map_abst(){
	SSU_HOME=`_ssu_to_abst "${SSU_HOME}"`
	SSU_JDBC_JAR=`_ssu_to_abst "${SSU_JDBC_JAR}"`
    SSU_JDBC_EXT_JAR=`_ssu_to_abst "${SSU_JDBC_EXT_JAR}"`
    SSU_JDBC_JAR=${SSU_JDBC_JAR}:${SSU_JDBC_EXT_JAR}
}

_ssu_to_abst(){
	typeset ___ssu_to_abst_f="$1"
	typeset ___ssu_to_abst_dir=`dirname "${___ssu_to_abst_f}"`
	typeset ___ssu_to_abst_base=`basename "${___ssu_to_abst_f}"`
	typeset ___ssu_to_abst_current=`pwd`
	cd "$___ssu_to_abst_dir"
	typeset ___ssu_to_abst_abst_dir=`pwd`
	cd "$___ssu_to_abst_current"
	
	if [ "$___ssu_to_abst_abst_dir" != "/" ];then
		echo "$___ssu_to_abst_abst_dir"/"$___ssu_to_abst_base"
	else
		echo /"$___ssu_to_abst_base"
	fi
}

################################################################################
################################################################################

_ssu_CurrentTestName=""; #current executing test-function name
_ssu_CurrentAssertIndex=0; #current executing assert index

_ssu_WorkDir="" #for temp file

_ssu_UtilJar=""
_ssu_jarsep=":"

_ssu_TestJobID=""

_ssu_evi_dir=""
_ssu_Lock=""

_ssu_succeedLog_INNER="_ssu_succeedLog_DEBUG"

if [ "$_ssu_suite_inner_flag" != "on" ];then
	_ssu_suite_inner_flag="off"
fi

_ssu_run_dir=`pwd`
## suite 
################################################################################
_ssu_casename=`basename $0`
if [ "$_ssu_suite_mode" != "on" ];then
	_ssu_suite_color="green"
	_ssu_suite_test_cnt=0
	_ssu_suite_test_max=0
else
	_ssu_casename=$_ssu_suite_testName
fi
################################################################################

if [ $# = 1 ]
then
	if [ "$1" = "-version" ]
	then
		echo "SSU version "$_ssu_version
		echo "author Masayuki Ioki,Takumi Hosaka,Teruyuki Takazawa."
		exit 1
	fi
fi

################################################################################
# at Runtime, This function runs Only Once.
################################################################################
_ssu_BeforeTest(){

	if [ "${SSU_DEBUG_MODE}" = "ON" ]; then
		echo ""
		echo "###########################################################################"
		echo "Start : ${_ssu_casename}"
		echo ""
		
		_ssu_succeedLog_INNER="_ssu_succeedLog_DEBUG"
	fi

	beforeTest;
}

################################################################################
# beforeTest
# Execute Before Test(Only once).
# This is dummy.Plese override.
################################################################################
beforeTest(){
	typeset __beforeTest_dummy="";
}

################################################################################
# _ssu_SetUp
# inner setup
################################################################################
_ssu_SetUp(){

	if [ "${SSU_DEBUG_MODE}" = "ON" ]; then
		typeset ___ssu_SetUp_case_name=$1
		echo "";
		echo "------------------------------------------------------------------";
		echo "TestCase Start : ${___ssu_SetUp_case_name}";
	fi
	
	setUp;
}

################################################################################
# setUp
# Execute setUp(Each test-functions).
# This is dummy.Plese override.
################################################################################
setUp(){
	typeset __setUp_dummy="";
}

################################################################################
# _ssu_TearDown
# inner teardown
################################################################################
_ssu_TearDown(){

	tearDown;
	_ssu_tearDown_h;
	_ssu_TeardownForEvidence_test
	if [ "${SSU_DEBUG_MODE}" = "ON" ]; then
		typeset ___ssu_TearDown_case_num=$1;
		echo "TestCase END : ${___ssu_TearDown_case_num}";
		echo "------------------------------------------------------------------";
		echo "";
	fi
}

################################################################################
# tearDown
# Please Override.
# this is dummy.
################################################################################
tearDown(){
	typeset __tearDown_dummy=;
}

################################################################################
# _ssu_AfterTest
################################################################################
_ssu_AfterTest(){

        if [ "${SSU_DEBUG_MODE}" = "ON" ]; then
		typeset ___ssu_AfterTest_sh_name=`basename $0`;
                echo "";
                echo "Done : ${___ssu_AfterTest_sh_name}";
                echo "###########################################################################";
        fi

        afterTest;
}

################################################################################
# afterTest
# Execute After Test(Only once).
# This is dummy.Plese override.
################################################################################
afterTest(){
        typeset __afterTest_dummy="";
}


################################################################################
# Each Test Runs.
################################################################################
_ssu_DoSSU(){
	if [ ${#_ssu_TestArray[*]} -eq 0 ]
	then 
		echo "No TestCase.";
		exit 1;
	fi

	_ssu_cnt=0;
	_ssu_countOfSuccessTest=0;
	_ssu_countOfFailedTest=0;

	_ssu_SetupForCoverage

	_ssu_BeforeTest;
	typeset ___ssu_DoSSU_test_cnt_max=${#_ssu_TestArray[*]}
	typeset ___ssu_DoSSU_color="green";
	
	#Each Test Run!
	while [ ${_ssu_cnt} -lt ${#_ssu_TestArray[*]} ]
	do
		
		_ssu_CurrentTestName=${_ssu_TestArray[$_ssu_cnt]};
		_ssu_mkdir_evi_test
		
		if [ "${SSU_DEBUG_MODE}" != "ON" ]; then
			_ssu_display_bar "START ${_ssu_CurrentTestName}" "${_ssu_cnt}" "${___ssu_DoSSU_test_cnt_max}" "${___ssu_DoSSU_color}"
		fi
		
		#testing
		_ssu_test_run &
		_ssu_TestJobID=$!;
		wait ${_ssu_TestJobID};
		typeset ___ssu_DoSSU_test_rc=$?;
		_ssu_TestJobID="";
		
		#result testing
		if [ ${___ssu_DoSSU_test_rc} -eq 0 ] 
		then 
			echo "    $_ssu_CurrentTestName  -> OK!" >> "$_ssu_REPORT_FILE"
			_ssu_countOfSuccessTest=$((${_ssu_countOfSuccessTest}+1))
		else
			echo "    $_ssu_CurrentTestName  -> ERROR!" >> "$_ssu_REPORT_FILE"
			_ssu_countOfFailedTest=$((${_ssu_countOfFailedTest}+1))
			___ssu_DoSSU_color="red"
			_ssu_suite_color="red"
		fi
		
		_ssu_cnt=$((${_ssu_cnt}+1));
		
		cd "${_ssu_run_dir}"
		
		if [ "${SSU_DEBUG_MODE}" != "ON" ]; then
			_ssu_display_bar "END   ${_ssu_CurrentTestName}" "${_ssu_cnt}" "${___ssu_DoSSU_test_cnt_max}" "${___ssu_DoSSU_color}"
		fi
		
	done
	
	if [ "${SSU_DEBUG_MODE}" != "ON" ]; then
		_ssu_display_bar "TEST END" "${_ssu_cnt}" "${___ssu_DoSSU_test_cnt_max}" "${___ssu_DoSSU_color}"
	fi
	
	if [ "$_ssu_suite_mode" != "on" ];then
		echo ""
	fi
    _ssu_AfterTest;
    
}

_ssu_SystemOut(){
	if [[ ${_ssu_cnt} -eq 0 ]]
	then
		return 0;
	fi

	if [ "$_ssu_suite_mode" != "on" ];then
		{
			echo ""
			echo "** Result Of Test ***************************";
			echo "Run Tests:${_ssu_cnt}";
			echo "Success Tests:${_ssu_countOfSuccessTest}";
			echo "Failure Tests:${_ssu_countOfFailedTest}";
			echo "*********************************************";
		} | tee -a "$_ssu_REPORT_FILE" 
	else
		{
			echo ""
			echo "** Result Of Test ***************************";
			echo "Run Tests:${_ssu_cnt}";
			echo "Success Tests:${_ssu_countOfSuccessTest}";
			echo "Failure Tests:${_ssu_countOfFailedTest}";
			echo "*********************************************";
		}  >> "$_ssu_REPORT_FILE" 
	fi
	_ssu_cnt=0
}

################################################################################
# test run function.
################################################################################
_ssu_test_run(){
	if [ ! -f "${_ssu_Lock}" ]
	then
		return 1;
	fi
	echo "1" > ${_ssu_Lock};
	trap _ssu_test_trap_function 0 1 2 3 15
	unset _ssu_tearDown_h_calledFunctions
	
	_ssu_SetUp "${_ssu_CurrentTestName}";
	
	_ssu_CurrentAssertIndex=0;
	
	#testing
	${_ssu_CurrentTestName}
	
	_ssu_TearDown "${_ssu_CurrentTestName}";
}


########################################################################
# trap functions

_ssu_test_trap_function(){
	if [ ! -f "${_ssu_Lock}" ]
	then
		return 1;
	fi
	trap "" 1 2 3 15
	echo "2" > ${_ssu_Lock};
	_ssu_tearDown_h
	_ssu_TeardownForEvidence_test
	echo "3" > ${_ssu_Lock};
}

_ssu_trap_function(){
	if [ "$_ssu_suite_inner_flag" = "on" ];then
		_ssu_suite_SystemOut
		return 0;
	fi
	trap "" 1 2 3 15
	unset _ssu_TestArray
	if [ ! -z "${_ssu_TestJobID}" ]; then
		typeset ___ssu_trap_function_status=`cat ${_ssu_Lock}`
		if [ "${___ssu_trap_function_status}" = "0" -o "${___ssu_trap_function_status}" = "1" ]; then
			kill -15 ${_ssu_TestJobID}
		fi
		___ssu_trap_function_status=`cat ${_ssu_Lock}`
		while [ "${___ssu_trap_function_status}" != "3" ];
		do
			sleep 1
			___ssu_trap_function_status=`cat ${_ssu_Lock}`
		done

		_ssu_TestJobID=""
	fi
	
	_ssu_tearDown_h
	_ssu_TearDownForCoverage
	rm -fr "${_ssu_WorkDir}"
	_ssu_SystemOut
	
	_ssu_report_teardown
	_ssu_TeardownForEvidence
}
trap _ssu_trap_function 0 1 2 3 15


################################################################################
# find functions whose name match SSU_TEST_PATTERN.And execute.
################################################################################
startSSU(){
	## Checking
	_ssu_old_to_new
	_ssu_map_abst
	if [ x"$_ssu_SUITE_DEBUG_MODE" != "x" ];then
		SSU_DEBUG_MODE="$_ssu_SUITE_DEBUG_MODE"
	fi
	if [ x"$_ssu_SUITE_REPORT" != "x" ];then
		SSU_REPORT="$_ssu_SUITE_REPORT"
	fi
	
	if [[ ! -d "${SSU_HOME}" || ! -f "${SSU_HOME}/SSU.sh" ]];then
		echo "\"${SSU_HOME}\" is wrong."
		echo "Please Define SSU_HOME in your test_case."
		exit 1;
	fi
	if [ ! -w "${SSU_HOME}" ];then
		echo "We cannot write in ${SSU_HOME}"
		echo "Please Allow to write in ${SSU_HOME}"
		exit 1;
	fi
	if [ ! -f "${SSU_HOME}/Assert.sh" ];then
		echo "Not Found Assert.sh in ${SSU_HOME}"
		echo "We need Assert.sh"
		exit 1;
	fi
	if [ ! -f "${SSU_HOME}/AssertExt.sh" ];then
		echo "Not Found AssertExt.sh in ${SSU_HOME}"
		echo "We need AssertExt.sh"
		exit 1;
	fi
	if [ ! -f "${SSU_HOME}/Helper.sh" ];then
		echo "Not Found Helper.sh in ${SSU_HOME}"
		echo "We need Helper.sh"
		exit 1;
	fi
	if [ ! -f "${SSU_HOME}/ssu.jar" ];then
		echo "Not Found ssu.jar in ${SSU_HOME}"
		echo "We need ssu.jar"
		exit 1;
	fi
	
	
	${SSU_JAVA_CMD} -version > /dev/null 2>&1
	typeset __startSSU_rc=$?
	if [ ${__startSSU_rc} -ne 0 ]
	then
		echo "Not Found java"
		echo "We need java!"
		exit 1;
	fi
	
	. ${SSU_HOME}/Helper.sh
	. ${SSU_HOME}/AssertExt.sh
	. ${SSU_HOME}/Assert.sh
	. ${SSU_HOME}/Util.sh

	_ssu_UtilJar="${SSU_HOME}"/ssu.jar
	
	_ssu_setup_for_cygwin

    SSU_JAVA_OPTION="${SSU_JAVA_OPTION} -Dssu.cygwin.root.path=${SSU_CYGWIN_ROOT_PATH} -Dssu.is.cygwin=${SSU_IS_CYGWIN}"

	#make work dir
	_ssu_WorkDir="${SSU_HOME}"/$$;
	typeset __startSSU_i=1;
	while [[ -d "${_ssu_WorkDir}${__startSSU_i}" ]] 
	do
		__startSSU_i=$((${__startSSU_i}+1))
	done
	mkdir "${_ssu_WorkDir}${__startSSU_i}";
	__startSSU_rc=$?
	if [ ${__startSSU_rc} -ne 0 ]
	then
		echo "We Cannot create work dir!! ${_ssu_WorkDir}${__startSSU_i}"
		exit 1;
	fi
	_ssu_WorkDir="${_ssu_WorkDir}${__startSSU_i}";
	touch ${_ssu_WorkDir}/lock;
	__startSSU_rc=$?
	if [ ${__startSSU_rc} -ne 0 ]
	then
		echo "We Cannot create lock file!!"
		exit 1;
	fi
	_ssu_Lock=${_ssu_WorkDir}/lock;
	echo "0" > ${_ssu_Lock};
	#end
	
	_ssu_SetupForEvidence
	_ssu_report_setup
	
	typeset __startSSU_test_funcs=`typeset -f |sed 's/function //'| sed 's/()//' | grep ${SSU_TEST_PATTERN}`;

	typeset __startSSU_t="";
	__startSSU_i=0;
	for __startSSU_t in ${__startSSU_test_funcs}
	do
		_ssu_TestArray[$__startSSU_i]=$__startSSU_t
		__startSSU_i=$(($__startSSU_i+1))
	done

	_ssu_DoSSU;
	
	return $_ssu_countOfFailedTest
}

_ssu_setup_for_cygwin(){
	typeset ___ssu_setup_for_cygwin_isCygwin=`uname |grep CYGWIN`;
	if [ ! -z "${___ssu_setup_for_cygwin_isCygwin}" ]
	then
		_ssu_jarsep=";"
		
		SSU_CYGWIN_ROOT_PATH=`cygpath -aw /`
		export SSU_CYGWIN_ROOT_PATH
		SSU_IS_CYGWIN=1
		export SSU_IS_CYGWIN
		_ssu_UtilJar="$SSU_CYGWIN_ROOT_PATH""$_ssu_UtilJar"
		
		SSU_JDBC_JAR="$SSU_CYGWIN_ROOT_PATH""$SSU_JDBC_JAR"
	fi
}


#####################################################################################################
## below's are For Coverage.
add_ssuCoverageTarget(){
	if [ $# -ne 1 ];then
		echo "Coverage Error!"
		echo "Please give me your CoverageTarget."
		exit 1
	fi
	typeset __add_ssuCoverageTarget_target="$1"
	_ssu_CheckCoverage "$__add_ssuCoverageTarget_target"
	typeset __add_ssuCoverageTarget_ind=`echo ${#_ssu_CoverageTargets[*]}`
	_ssu_CoverageTargets[${__add_ssuCoverageTarget_ind}]="$__add_ssuCoverageTarget_target"
}

_ssu_CheckCoverage(){
	typeset ___ssu_CheckCoverage_target="$1" 
	if [ "${___ssu_CheckCoverage_target}" = "" ];
	then
		echo "Coverage Error!"
		echo "Please give me your CoverageTarget."
		exit 1
	fi
	
	if [ ! -f "${___ssu_CheckCoverage_target}" ];then
		echo "Coverage Error!"
		echo "${___ssu_CheckCoverage_target} is wrong."
		echo "Plase set correct your CoverageTarget Shell or permission error?"
		exit 1;
	fi
	
	if [ ! -w "${___ssu_CheckCoverage_target}" ];then
		echo "Coverage Error!"
		echo "${___ssu_CheckCoverage_target} is wrong."
		echo "Plase set correct your CoverageTarget Shell or permission error?"
		exit 1;
	fi
	
	typeset ___ssu_CheckCoverage_d=`dirname "${___ssu_CheckCoverage_target}"`;
	if [ ! -w "${___ssu_CheckCoverage_d}" ];then
		echo "Coverage Error!"
		echo "${___ssu_CheckCoverage_target} is wrong."
		echo "Plase set correct your CoverageTarget Shell or Dir-permission error?"
		exit 1;
	fi
}

_ssu_SetupForCoverage(){
	typeset ___ssu_SetupForCoverage_ind=`echo ${#_ssu_CoverageTargets[*]}`
	if [ ${___ssu_SetupForCoverage_ind} -eq 0 ];then
		return 0
	fi
	___ssu_SetupForCoverage_ind=0
	while [ ${___ssu_SetupForCoverage_ind} -lt ${#_ssu_CoverageTargets[*]} ]
	do
		typeset ___ssu_SetupForCoverage_target=${_ssu_CoverageTargets[$___ssu_SetupForCoverage_ind]};
		_ssu_iSetup4C "${___ssu_SetupForCoverage_target}"
		___ssu_SetupForCoverage_ind=$((${___ssu_SetupForCoverage_ind}+1));
	done
}
_ssu_iSetup4C(){
	typeset ___ssu_iSetup4C_target="${1}"
	typeset ___ssu_iSetup4C_b=`basename ${___ssu_iSetup4C_target}`
	typeset ___ssu_iSetup4C_backup=`_ssu_TempFileName "${___ssu_iSetup4C_b}"`;
	
	typeset ___ssu_iSetup4C_rc=$?;
	if [ $___ssu_iSetup4C_rc -ne 0 ]
	then
		echo "Cannot BackUP ${___ssu_iSetup4C_target} !";
		exit 1;
	fi
	typeset ___ssu_iSetup4C_expect_f=`_ssu_TempFileName expect_f`;
	___ssu_iSetup4C_rc=$?;
	if [ $___ssu_iSetup4C_rc -ne 0 ]
	then
		echo "Cannot make a file in ${_ssu_WorkDir} !";
		exit 1;
	fi
	typeset ___ssu_iSetup4C_result_f=`_ssu_TempFileName result_f`;
	___ssu_iSetup4C_rc=$?;
	if [ $___ssu_iSetup4C_rc -ne 0 ]
	then
		echo "Cannot make a file in ${_ssu_WorkDir} !";
		exit 1;
	fi
	cp -p "${___ssu_iSetup4C_target}" "${___ssu_iSetup4C_backup}";
	___ssu_iSetup4C_rc=$?;
	if [ $___ssu_iSetup4C_rc -ne 0 ]
	then
		echo "Cannot BackUP ${___ssu_iSetup4C_target} !";
		exit 1;
	fi
	
	typeset ___ssu_iSetup4C_same=`${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilfilesame" "${___ssu_iSetup4C_target}" "${___ssu_iSetup4C_backup}"`
	if [ $___ssu_iSetup4C_same -eq 1 ]
	then
		echo "Cannot BackUP ${___ssu_iSetup4C_target} !";
		exit 1;
	fi
	
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar "${_ssu_UtilJar}" "${SSU_CHARCODE}" new "${___ssu_iSetup4C_backup}" "${___ssu_iSetup4C_result_f}" > "${___ssu_iSetup4C_target}" 2> "${___ssu_iSetup4C_expect_f}"
	___ssu_iSetup4C_rc=$?;
	if [ $___ssu_iSetup4C_rc -ne 0 ]
	then
		echo "Cannot Over Write To ${___ssu_iSetup4C_target}!";
		echo "Do you open ${___ssu_iSetup4C_target} ?";
		exit 1;
	fi
	
	typeset ___ssu_iSetup4C_ind=`echo ${#_ssu_CoverageBackups[*]}`
	_ssu_CoverageBackups[${___ssu_iSetup4C_ind}]="$___ssu_iSetup4C_backup"
	_ssu_CoverageResult_fs[${___ssu_iSetup4C_ind}]="$___ssu_iSetup4C_result_f"
	_ssu_CoverageExpect_fs[${___ssu_iSetup4C_ind}]="$___ssu_iSetup4C_expect_f"
	
	typeset ___ssu_iSetup4C_isCygwin=`uname |grep CYGWIN`;
	if [ ! -z ${___ssu_iSetup4C_isCygwin} ];then
		dos2unix "${___ssu_iSetup4C_target}" 2> /dev/null
		dos2unix "${___ssu_iSetup4C_result_f}" 2> /dev/null
	fi
}

_ssu_TearDownForCoverage(){
	typeset ___ssu_TearDownForCoverage_ind=`echo ${#_ssu_CoverageTargets[*]}`
	if [ ${___ssu_TearDownForCoverage_ind} -eq 0 ];then
		return 0
	fi
	___ssu_TearDownForCoverage_ind=0
	while [ ${___ssu_TearDownForCoverage_ind} -lt ${#_ssu_CoverageTargets[*]} ]
	do
		_ssu_iTearDown4C "${___ssu_TearDownForCoverage_ind}"
		___ssu_TearDownForCoverage_ind=$((${___ssu_TearDownForCoverage_ind}+1));
	done
	unset _ssu_CoverageTargets
	unset _ssu_CoverageBackups
	unset _ssu_CoverageResult_fs
	unset _ssu_CoverageExpect_fs
}
_ssu_iTearDown4C(){
	typeset ___ssu_iTearDown4C_ind=${1}
	typeset ___ssu_iTearDown4C_target=${_ssu_CoverageTargets[$___ssu_iTearDown4C_ind]}
	typeset ___ssu_iTearDown4C_backup=${_ssu_CoverageBackups[${___ssu_iTearDown4C_ind}]}
	typeset ___ssu_iTearDown4C_result_f=${_ssu_CoverageResult_fs[${___ssu_iTearDown4C_ind}]}
	typeset ___ssu_iTearDown4C_expect_f=${_ssu_CoverageExpect_fs[${___ssu_iTearDown4C_ind}]}
	
	{
		echo ""
		${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar "${_ssu_UtilJar}" "${SSU_CHARCODE}" analyze "${___ssu_iTearDown4C_expect_f}" "${___ssu_iTearDown4C_result_f}" "${___ssu_iTearDown4C_target}"
	} |tee -a "$_ssu_REPORT_FILE"
	if [ ! -f "${___ssu_iTearDown4C_backup}" ]
	then
		return 1;
	fi
	
	if [ -s "${___ssu_iTearDown4C_backup}" ]
	then
		cp -p "${___ssu_iTearDown4C_backup}" "${___ssu_iTearDown4C_target}" &
		typeset ___ssu_iTearDown4C_j=$!
		wait $___ssu_iTearDown4C_j;
	fi
	rm -f "${___ssu_iTearDown4C_backup}"
	rm -f "${___ssu_iTearDown4C_expect_f}";
	rm -f "${___ssu_iTearDown4C_result_f}";
}

#####################################################################################################
## below's are For Evidence.

_ssu_mkdir_evi(){
	typeset ___ssu_mkdir_evi_dname=$1;
	if [[ ! -d "${___ssu_mkdir_evi_dname}" ]]
	then
		mkdir -p "${___ssu_mkdir_evi_dname}"
		typeset ___ssu_mkdir_evi_r=$?;
		if [ $___ssu_mkdir_evi_r -ne 0 ]
		then
			echo "Cannot creake Dir!! ${___ssu_mkdir_evi_dname}"
			exit 1;
		fi
	fi
}

_ssu_mkdir_evi_test(){
	_ssu_evi_dir="${SSU_EVIDENCE_BASEDIR}/${_ssu_CurrentTestName}"
	_ssu_mkdir_evi "${_ssu_evi_dir}"
}

_ssu_SetupForEvidence(){
	typeset ___ssu_SetupForEvidence_evi_dir=${SSU_HOME}
	if [ "${SSU_EVIDENCE_BASEDIR}" != "" ]
	then
		___ssu_SetupForEvidence_evi_dir=${SSU_EVIDENCE_BASEDIR}
	fi

	typeset ___ssu_SetupForEvidence_dname="${___ssu_SetupForEvidence_evi_dir}/evidence"
	_ssu_mkdir_evi "${___ssu_SetupForEvidence_dname}"
	
	typeset ___ssu_SetupForEvidence_usr=`whoami`
	___ssu_SetupForEvidence_dname="${___ssu_SetupForEvidence_dname}/${___ssu_SetupForEvidence_usr}"
	_ssu_mkdir_evi "${___ssu_SetupForEvidence_dname}"
	
	typeset ___ssu_SetupForEvidence_f_t=`_ssu_LsFulltime "${_ssu_Lock}"`
	typeset ___ssu_SetupForEvidence_f_num=`_ssu_FromDateStyleToInt "${___ssu_SetupForEvidence_f_t}"`
	___ssu_SetupForEvidence_dname="${___ssu_SetupForEvidence_dname}/${___ssu_SetupForEvidence_f_num}"
	_ssu_mkdir_evi "${___ssu_SetupForEvidence_dname}"
	
	___ssu_SetupForEvidence_dname="${___ssu_SetupForEvidence_dname}/${_ssu_casename}"
	_ssu_mkdir_evi "${___ssu_SetupForEvidence_dname}"
	
	SSU_EVIDENCE_BASEDIR="${___ssu_SetupForEvidence_dname}"

}

_ssu_teardown_rmdir(){
	typeset ___ssu_teardown_rmdir_dd="$1";
	if [ -d "${___ssu_teardown_rmdir_dd}" ]
	then
		typeset ___ssu_teardown_rmdir_l=`ls ${___ssu_teardown_rmdir_dd} |wc -l`
		if [ $___ssu_teardown_rmdir_l = 0 ]
		then
			rm -fr "${___ssu_teardown_rmdir_dd}"
		fi
	fi
}

_ssu_TeardownForEvidence_test(){
	if [ -d "${_ssu_evi_dir}" ]
	then
		_ssu_teardown_rmdir "${_ssu_evi_dir}"
	fi
}
_ssu_TeardownForEvidence(){
	typeset ___ssu_TeardownForEvidence_d="${SSU_EVIDENCE_BASEDIR}"
	#casename
	_ssu_teardown_rmdir "${___ssu_TeardownForEvidence_d}"
	
	#time
	___ssu_TeardownForEvidence_d=`dirname "${___ssu_TeardownForEvidence_d}"`
	_ssu_teardown_rmdir "${___ssu_TeardownForEvidence_d}"
	
	#usr
	___ssu_TeardownForEvidence_d=`dirname "${___ssu_TeardownForEvidence_d}"`
	_ssu_teardown_rmdir "${___ssu_TeardownForEvidence_d}"
	
	#evi
	___ssu_TeardownForEvidence_d=`dirname "${___ssu_TeardownForEvidence_d}"`
	_ssu_teardown_rmdir "${___ssu_TeardownForEvidence_d}"
	
}

################################################################################
# test report
################################################################################
_ssu_report_setup(){
	_ssu_REPORT_FILE="${SSU_EVIDENCE_BASEDIR}"/"$_ssu_REPORT_FILE"
	typeset ___ssu_report_setup_date=`date`
	{
		echo "START :: $___ssu_report_setup_date"
		echo ""
		echo "TEST REPORT"
	} > "$_ssu_REPORT_FILE"
}
_ssu_report_teardown(){
	if [ "$SSU_REPORT" = "OFF" ];then
		rm "$_ssu_REPORT_FILE"
	else
		typeset ___ssu_report_teardown_date=`date`
		echo "END :: $___ssu_report_teardown_date" >> "$_ssu_REPORT_FILE"
	fi
}
################################################################################
# test bar
################################################################################

_ssu_RED="\033[41m\033[1;37m"
_ssu_GREEN="\033[42m\033[1;37m"
_ssu_CYAN="\033[46m\033[30m"
_ssu_BROWN="\033[43m\033[30m"
_ssu_END="\033[0m"
_ssu_LENG=75

if [[ -x /usr/bin/tput ]]; then
    (( _ssu_LENG = `tput cols` - 5))
fi

_ssu_display_bar(){
	if [ "$_ssu_suite_mode" = "on" ];then
		_ssu_bar_suite "$1" "$2" "$3"
	else
		_ssu_bar_test "$1" "$2" "$3" "$4"
	fi
}
_ssu_bar_test() {
    typeset ___ssu_bar_test_testname=$1
    typeset ___ssu_bar_test_cnt=$2
    typeset ___ssu_bar_test_max=$3
    typeset ___ssu_bar_test_color=$4
    typeset ___ssu_bar_test_pre=0
    typeset ___ssu_bar_test_post=0
    ((___ssu_bar_test_pre=___ssu_bar_test_cnt * _ssu_LENG / ___ssu_bar_test_max))
    ((___ssu_bar_test_post=___ssu_bar_test_pre + 1))

    typeset ___ssu_bar_test_sb=`printf "%-${_ssu_LENG}.${_ssu_LENG}s" " ${___ssu_bar_test_testname} (done: ${___ssu_bar_test_cnt}/${___ssu_bar_test_max}) "`

    typeset ___ssu_bar_test_p1=`expr substr "$___ssu_bar_test_sb" 1 $___ssu_bar_test_pre`
    typeset ___ssu_bar_test_p2=`expr substr "$___ssu_bar_test_sb" $___ssu_bar_test_post $_ssu_LENG`
    typeset ___ssu_bar_test_col=$_ssu_RED
    if [[ z$___ssu_bar_test_color = "zgreen" ]]; then
        ___ssu_bar_test_col=$_ssu_GREEN
    fi
    printf "\r${___ssu_bar_test_col}${___ssu_bar_test_p1}${_ssu_END}${_ssu_CYAN}${___ssu_bar_test_p2}${_ssu_END}" -e
}

_ssu_bar_suite() {
    typeset ___ssu_bar_suite_testname=$1
    typeset ___ssu_bar_suite_cnt=$2
    typeset ___ssu_bar_suite_max=$3
    typeset ___ssu_bar_suite_color=$_ssu_suite_color
    typeset ___ssu_bar_suite_suite_cnt=$_ssu_suite_test_cnt
    typeset ___ssu_bar_suite_suite_max=$_ssu_suite_test_max
    typeset ___ssu_bar_suite_d1=0
    ((___ssu_bar_suite_d1=___ssu_bar_suite_suite_cnt * _ssu_LENG / ___ssu_bar_suite_suite_max))
    
    typeset ___ssu_bar_suite_d3=0
    typeset ___ssu_bar_suite_i=0
    ((___ssu_bar_suite_i=___ssu_bar_suite_suite_cnt + 1))
    ((___ssu_bar_suite_d3=___ssu_bar_suite_i * _ssu_LENG/___ssu_bar_suite_suite_max))
    
    typeset ___ssu_bar_suite_d2=0
    ___ssu_bar_suite_i=0
    typeset ___ssu_bar_suite_j=0
    ((___ssu_bar_suite_i=___ssu_bar_suite_cnt * _ssu_LENG))
    ((___ssu_bar_suite_j=___ssu_bar_suite_suite_max * ___ssu_bar_suite_max))
    ((___ssu_bar_suite_d2=___ssu_bar_suite_i / ___ssu_bar_suite_j))
    ((___ssu_bar_suite_d2=___ssu_bar_suite_d1 + ___ssu_bar_suite_d2))
    if [ $___ssu_bar_suite_cnt -eq $___ssu_bar_suite_max ];then
    	___ssu_bar_suite_d2=$___ssu_bar_suite_d3
    fi
	
	typeset ___ssu_bar_suite_d2_next=0
	((___ssu_bar_suite_d2_next=___ssu_bar_suite_d2 + 1))
	typeset ___ssu_bar_suite_d3_next=0
	((___ssu_bar_suite_d3_next=___ssu_bar_suite_d3 + 1))
	
	typeset ___ssu_bar_suite_ii=0
	((___ssu_bar_suite_ii=___ssu_bar_suite_d3 - ___ssu_bar_suite_d2))
	
    ((___ssu_bar_suite_suite_cnt=___ssu_bar_suite_suite_cnt + 1))
    typeset ___ssu_bar_suite_sb=`printf "%-${_ssu_LENG}.${_ssu_LENG}s" " ${___ssu_bar_suite_testname}/$_ssu_casename (done: ${___ssu_bar_suite_cnt}/${___ssu_bar_suite_max}@${___ssu_bar_suite_suite_cnt}/${___ssu_bar_suite_suite_max}) "`

    typeset ___ssu_bar_suite_p1=`expr substr "$___ssu_bar_suite_sb" 1 $___ssu_bar_suite_d2`
    typeset ___ssu_bar_suite_p2=`expr substr "$___ssu_bar_suite_sb" $___ssu_bar_suite_d2_next $___ssu_bar_suite_ii`
    typeset ___ssu_bar_suite_p3=`expr substr "$___ssu_bar_suite_sb" $___ssu_bar_suite_d3_next $_ssu_LENG`
    
    typeset ___ssu_bar_suite_col=$_ssu_RED
    if [[ z$___ssu_bar_suite_color = "zgreen" ]]; then
        ___ssu_bar_suite_col=$_ssu_GREEN
    fi
    printf "\r${___ssu_bar_suite_col}${___ssu_bar_suite_p1}${_ssu_END}${_ssu_BROWN}${___ssu_bar_suite_p2}${_ssu_BROWN}${_ssu_CYAN}${___ssu_bar_suite_p3}${_ssu_END}" -e
}

################################################################################
# test suite
################################################################################
set_SUITE_DEBUG_MODE(){
	_ssu_SUITE_DEBUG_MODE="$1"
}
set_SUITE_REPORT(){
	_ssu_SUITE_REPORT="$1"
}

add_SSUTestCmd(){
	if [ $# -ne 1 ];then
		echo "Please give me yout testCmd."
		exit 1
	fi
	typeset __add_SSUTestCmd_cmd="$1"
	typeset __add_SSUTestCmd_name=`_ssu_find_shell_name $__add_SSUTestCmd_cmd`
	typeset __add_SSUTestCmd_ind=`echo ${#_ssu_suiteTestCmds[*]}`
	_ssu_suiteTestCmds[${__add_SSUTestCmd_ind}]="$__add_SSUTestCmd_cmd"
	_ssu_suiteTestShellNames[${__add_SSUTestCmd_ind}]="$__add_SSUTestCmd_name"
}

_ssu_find_shell_name(){
	typeset ___ssu_find_shell_name_v
	for ___ssu_find_shell_name_v in $*
	do
		if [ -f $___ssu_find_shell_name_v ];then
			typeset ___ssu_find_shell_name_c=`grep startSSU $___ssu_find_shell_name_v | grep -v -c startSSUSuite`
			if [ $___ssu_find_shell_name_c -ne 0 ];then
				basename $___ssu_find_shell_name_v
				return 0
			fi
		fi
	done
	echo "please give me shell name"
	exit 1
}

startSSUSuite(){
	export _ssu_suite_mode
	export _ssu_suite_color
	export _ssu_suite_test_cnt
	export _ssu_suite_test_max
	export _ssu_suite_testName
	export _ssu_SUITE_DEBUG_MODE
	export _ssu_SUITE_REPORT
	_ssu_suite_mode="on"
	_ssu_suite_inner_flag=on
	_ssu_suite_countOfSuccessTest=0
	_ssu_suite_countOfFailedTest=0
	_ssu_suite_test_cnt=0
	_ssu_suite_test_max=`echo ${#_ssu_suiteTestCmds[*]}`
	while [ ${_ssu_suite_test_cnt} -lt ${_ssu_suite_test_max} ]
	do
		typeset __startSSUSuite_CurrentTestCmd=${_ssu_suiteTestCmds[$_ssu_suite_test_cnt]};
		_ssu_suite_testName=${_ssu_suiteTestShellNames[$_ssu_suite_test_cnt]}
		$__startSSUSuite_CurrentTestCmd &
		typeset __startSSUSuite_suite_TestJobID=$!
		wait $__startSSUSuite_suite_TestJobID
		typeset __startSSUSuite_r=$?
		__startSSUSuite_suite_TestJobID=""
		if [ $__startSSUSuite_r -ne 0 ];then
			_ssu_suite_color="red"
			_ssu_suite_countOfFailedTest=$((${_ssu_suite_countOfFailedTest}+1))
		else
			_ssu_suite_countOfSuccessTest=$((${_ssu_suite_countOfSuccessTest}+1))
		fi
		_ssu_suite_test_cnt=$((${_ssu_suite_test_cnt}+1))
	done
	echo ""
}

_ssu_suite_SystemOut(){
	typeset ___ssu_suite_SystemOut_all=0
	((___ssu_suite_SystemOut_all=_ssu_suite_countOfSuccessTest + _ssu_suite_countOfFailedTest))
	if [[ ${_ssu_suite_test_max} -ne ${___ssu_suite_SystemOut_all} ]]
	then
		return 0;
	fi
	echo ""
	echo "** Result Of TestSuite ***********************";
	echo "Run TestCases:${_ssu_suite_test_max}";
	echo "Success TestCases:${_ssu_suite_countOfSuccessTest}";
	echo "Failure TestCases:${_ssu_suite_countOfFailedTest}";
	echo "*********************************************";
	_ssu_cnt=0
}


