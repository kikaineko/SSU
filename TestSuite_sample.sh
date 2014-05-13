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
# TestSuite.sh : ShellScript Unit, enables Jenkins integration
#
# author : H.SANO
################################################################################
################################################################################
## You MUST Define "SSU_HOME" in your test_case.
## SSU_HOME is relative path-name from your test_case to SSU.
## like SSU_HOME="../test" (/home/foo/test/SSU.sh , /home/foo/testcase/test.sh)
################################################################################
#### this script will execute all the test shells under $SSU_TEST_SUITE_HOME.
################################################################################
#    this script should exist under the git or other SCM repository
#    that can be accessed from Jenkins
#    this script will give JUnit format report within the Jenkins work directory
#    ($SUITE_REPORT)
#    so Jenkins job should execute this script and then as a post-build script
#    it should see the $SUITE_REPORT as JUnit result calc.
################################################################################
################################################################################
################################################################################
#    Configuration values to set 
#    1. SSU_TEST_SUITE_HOME, where you place all your SSU-based test shells.
#    2. SSU_HOME (full path)
#    3. SUITE_REPORT filename from which Jenkins compiles the tes result
#       it should be consistent with your Jenkins setting
################################################################################

SSU_TEST_SUITE_HOME="/usr/local/my/testcase"
SSU_HOME="/usr/local/my/ssu"
SUITE_REPORT=${this_shell_dir}/myreport.xml

##### config section end #######################################################

this_shell_dir=`pwd`
echo "<testsuite>">${SUITE_REPORT}
#loop for every shell under suite home
for __ssu_testcase_sh in ${SSU_TEST_SUITE_HOME}/*.sh
do
	__ssu_testcase_sh_base=`basename ${__ssu_testcase_sh}`
   #########################################################################
   ####execute the test shell.
   #########################################################################
   cd ${SSU_TEST_SUITE_HOME} 
   sh ${__ssu_testcase_sh_base}>${this_shell_dir}/__suite_result_tmpfile 2>&1
   #########################################################################
   ####compile the report in JUnit format.
   #########################################################################
    __ssu_report=${SSU_HOME}/evidence/`whoami`/${__ssu_testcase_sh_base}/report.txt
	if [ -e ${__ssu_report} ]; then
        grep _s_s_u_ ${__ssu_report} | while read __ssu_prefix __ssu_testname __ssu_arrow __ssu_result
        do
            if [ "${__ssu_result}" == "OK!" ]; then
                echo "<testcase classname='${__ssu_testcase_sh_base}' name='${__ssu_testname}' />">>${SUITE_REPORT}
            else
                echo "<testcase classname='${__ssu_testcase_sh_base}' name='${__ssu_testname}' ><failure><![CDATA[`cat ${this_shell_dir}/__suite_result_tmpfile`]]></failure></testcase>">>${SUITE_REPORT}
            fi
        done
    fi
done

echo "</testsuite>">>${SUITE_REPORT}

