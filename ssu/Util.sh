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

_ssu_util_old_to_new(){
	if [ "$JAVA_CMD" != "java" ];then
		SSU_JAVA_CMD="$JAVA_CMD"
	fi
	if [ "$JAVA_OPTION" != "" ];then
		SSU_JAVA_OPTION="$JAVA_OPTION"
	fi
	
	if [ "$JDBC_JAR" != "" ];then
		if [ $SSU_IS_CYGWIN -eq 1 ];then
			typeset ___ssu_util_old_to_new_v=`_ssu_to_abst "$JDBC_JAR"`
			SSU_JDBC_JAR="$SSU_CYGWIN_ROOT_PATH""$___ssu_util_old_to_new_v"
		else
			SSU_JDBC_JAR="$JDBC_JAR"
		fi
	fi
	if [ "$JDBC_CLASS" != "" ];then
		SSU_JDBC_CLASS="$JDBC_CLASS"
	fi
	if [ "$JDBC_URL" != "" ];then
		SSU_JDBC_URL="$JDBC_URL"
	fi
	if [ "$JDBC_USER" != "" ];then
		SSU_JDBC_USER="$JDBC_USER"
	fi
	if [ "$JDBC_PASSWORD" != "" ];then
		SSU_JDBC_PASSWORD="$JDBC_PASSWORD"
	fi
}
################################################################################
#String
################################################################################
# u_str_capitalize
# capitalizing string
# ex) abc -> Abc , XYZ -> Xyz
# $1 string
################################################################################
u_str_capitalize(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_capitalize";
		return 1;
	fi
	typeset __u_str_capitalize_str=${1}
	typeset __u_str_capitalize_num=`echo ${#__u_str_capitalize_str}`
	__u_str_capitalize_str=`echo ${__u_str_capitalize_str} | tr [:upper:] [:lower:]`
	typeset __u_str_capitalize_c=`echo ${__u_str_capitalize_str}|cut -c 1`
	__u_str_capitalize_c=`echo ${__u_str_capitalize_c} | tr [:lower:] [:upper:]`
	typeset __u_str_capitalize_other=`echo ${__u_str_capitalize_str}|cut -c 2-${__u_str_capitalize_num}`
	echo ${__u_str_capitalize_c}${__u_str_capitalize_other}
}

################################################################################
# u_str_chop
# last char delete. if last char is [\r,\n],this function also delets these chars.
# ex) abc -> ab
# $1 string
################################################################################
u_str_chop(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_chop";
		return 1;
	fi
	typeset __u_str_chop_str=`echo "${1}"`
	typeset __u_str_chop_num=`echo ${#__u_str_chop_str}`
	if [[ ${__u_str_chop_num} -eq 0 ]];then
		echo "";
		return 0;
	fi
	__u_str_chop_num=$((${__u_str_chop_num} - 1))
	typeset __u_str_chop_other=`echo "${__u_str_chop_str}"|cut -c 1-${__u_str_chop_num}`
	echo "${__u_str_chop_other}"
}

################################################################################
# u_str_delete
# slike tr
# $1 string
# $2 delete string
################################################################################
u_str_delete(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_delete";
		return 1;
	fi
	typeset __u_str_delete_str=`echo "${1}" | tr -d "${2}"`
	echo "${__u_str_delete_str}"
}

################################################################################
# u_str_downcase
# to downcase
# $1 string
################################################################################
u_str_downcase(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_downcase";
		return 1;
	fi
	typeset __u_str_downcase_str=`echo "${1}" | tr [:upper:] [:lower:]`
	echo "${__u_str_downcase_str}"
}

################################################################################
# u_str_isEmpty
# empty check
# true -> return 0
# false -> return 1
# $1 string
################################################################################
u_str_isEmpty(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_isEmpty";
		return 1;
	fi
	if [ -z "${1}" ]
	then
		echo 0;
	else
		echo 1;
	fi
}

################################################################################
# u_str_gsub
# replace
# $1 string
# $2 pattern
# $3 replace
################################################################################
u_str_gsub(){
	if [[ $# != 3 ]]
	then
		_ssu_util_ExitLog "u_str_gsub";
		return 1;
	fi
	typeset __u_str_gsub_str="${1}";
	typeset __u_str_gsub_pattern="${2}";
	typeset __u_str_gsub_replace="${3}";
	typeset __u_str_gsub_new_str="";
	if [ -z "${__u_str_gsub_replace}" ]
	then
		__u_str_gsub_new_str=`echo "${__u_str_gsub_str}" | tr -d "${__u_str_gsub_pattern}"`
	else
		__u_str_gsub_new_str=`echo "${__u_str_gsub_str}" | tr "${__u_str_gsub_pattern}" "${__u_str_gsub_replace}"`
	fi
	echo "${__u_str_gsub_new_str}"
}

################################################################################
# u_str_isInclude
# string contains other check
# true -> 0
# false -> 1
# $1 string
# $2 other
################################################################################
u_str_isInclude(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_isInclude";
		return 1;
	fi
	typeset __u_str_isInclude_str="${1}";
	typeset __u_str_isInclude_other="${2}";
	echo "${__u_str_isInclude_str}" | grep "${__u_str_isInclude_other}" > /dev/null 2>&1
	if [[ $? -eq 0 ]]
	then
		echo 0;
	else
		echo 1;
	fi
}

################################################################################
# u_str_index
# index of other in string
# u_str_index abcd bc  #-> 1
# u_str_index abcd bcx  #-> -1
# $1 string
# $2 other
################################################################################
u_str_index(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_index";
		return 1;
	fi
	typeset __u_str_index_str="${1}";
	typeset __u_str_index_str_num=${#__u_str_index_str}
	typeset __u_str_index_other="${2}";
	typeset __u_str_index_other_num=${#__u_str_index_other}

	if [[ ${__u_str_index_other_num} -gt ${__u_str_index_str_num} ]]
	then
		echo "-1"
		return 0;
	fi
	typeset __u_str_index_max=$((${__u_str_index_str_num} - ${__u_str_index_other_num}))
	typeset __u_str_index_i=0;
	typeset __u_str_index_j=0;
	typeset __u_str_index_s="";
	while [ ${__u_str_index_i} -le ${__u_str_index_max} ]
	do
		__u_str_index_j=$((${__u_str_index_i}+${__u_str_index_other_num}))
		__u_str_index_i=$((${__u_str_index_i}+1))
		__u_str_index_s=`echo "${__u_str_index_str}" |cut -c ${__u_str_index_i}-${__u_str_index_j}`
		if [ "${__u_str_index_s}" = "${__u_str_index_other}" ]
		then
			__u_str_index_i=$((${__u_str_index_i}-1))
			echo ${__u_str_index_i}
			return 0;
		fi
	done
	echo -1
}

################################################################################
# u_str_insert
# insert other into string
# ex: u_str_insert foobaz 3 bar #-> foobarbaz
# $1 string
# $2 index
# $3 other
################################################################################
u_str_insert(){
	if [[ $# != 3 ]]
	then
		_ssu_util_ExitLog "u_str_insert";
		return 1;
	fi
	typeset __u_str_insert_str="${1}"
	typeset __u_str_insert_index=${2}
	typeset __u_str_insert_other="${3}"
	typeset __u_str_insert_size=${#__u_str_insert_str}
	if [[ ${__u_str_insert_index} -lt 0 ]]
	then
		echo "index must be over 0"
		return 1;
	elif [[ ${__u_str_insert_index} -gt ${__u_str_insert_size} ]]
	then
		echo "index out of string"
		return 1;
	fi
	if [[ ${__u_str_insert_index} -eq ${__u_str_insert_size} ]]
	then
		echo "${__u_str_insert_str}""${__u_str_insert_other}"
		return 0;
	elif [[ ${__u_str_insert_index} -eq 0 ]]
	then
		echo "${__u_str_insert_other}""${__u_str_insert_str}"
		return 0;
	fi
	typeset __u_str_insert_pre=`echo "${__u_str_insert_str}" |cut -c 1-${__u_str_insert_index}`
	__u_str_insert_index=$((${__u_str_insert_index}+1))
	typeset __u_str_insert_post=`echo "${__u_str_insert_str}" | cut -c ${__u_str_insert_index}-${__u_str_insert_size}`
	echo "${__u_str_insert_pre}""${__u_str_insert_other}""${__u_str_insert_post}"
}

################################################################################
# u_str_reverse
# reverse string
# $1 string
################################################################################
u_str_reverse(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_reverse";
		return 1;
	fi
	typeset __u_str_reverse_str=`echo "${1}"`
	typeset __u_str_reverse_size=${#__u_str_reverse_str}
	if [[ ${__u_str_reverse_size} -eq 0 || ${__u_str_reverse_size} -eq 1 ]]
	then
		echo "${__u_str_reverse_str}"
		return 0;
	fi
	typeset __u_str_reverse_i=${__u_str_reverse_size}
	typeset __u_str_reverse_s=""
	typeset __u_str_reverse_new_str=""
	while [ ${__u_str_reverse_i} -gt 0 ]
	do
		__u_str_reverse_s=`echo ${__u_str_reverse_str} | cut -c ${__u_str_reverse_i}`
		__u_str_reverse_new_str="${__u_str_reverse_new_str}""${__u_str_reverse_s}"
		__u_str_reverse_i=$((${__u_str_reverse_i}-1))
	done
	echo "${__u_str_reverse_new_str}"
}

################################################################################
# u_str_size
# size of string
# $1 string
################################################################################
u_str_size(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_size";
		return 1;
	fi
	typeset __u_str_size_str=`echo "${1}"`
	echo ${#__u_str_size_str}
}

################################################################################
# u_str_split
# separate of string and return index-th str
# u_str_split "abc 123" 1 #-> 123
# $1 string
# $2 index
################################################################################
u_str_split(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_split";
		return 1;
	fi
	typeset __u_str_split_str="${1}"
	typeset __u_str_split_max=${#__u_str_split_str}
	typeset __u_str_split_index=${2}
	__u_str_split_index=$((${__u_str_split_index}+1))
	typeset __u_str_split_i=1
	typeset __u_str_split_inner_index=1
	typeset __u_str_split_s="";
	while [ ${__u_str_split_inner_index} -le ${__u_str_split_index} ]
	do
		__u_str_split_s=`echo "${__u_str_split_str}" | cut -d " " -f ${__u_str_split_i}`
		if [[ ! -z "${__u_str_split_s}" ]]
		then
			__u_str_split_inner_index=$((${__u_str_split_inner_index}+1))
		fi
		__u_str_split_i=$((${__u_str_split_i}+1))
		if [[ ${__u_str_split_i} -gt ${__u_str_split_max} ]]
		then
			echo "index is out of string range";
			return 1;
		fi
	done
	echo "${__u_str_split_s}"
}

################################################################################
# u_str_upcase
# to upcase
# $1 string
################################################################################
u_str_upcase(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_upcase";
		return 1;
	fi
	typeset __u_str_upcase_str=`echo "${1}" | tr [:lower:] [:upper:]`
	echo "${__u_str_upcase_str}"
}

################################################################################
# u_str_toFilePermissionNumber
# ex: u_str_toFilePermissionNumber "rw-" #-> 6
# ex: u_str_toFilePermissionNumber "rw-r--r--" #-> 644
# $1 string
################################################################################
u_str_toFilePermissionNumber(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_toFilePermissionNumber";
		return 1;
	fi
	typeset __u_str_toFilePermissionNumber_str="${1}"
	typeset __u_str_toFilePermissionNumber_number=""
	typeset __u_str_toFilePermissionNumber_s="";
	typeset __u_str_toFilePermissionNumber_istart=1
	typeset __u_str_toFilePermissionNumber_iend=0
	typeset __u_str_toFilePermissionNumber_i="";
	if [[ ${#__u_str_toFilePermissionNumber_str} -gt 9 ]]
	then
		_ssu_util_ExitLog "u_str_toFilePermissionNumber";
		return 1;
	fi
	while [ ${__u_str_toFilePermissionNumber_istart} -lt 8 ]
	do
		__u_str_toFilePermissionNumber_iend=$((${__u_str_toFilePermissionNumber_istart}+2))
		__u_str_toFilePermissionNumber_s=`echo "${__u_str_toFilePermissionNumber_str}" | cut -c ${__u_str_toFilePermissionNumber_istart}-${__u_str_toFilePermissionNumber_iend}`
		if [ ! -z "${__u_str_toFilePermissionNumber_s}" ]
		then
			__u_str_toFilePermissionNumber_i=`u_str_toFilePermissionNumber_inner "${__u_str_toFilePermissionNumber_s}"`
			if [[ $? -ne 0 ]]
			then
				_ssu_util_ExitLog "u_str_toFilePermissionNumber";
				return 1;
			fi
			__u_str_toFilePermissionNumber_number="${__u_str_toFilePermissionNumber_number}""${__u_str_toFilePermissionNumber_i}"
		fi
		__u_str_toFilePermissionNumber_istart=$((${__u_str_toFilePermissionNumber_istart}+3))
	done
	echo ${__u_str_toFilePermissionNumber_number}
}
u_str_toFilePermissionNumber_inner(){
	typeset __u_str_toFilePermissionNumber_inner_i=0;
	typeset __u_str_toFilePermissionNumber_inner_t=`echo ${1} | cut -c 1`
	if [ ${__u_str_toFilePermissionNumber_inner_t} = "r" ];then
		__u_str_toFilePermissionNumber_inner_i=$((${__u_str_toFilePermissionNumber_inner_i}+4))
	elif [ ${__u_str_toFilePermissionNumber_inner_t} != "-" ]
	then
		return 1;
	fi
	__u_str_toFilePermissionNumber_inner_t=`echo ${1} | cut -c 2`
	if [ ${__u_str_toFilePermissionNumber_inner_t} = "w" ];then
		__u_str_toFilePermissionNumber_inner_i=$((${__u_str_toFilePermissionNumber_inner_i}+2))
	elif [ ${__u_str_toFilePermissionNumber_inner_t} != "-" ]
	then
		return 1;
	fi
	__u_str_toFilePermissionNumber_inner_t=`echo ${1} | cut -c 3`
	if [ ${__u_str_toFilePermissionNumber_inner_t} = "x" ];then
		__u_str_toFilePermissionNumber_inner_i=$((${__u_str_toFilePermissionNumber_inner_i}+1))
	elif [ ${__u_str_toFilePermissionNumber_inner_t} != "-" ]
	then
		return 1;
	fi
	echo ${__u_str_toFilePermissionNumber_inner_i}
}


################################################################################
#NUMBER
################################################################################
# u_num_toFilePermission
# ex: u_num_toFilePermission 6 #-> "rw-"
# ex: u_num_toFilePermission 644 #-> "rw-r--r--"
# $1 string
################################################################################
u_num_toFilePermission(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_num_toFilePermission";
		return 1;
	fi
	
	typeset __u_num_toFilePermission_number="${1}"
	typeset __u_num_toFilePermission_str=""
	typeset __u_num_toFilePermission_s="";
	typeset __u_num_toFilePermission_istart=1
	typeset __u_num_toFilePermission_i="";
	if [[ ${#__u_num_toFilePermission_number} -gt 3 ]]
	then
		_ssu_util_ExitLog "u_num_toFilePermission";
		return 1;
	fi
	while [ ${__u_num_toFilePermission_istart} -lt 4 ]
	do
		__u_num_toFilePermission_s=`echo "${__u_num_toFilePermission_number}" | cut -c ${__u_num_toFilePermission_istart}`
		if [ ! -z "${__u_num_toFilePermission_s}" ]
		then
			__u_num_toFilePermission_i=`u_num_toFilePermission_inner "${__u_num_toFilePermission_s}"`
			if [[ $? -ne 0 ]]
			then
				_ssu_util_ExitLog "u_num_toFilePermission";
				return 1;
			fi
			__u_num_toFilePermission_str="${__u_num_toFilePermission_str}""${__u_num_toFilePermission_i}"
		fi
		__u_num_toFilePermission_istart=$((${__u_num_toFilePermission_istart}+1))
	done
	echo ${__u_num_toFilePermission_str}
}
u_num_toFilePermission_inner(){
	typeset __u_num_toFilePermission_inner_i=${1}
	if [ ${__u_num_toFilePermission_inner_i} -eq 7 ];then
		echo "rwx"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 6 ];then
		echo "rw-"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 5 ];then
		echo "r-x"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 4 ];then
		echo "r--"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 3 ];then
		echo "-wx"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 2 ];then
		echo "-w-"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 1 ];then
		echo "--x"
	elif [ ${__u_num_toFilePermission_inner_i} -eq 0 ];then
		echo "---"
	else
		return 1;
	fi
}

################################################################################
#File
################################################################################
# u_f_isFile
# is file check
# true -> 0
# false -> 1
# $1 file path
################################################################################
u_f_isFile(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_isFile";
		return 1;
	fi
	typeset __u_f_isFile_file="${1}"
	if [[ -f "${__u_f_isFile_file}" || -L "${__u_f_isFile_file}" ]]
	then
		echo 0;
		return 0;
	fi
	echo 1;
}

################################################################################
# u_f_isDir
# is dir check
# true -> 0
# false -> 1
# $1 file path
################################################################################
u_f_isDir(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_isDir";
		return 1;
	fi
	typeset __u_f_isDir_dir="${1}"
	if [[ -d "${__u_f_isDir_dir}" ]]
	then
		echo 0;
		return 0;
	fi
	echo 1;
}

################################################################################
# u_f_getPermission
# $1 file path
################################################################################
u_f_getPermission(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getPermission";
		return 1;
	fi
	typeset __u_f_getPermission_file="${1}"
	if [[ ! -f "${__u_f_getPermission_file}" && ! -d "${__u_f_getPermission_file}" && ! -L "${__u_f_getPermission_file}" ]]
	then
		echo "cannot find ${__u_f_getPermission_file}";
		return 1;
	fi
	typeset __u_f_getPermission_perm=`ls -ld "${__u_f_getPermission_file}" | cut -d " " -f 1 |cut -c 2-10`
	echo ${__u_f_getPermission_perm}
}

################################################################################
# u_f_getSize
# $1 file path
################################################################################
u_f_getSize(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getSize";
		return 1;
	fi
	typeset __u_f_getSize_file="${1}"
	if [[ ! -f "${__u_f_getSize_file}" && ! -d "${__u_f_getSize_file}" && ! -L "${__u_f_getSize_file}" ]]
	then
		echo "cannot find ${__u_f_getSize_file}";
		return 1;
	fi
	typeset __u_f_getSize_status=`ls -lod "${__u_f_getSize_file}"`
	typeset __u_f_getSize_size=`u_str_split "${__u_f_getSize_status}" 3`
	echo ${__u_f_getSize_size}
}


################################################################################
# u_f_getUser
# $1 file path
################################################################################
u_f_getUser(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getUser";
		return 1;
	fi
	typeset __u_f_getUser_file="${1}"
	if [[ ! -f "${__u_f_getUser_file}" && ! -d "${__u_f_getUser_file}" && ! -L "${__u_f_getUser_file}" ]]
	then
		echo "cannot find ${__u_f_getUser_file}";
		return 1;
	fi
	typeset __u_f_getUser_status=`ls -lod "${__u_f_getUser_file}"`
	typeset __u_f_getUser_u=`u_str_split "${__u_f_getUser_status}" 2`
	echo ${__u_f_getUser_u}
}

################################################################################
# u_f_getGroup
# $1 file path
################################################################################
u_f_getGroup(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getGroup";
		return 1;
	fi
	typeset __u_f_getGroup_file="${1}"
	if [[ ! -f "${__u_f_getGroup_file}" && ! -d "${__u_f_getGroup_file}" && ! -L "${__u_f_getGroup_file}" ]]
	then
		echo "cannot find ${__u_f_getGroup_file}";
		return 1;
	fi
	typeset __u_f_getGroup_status=`ls -ld "${__u_f_getGroup_file}"`
	typeset __u_f_getGroup_g=`u_str_split "${__u_f_getGroup_status}" 3`
	echo ${__u_f_getGroup_g}
}

################################################################################
# u_f_getOwn
# $1 file path
################################################################################
u_f_getOwn(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getOwn";
		return 1;
	fi
	typeset __u_f_getOwn_file="${1}"
	if [[ ! -f "${__u_f_getOwn_file}" && ! -d "${__u_f_getOwn_file}" && ! -L "${__u_f_getOwn_file}" ]]
	then
		echo "cannot find ${__u_f_getOwn_file}";
		return 1;
	fi
	typeset __u_f_getOwn_status=`ls -ld "${__u_f_getOwn_file}"`
	typeset __u_f_getOwn_u=`u_str_split "${__u_f_getOwn_status}" 2`
	typeset __u_f_getOwn_g=`u_str_split "${__u_f_getOwn_status}" 3`
	echo "${__u_f_getOwn_u}"."${__u_f_getOwn_g}"
}

################################################################################
# u_f_getTimestamp
# $1 file path
################################################################################
u_f_getTimestamp(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getTimestamp";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_f_getTimestamp_file="${1}"
	if [[ ! -f "${__u_f_getTimestamp_file}" && ! -d "${__u_f_getTimestamp_file}" && ! -L "${__u_f_getTimestamp_file}" ]]
	then
		echo "cannot find ${__u_f_getTimestamp_file}";
		return 1;
	fi
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "util" "file-time" "${__u_f_getTimestamp_file}"
}

################################################################################
# u_db_insert
# $1 inout file
# $2 table
# $3 where-condition (option)
################################################################################
u_db_insert(){
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_util_ExitLog "u_db_insert";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_db_insert_file="${1}";
	typeset __u_db_insert_table="${2}";
	typeset __u_db_insert_where=" ";
	if [ $# = 3 ]
	then
		__u_db_insert_where="${3}";
	fi
	
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "insert" "${__u_db_insert_file}" "${__u_db_insert_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__u_db_insert_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_db_insert_r=$?
	if [ $__u_db_insert_r -ne 0 ]
	then
		echo "u_db_insert error!! ${__u_db_insert_table} ${__u_db_insert_file}"
		return $__u_db_insert_r
	fi
}

################################################################################
# u_db_delete
# $1 table
# $3 where-condition (option)
################################################################################
u_db_delete(){
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_db_delete";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_db_delete_table="${1}";
	typeset __u_db_delete_where=" ";
	if [ $# = 2 ]
	then
		__u_db_delete_where="${2}";
	fi
	
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "delete" ".." "${__u_db_delete_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__u_db_delete_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_db_delete_r=$?
	if [ $__u_db_delete_r -ne 0 ]
	then
		echo "u_db_delete error!! ${__u_db_delete_table}"
		return $__u_db_delete_r
	fi
}

################################################################################
# u_db_select_to
# $1 inout file
# $2 table
# $3 where-condition (option)
################################################################################
u_db_select_to(){
if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_util_ExitLog "u_db_select_to";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_db_select_to_file="${1}";
	typeset __u_db_select_to_table="${2}";
	typeset __u_db_select_to_where=" ";
	if [ $# = 3 ]
	then
		__u_db_select_to_where="${3}";
	fi
	
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectto" "${__u_db_select_to_file}" "${__u_db_select_to_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__u_db_select_to_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_db_select_to_r=$?
	if [ $__u_db_select_to_r -ne 0 ]
	then
		echo "u_db_select_to error!! ${__u_db_select_to_table} ${__u_db_select_to_file}"
		return $__u_db_select_to_r
	fi
}


################################################################################
# u_db_select
# $1 table
# $2 where-condition (option)
################################################################################
u_db_select(){
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_db_select";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_db_select_table="${1}";
	typeset __u_db_select_where=" ";
	if [ $# = 2 ]
	then
		__u_db_select_where="${2}";
	fi
	
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectout" ".." "${__u_db_select_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__u_db_select_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_db_select_r=$?
	if [ $__u_db_select_r -ne 0 ]
	then
		echo "u_db_select error!! ${__u_db_select_table}"
		return $__u_db_select_r
	fi
}

################################################################################
# u_db_sql_query
# $1 file-path
################################################################################
u_db_sql_query(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_db_sql_query";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_db_sql_query_file="${1}";
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "query" "$__u_db_sql_query_file" ".." "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" " " ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_db_sql_query_r=$?
	if [ $__u_db_sql_query_r -ne 0 ]
	then
		echo "u_db_sql_query error!! ${__u_db_sql_query_file}"
		return $__u_db_sql_query_r
	fi
}

################################################################################
# u_db_sql_exec
# $1 file-path
################################################################################
u_db_sql_exec(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_db_sql_exec";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_db_sql_exec_file="${1}";
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "exec" "$__u_db_sql_exec_file" ".." "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" " " ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_db_sql_exec_r=$?
	if [ $__u_db_sql_exec_r -ne 0 ]
	then
		echo "u_db_sql_exec error!! ${__u_db_sql_exec_file}"
		return $__u_db_sql_exec_r
	fi
}


################################################################################
# u_evi_db
# $1 table
# $2 evi-filename (option)
################################################################################
u_evi_db(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_evi_db";
		return 1;
	fi
	_ssu_util_old_to_new
	typeset __u_evi_db_table="${1}";
	typeset __u_evi_db_name="${__u_evi_db_table}";
	if [ $# = 2 ]
	then
		__u_evi_db_name="${2}";
	fi
	__u_evi_db_name=`basename "${__u_evi_db_name}"`
	
	typeset __u_evi_db_file=`_ssu_util_evi_FileName "${__u_evi_db_name}"`
	
	typeset __u_evi_db_where=" ";
	${SSU_JAVA_CMD} $SSU_JAVA_OPTION -cp "${SSU_JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBMain "${SSU_CHARCODE}" "db" "selectto" "${__u_evi_db_file}" "${__u_evi_db_table}" "${SSU_JDBC_CLASS}" "${SSU_JDBC_URL}" "${__u_evi_db_where}" ${SSU_JDBC_USER} ${SSU_JDBC_PASSWORD}
	typeset __u_evi_db_r=$?
	if [ $__u_evi_db_r -ne 0 ]
	then
		echo "u_evi_db error!! ${__u_evi_db_table} ${__u_evi_db_file}"
		return $__u_evi_db_r
	fi
}

################################################################################
# u_evi_file
# $1 filename
# $2 evi-filename (option)
################################################################################
u_evi_file(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_evi_file";
		return 1;
	fi
	typeset __u_evi_file_moto="${1}";
	typeset __u_evi_file_name=`basename "${__u_evi_file_moto}"`
	if [ $# = 2 ]
	then
		__u_evi_file_name="${2}";
	fi
	__u_evi_file_name=`basename "${__u_evi_file_name}"`
	
	typeset __u_evi_file_file=`_ssu_util_evi_FileName "${__u_evi_file_name}"`
	cp -pf "${__u_evi_file_moto}" "${__u_evi_file_file}"
	typeset __u_evi_file_r=$?
	if [ $__u_evi_file_r -ne 0 ]
	then
		echo "u_evi_file error!! ${__u_evi_file_moto} ${__u_evi_file_file}"
		return $__u_evi_file_r
	fi
}

################################################################################
# u_evi_dir
# $1 dir-name
# $2 evi-dir-name (option)
################################################################################
u_evi_dir(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_evi_file";
		return 1;
	fi
	typeset __u_evi_dir_moto="${1}";
	typeset __u_evi_dir_name=`basename "${__u_evi_dir_moto}"`
	if [ $# = 2 ]
	then
		__u_evi_dir_name="${2}";
	fi
	__u_evi_dir_name=`basename "${__u_evi_dir_name}"`
	
	typeset __u_evi_dir_dir=`_ssu_util_evi_FileName "${__u_evi_dir_name}"`
	rm ${__u_evi_dir_dir}
	mkdir ${__u_evi_dir_dir}
	typeset __u_evi_dir_r=$?
	if [ $__u_evi_dir_r -ne 0 ]
	then
		echo "u_evi_dir error!!:cannot create dir: ${__u_evi_dir_moto} ${__u_evi_dir_dir}"
		return $__u_evi_dir_r
	fi
	
	cp -pfr "${__u_evi_dir_moto}" "${__u_evi_dir_dir}"
	__u_evi_dir_r=$?
	if [ $__u_evi_dir_r -ne 0 ]
	then
		echo "u_evi_dir error!! ${__u_evi_dir_moto} ${__u_evi_dir_dir}"
		return $__u_evi_dir_r
	fi
}


################################################################################
_ssu_util_ExitLog(){
	echo ${1}" Wrong Arguments!";
	if [[ $# == 2 ]]
	then
		echo "${2}";
	fi
	
}

_ssu_util_evi_FileName(){
	typeset ___ssu_util_evi_FileName_name=`basename $1`
	typeset ___ssu_util_evi_FileName_tempName=${___ssu_util_evi_FileName_name}"_"
	typeset ___ssu_util_evi_FileName_i=1
	while [[ -a ${_ssu_evi_dir}/"${___ssu_util_evi_FileName_tempName}${___ssu_util_evi_FileName_i}.log" ]] 
	do
		___ssu_util_evi_FileName_i=$((${___ssu_util_evi_FileName_i}+1))
	done
	touch ${_ssu_evi_dir}/"${___ssu_util_evi_FileName_tempName}${___ssu_util_evi_FileName_i}.log"
	echo ${_ssu_evi_dir}/"${___ssu_util_evi_FileName_tempName}${___ssu_util_evi_FileName_i}.log"
}
