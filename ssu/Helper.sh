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
## below's are helper functions
################################################################################

_ssu_tearDown_h(){
	typeset ___ssu_tearDown_h_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	while [ ${___ssu_tearDown_h_ind} -ge 1 ]
	do
		___ssu_tearDown_h_ind=$((${___ssu_tearDown_h_ind}-1))
		${_ssu_tearDown_h_calledFunctions[$___ssu_tearDown_h_ind]}
	done
	unset _ssu_tearDown_h_calledFunctions
}

################################################################################
# mv helper
# $1 src (1 file only)
# $2 dest (1 file only)
# $3 options (like "-i" )
################################################################################
h_mv(){
	typeset __h_mv_src=""
	typeset __h_mv_dest=""
	typeset __h_mv_op=""
	if [[ $# -eq 2 || $# -eq 3 ]];then
		__h_mv_src=`_ssu_to_abst "${1}"`
		__h_mv_dest="${2}"
		__h_mv_op=""
		if [ $# = 3 ]
		then
			__h_mv_op="${3}";
		fi
	else
		_ssu_ErrExit "h_mv"
	fi
	
	if [ ! -f ${__h_mv_src} ];then
		_ssu_ErrExit "h_mv" "not found file ${__h_mv_src}"
	fi
	
	typeset __h_mv_temp_src=`_ssu_TempFileName "${__h_mv_src}"`;
	cp -p  "${__h_mv_src}" "${__h_mv_temp_src}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_mv: Fail! No Space?"
	fi
	
	typeset __h_mv_temp_dest=""
	if [ -f ${__h_mv_dest} ];then
		__h_mv_dest=`_ssu_to_abst "$__h_mv_dest"`
		__h_mv_temp_dest=`_ssu_TempFileName "${__h_mv_dest}"`;
		cp -p  "${__h_mv_dest}" "${__h_mv_temp_dest}"
		if [ $? -ne 0 ];then
			rm -f "${__h_mv_temp_src}"
			_ssu_ErrExit2 "h_mv: Fail! No Space?"
		fi
	fi
	
	typeset __h_mv_command="mv ${__h_mv_op} ${__h_mv_src} ${__h_mv_dest}"
	${__h_mv_command}
	typeset __h_mv_rc=$?
	if [ $__h_mv_rc -ne 0 ]
	then
		_ssu_ErrExit2 "h_mv: Fail! No Space?"
	fi
	
	__h_mv_dest=`_ssu_to_abst "$__h_mv_dest"`
	
	typeset __h_mv_ind=`echo ${#_ssu_h_mv_src[@]}`
	_ssu_h_mv_src[${__h_mv_ind}]="${__h_mv_src}"
	_ssu_h_mv_dest[${__h_mv_ind}]="${__h_mv_dest}"
	_ssu_h_mv_backup_src[${__h_mv_ind}]="${__h_mv_temp_src}"
	_ssu_h_mv_backup_dest[${__h_mv_ind}]="${__h_mv_temp_dest}"
	
	__h_mv_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_mv_ind}]="_ssu_tearDown_h_mv"
}

_ssu_tearDown_h_mv(){
	typeset ___ssu_tearDown_h_mv_ind=`echo ${#_ssu_h_mv_src[@]}`
	___ssu_tearDown_h_mv_ind=$((${___ssu_tearDown_h_mv_ind}-1))
	cp -p "${_ssu_h_mv_backup_src[${___ssu_tearDown_h_mv_ind}]}" "${_ssu_h_mv_src[${___ssu_tearDown_h_mv_ind}]}"
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_mv: Fail! No Space?"
		exit 1
	fi
	rm -f "${_ssu_h_mv_backup_src[${___ssu_tearDown_h_mv_ind}]}"
	if [[ "${_ssu_h_mv_backup_dest[${___ssu_tearDown_h_mv_ind}]}" != "" ]];then
		cp -p "${_ssu_h_mv_backup_dest[${___ssu_tearDown_h_mv_ind}]}" "${_ssu_h_mv_dest[${___ssu_tearDown_h_mv_ind}]}"
		if [ $? -ne 0 ];then
			echo "Error!!"
			echo "_ssu_tearDown_h_mv: Fail! No Space?"
			exit 1
		fi
		rm -f "${_ssu_h_mv_backup_dest[${___ssu_tearDown_h_mv_ind}]}"
	else
		rm -f "${_ssu_h_mv_dest[${___ssu_tearDown_h_mv_ind}]}"
	fi
	unset _ssu_h_mv_src[${___ssu_tearDown_h_mv_ind}]
	unset _ssu_h_mv_dest[${___ssu_tearDown_h_mv_ind}]
	unset _ssu_h_mv_backup_src[${___ssu_tearDown_h_mv_ind}]
	unset _ssu_h_mv_backup_dest[${___ssu_tearDown_h_mv_ind}]
}
################################################################################
# chmod helper
# $1 mod
# $2 file (1 file only)
################################################################################
h_chmod(){
	typeset __h_chmod_mod=""
	typeset __h_chmod_file=""
	if [[ $# -eq 2 ]];then
		__h_chmod_mod="${1}"
		__h_chmod_file=`_ssu_to_abst "${2}"`
	else
		_ssu_ErrExit "h_chmod: wrong argument."
	fi
	
	if [ ! -f ${__h_chmod_file} ];then
		_ssu_ErrExit "_h_chmod" "${__h_chmod_file} cannot access or not file."
	fi
	
	typeset __h_chmod_temp_mod=`_ssu_FindModByNum "${__h_chmod_file}"`;
	chmod "${__h_chmod_mod}" "${__h_chmod_file}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_chmod: Fail! Cannot Access ${__h_chmod_file} ?"
	fi
	typeset __h_chmod_ind=`echo ${#_ssu_h_chmod_backup_mod[@]}`
	_ssu_h_chmod_backup_mod[${__h_chmod_ind}]="${__h_chmod_temp_mod}"
	_ssu_h_chmod_file[${__h_chmod_ind}]="${__h_chmod_file}"
	
	__h_chmod_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_chmod_ind}]="_ssu_tearDown_h_chmod"
}

_ssu_tearDown_h_chmod(){
	typeset ___ssu_tearDown_h_chmod_ind=`echo ${#_ssu_h_chmod_backup_mod[@]}`
	___ssu_tearDown_h_chmod_ind=$((${___ssu_tearDown_h_chmod_ind}-1))
	chmod ${_ssu_h_chmod_backup_mod[${___ssu_tearDown_h_chmod_ind}]} ${_ssu_h_chmod_file[${___ssu_tearDown_h_chmod_ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_chmod: Fail! Cannot Access "${_ssu_h_chmod_file[${___ssu_tearDown_h_chmod_ind}]}" ?"
		exit 1
	fi
	unset _ssu_h_chmod_backup_mod[${___ssu_tearDown_h_chmod_ind}]
	unset _ssu_h_chmod_file[${___ssu_tearDown_h_chmod_ind}]
}

################################################################################
# chown helper
# $1 own
# $2 file (1 file only)
################################################################################
h_chown(){
	typeset __h_chown_own=""
	typeset __h_chown_file=""
	if [[ $# -eq 2 ]];then
		__h_chown_own="${1}"
		__h_chown_file=`_ssu_to_abst "${2}"`
	else
		_ssu_ErrExit "h_chown"
	fi
	
	if [ ! -f ${__h_chown_file} ];then
		_ssu_ErrExit "_h_chown" "${__h_chown_file} cannot access or not file."
	fi
	
	typeset __h_chown_temp_ls=`ls -l "${__h_chown_file}"`;
	typeset __h_chown_i=0
	typeset __h_chown_temp_gr=""
	typeset __h_chown_temp_usr=""
	typeset __h_chown_x=""
	for x in ${__h_chown_temp_ls}
	do
		__h_chown_i=$((${__h_chown_i}+1))
		if [ ${__h_chown_i} -eq 3 ];then
			__h_chown_temp_gr=${__h_chown_x}
		elif [${__h_chown_i} -eq 4 ];then
			__h_chown_temp_usr=${__h_chown_x}
		fi
	done
	
	typeset __h_chown_temp_own=${__h_chown_temp_gr}.${__h_chown_temp_usr}
	
	chown "${__h_chown_own}" "${__h_chown_file}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_chown: Fail! Cannot Access "${__h_chown_file}" ?"
	fi
	
	typeset __h_chown_ind=`echo ${#_ssu_h_chown_backup_own[@]}`
	_ssu_h_chown_backup_own[${__h_chown_ind}]="${__h_chown_temp_own}"
	_ssu_h_chown_file[${__h_chown_ind}]="${__h_chown_file}"
	
	__h_chown_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_chown_ind}]="_ssu_tearDown_h_chown"
}

_ssu_tearDown_h_chown(){
	typeset ___ssu_tearDown_h_chown_ind=`echo ${#_ssu_h_chown_backup_own[@]}`
	___ssu_tearDown_h_chown_ind=$((${___ssu_tearDown_h_chown_ind}-1))
	chown ${_ssu_h_chown_backup_own[${___ssu_tearDown_h_chown_ind}]} ${_ssu_h_chown_file[${___ssu_tearDown_h_chown_ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_chown: Fail! Cannot Access "${_ssu_h_chown_file[${___ssu_tearDown_h_chown_ind}]}" ?"
		exit 1
	fi
	unset _ssu_h_chown_backup_own[${___ssu_tearDown_h_chown_ind}]
	unset _ssu_h_chown_file[${___ssu_tearDown_h_chown_ind}]
}

################################################################################
# cp helper
# $1 src (1 file only)
# $2 dest (1 file only)
# $3 options (like "-i" )
################################################################################
h_cp(){
	typeset __h_cp_src=""
	typeset __h_cp_dest=""
	typeset __h_cp_op=""
	if [[ $# -eq 2 || $# -eq 3 ]];then
		__h_cp_src=`_ssu_to_abst "${1}"`
		__h_cp_dest="${2}"
		__h_cp_op=""
		if [ $# = 3 ]
		then
			__h_cp_op="${3}";
		fi
	else
		_ssu_ErrExit "h_cp"
	fi
	if [ ! -f ${__h_cp_src} ];then
		_ssu_ErrExit "h_cp" "not found ${__h_cp_src}"
	fi

	typeset __h_cp_temp_src=`_ssu_TempFileName "${__h_cp_src}"`;
	cp -p  "${__h_cp_src}" "${__h_cp_temp_src}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_cp: Fail! No Space? :: ${__h_cp_src}"
	fi

	typeset __h_cp_temp_dest=""
	if [ -f ${__h_cp_dest} ];then
		__h_cp_dest=`_ssu_to_abst "${__h_cp_dest}"`
		__h_cp_temp_dest=`_ssu_TempFileName "${__h_cp_dest}"`;
		cp -p  "${__h_cp_dest}" "${__h_cp_temp_dest}"
		if [ $? -ne 0 ];then
			rm -f "${__h_cp_temp_src}"
			_ssu_ErrExit2 "h_cp: Fail! No Space? :: ${__h_cp_dest}"
		fi
	fi

	cp ${__h_cp_op} ${__h_cp_src} ${__h_cp_dest}
	typeset __h_cp_rc=$?
	if [ $__h_cp_rc -ne 0 ]
	then
		_ssu_ErrExit2 "h_cp: Fail! No Space?"
	fi
	
	__h_cp_dest=`_ssu_to_abst "${__h_cp_dest}"`
	
	typeset __h_cp_ind=`echo ${#_ssu_h_cp_dest[@]}`
	_ssu_h_cp_src[${__h_cp_ind}]="${__h_cp_src}"
	_ssu_h_cp_dest[${__h_cp_ind}]="${__h_cp_dest}"
	_ssu_h_cp_backup_src[${__h_cp_ind}]="${__h_cp_temp_src}"
	_ssu_h_cp_backup_dest[${__h_cp_ind}]="${__h_cp_temp_dest}"
	
	__h_cp_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_cp_ind}]="_ssu_tearDown_h_cp"
}

_ssu_tearDown_h_cp(){
	typeset ___ssu_tearDown_h_cp_ind=`echo ${#_ssu_h_cp_dest[@]}`
	___ssu_tearDown_h_cp_ind=$((${___ssu_tearDown_h_cp_ind}-1))
	cp -p "${_ssu_h_cp_backup_src[${___ssu_tearDown_h_cp_ind}]}" "${_ssu_h_cp_src[${___ssu_tearDown_h_cp_ind}]}"
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_cp: Fail! No Space?"
		exit 1
	fi
	rm -f ${_ssu_h_cp_dest[${___ssu_tearDown_h_cp_ind}]}
	
	if [[ "${_ssu_h_cp_backup_dest[${___ssu_tearDown_h_cp_ind}]}" != "" ]];then
		cp -p "${_ssu_h_cp_backup_dest[${___ssu_tearDown_h_cp_ind}]}" "${_ssu_h_cp_dest[${___ssu_tearDown_h_cp_ind}]}"
		if [ $? -ne 0 ];then
			echo "Error!!"
			echo "_ssu_tearDown_h_cp: Fail! No Space?"
			exit 1
		fi
		rm -f "${_ssu_h_cp_backup_dest[${___ssu_tearDown_h_cp_ind}]}"
	fi

	unset _ssu_h_cp_dest[${___ssu_tearDown_h_cp_ind}]
}


################################################################################
# rm helper
# $1 src (1 file only)
# $2 options (like "-i" )
################################################################################
h_rm(){
	typeset __h_rm_src=""
	typeset __h_rm_op=""
	if [[ $# -eq 1 || $# -eq 2 ]];then
		__h_rm_src=`_ssu_to_abst "${1}"`
		__h_rm_op=""
		if [ $# = 2 ]
		then
			__h_rm_op="${2}";
		fi
	else
		_ssu_ErrExit "h_rm"
	fi
	

	if [ ! -f ${__h_rm_src} ];then
		# _ssu_ErrExit "h_rm" "not found ${__h_rm_src}"
		return 1
	fi

	typeset __h_rm_backup_src=`_ssu_TempFileName "${__h_rm_src}"`;
	cp -p  ${__h_rm_src} ${__h_rm_backup_src}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_rm: Fail! No Space?"
	fi

	rm ${__h_rm_op} ${__h_rm_src}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_rm: cannot rm ${__h_rm_src}"
	fi

	typeset __h_rm_ind=`echo ${#_ssu_h_rm_src[@]}`
	_ssu_h_rm_src[${__h_rm_ind}]="${__h_rm_src}"
	_ssu_h_rm_backup_src[${__h_rm_ind}]="${__h_rm_backup_src}"
	
	__h_rm_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_rm_ind}]="_ssu_tearDown_h_rm"
}

_ssu_tearDown_h_rm(){
	typeset ___ssu_tearDown_h_rm_ind=`echo ${#_ssu_h_rm_src[@]}`
	___ssu_tearDown_h_rm_ind=$((${___ssu_tearDown_h_rm_ind}-1))
	cp -p ${_ssu_h_rm_backup_src[${___ssu_tearDown_h_rm_ind}]} ${_ssu_h_rm_src[${___ssu_tearDown_h_rm_ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_rm: Fail! No Space?"
		exit 1
	fi
	rm -f ${_ssu_h_rm_backup_src[${___ssu_tearDown_h_rm_ind}]}
	unset _ssu_h_rm_backup_src[${___ssu_tearDown_h_rm_ind}]
	unset _ssu_h_rm_src[${___ssu_tearDown_h_rm_ind}]
}

################################################################################
# mkdir helper
# $1 dir (1 dir only)
# $2 options (like "-i" )
################################################################################
h_mkdir(){
	typeset __h_mkdir_dir=""
	typeset __h_mkdir_op=""
	if [[ $# -eq 1 || $# -eq 2 ]];then
		__h_mkdir_dir="${1}"
		__h_mkdir_op=""
		if [ $# = 2 ]
		then
			__h_mkdir_op="${2}";
		fi
	else
		_ssu_ErrExit "h_mkdir"
	fi
	
	if [ -d ${__h_mkdir_dir} ];then
		echo "WARNING: already exist "${__h_mkdir_dir}" : h_mkdir" &>2
		return;
	fi
	
	typeset __h_mkdir_command="mkdir ${__h_mkdir_op} ${__h_mkdir_dir}"
	${__h_mkdir_command}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_mkdir: Fail! Cannot make dir ${__h_mkdir_dir}"
	fi
	
	__h_mkdir_dir=`_ssu_to_abst "$__h_mkdir_dir"`
	
	typeset __h_mkdir_ind=`echo ${#_ssu_h_mkdir_dir[@]}`
	_ssu_h_mkdir_dir[${__h_mkdir_ind}]="${__h_mkdir_dir}"
	
	__h_mkdir_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_mkdir_ind}]="_ssu_tearDown_h_mkdir"
}

_ssu_tearDown_h_mkdir(){
	typeset ___ssu_tearDown_h_mkdir_ind=`echo ${#_ssu_h_mkdir_dir[@]}`
	___ssu_tearDown_h_mkdir_ind=$((${___ssu_tearDown_h_mkdir_ind}-1))
	rm -fr ${_ssu_h_mkdir_dir[${___ssu_tearDown_h_mkdir_ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_mkdir: Fail! Cannot remove dir "${_ssu_h_mkdir_dir[${___ssu_tearDown_h_mkdir_ind}]}
		exit 1
	fi
	unset _ssu_h_mkdir_dir[${___ssu_tearDown_h_mkdir_ind}]
}


################################################################################
# cd helper
# $1 dir (1 dir only)
################################################################################
h_cd(){
	typeset __h_cd_dir=""
	typeset __h_cd_op=""
	if [[ $# -eq 1 || $# -eq 2 ]];then
		__h_cd_dir=`_ssu_to_abst "${1}"`
		__h_cd_op=""
		if [ $# = 2 ]
		then
			__h_cd_op="${2}";
		fi
	else
		_ssu_ErrExit "h_cd"
	fi
	
	typeset __h_cd_old_dir=`pwd`
	
	typeset __h_cd_command="cd ${__h_cd_op} ${__h_cd_dir}"
	${__h_cd_command}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_cd: Fail! Cannot cd ${__h_cd_dir}"
	fi
	
	typeset __h_cd_ind=`echo ${#_ssu_h_cd_old_dir[@]}`
	_ssu_h_cd_old_dir[${__h_cd_ind}]="${__h_cd_old_dir}"
	
	__h_cd_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_cd_ind}]="_ssu_tearDown_h_cd"
}

_ssu_tearDown_h_cd(){
	typeset ___ssu_tearDown_h_cd_ind=`echo ${#_ssu_h_cd_old_dir[@]}`
	___ssu_tearDown_h_cd_ind=$((${___ssu_tearDown_h_cd_ind}-1))
	
	cd ${_ssu_h_cd_old_dir[${___ssu_tearDown_h_cd_ind}]}
	unset _ssu_h_cd_old_dir[${___ssu_tearDown_h_cd_ind}]
}

################################################################################
# make file helper
# $1 file (1 file only)
################################################################################
h_make_file(){
	typeset __h_make_file_file=""
	if [[ $# -eq 1 ]];then
		__h_make_file_file="${1}"
	else
		_ssu_ErrExit "h_make_file"
	fi
	
	typeset __h_make_file_backup_src="";
	if [ -f ${__h_make_file_file} ];then
		__h_make_file_file=`_ssu_to_abst "$__h_make_file_file"`
		__h_make_file_backup_src=`_ssu_TempFileName "${__h_make_file_file}"`;
		cp -p  ${__h_make_file_file} ${__h_make_file_backup_src}
		if [ $? -ne 0 ];then
			_ssu_ErrExit2 "h_make_file: Fail! No Space?"
		fi
		rm -f ${__h_make_file_file}
		if [ $? -ne 0 ];then
			_ssu_ErrExit2 "We cannot rm ${__h_make_file_file}!"
		fi
	fi
	
	typeset __h_make_file_command="touch ${__h_make_file_file}"
	${__h_make_file_command}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_make_file: Fail! Cannot make file ${__h_make_file_file}"
	fi
	
	__h_make_file_file=`_ssu_to_abst "$__h_make_file_file"`
	
	typeset __h_make_file_ind=`echo ${#_ssu_h_make_file[@]}`
	_ssu_h_make_file[${__h_make_file_ind}]="${__h_make_file_file}"
	_ssu_h_make_backup_file[${__h_make_file_ind}]="${__h_make_file_backup_src}"
	
	__h_make_file_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_make_file_ind}]="_ssu_tearDown_h_make_file"
}

_ssu_tearDown_h_make_file(){
	typeset ___ssu_tearDown_h_make_file_ind=`echo ${#_ssu_h_make_file[@]}`
	___ssu_tearDown_h_make_file_ind=$((${___ssu_tearDown_h_make_file_ind}-1))
	rm -f "${_ssu_h_make_file[${___ssu_tearDown_h_make_file_ind}]}"

	if [[ "${_ssu_h_make_backup_file[${___ssu_tearDown_h_make_file_ind}]}" != "" ]];then
		cp -p "${_ssu_h_make_backup_file[${___ssu_tearDown_h_make_file_ind}]}" "${_ssu_h_make_file[${___ssu_tearDown_h_make_file_ind}]}"
		if [ $? -ne 0 ];then
			echo "Error!!"
			echo "_ssu_tearDown_h_make_file: Fail! No Space?"
			exit 1
		fi
		rm -f "${_ssu_h_make_backup_file[${___ssu_tearDown_h_make_file_ind}]}"
	fi

	unset _ssu_h_make_file[${___ssu_tearDown_h_make_file_ind}]
	unset _ssu_h_make_backup_file[${___ssu_tearDown_h_make_file_ind}]
}


################################################################################
# db helper
# $1 input file 
# $2 table name
################################################################################
h_db(){
	typeset __h_db_file=""
	typeset __h_db_table=""
	if [[ $# -eq 2 ]];then
		__h_db_file="${1}"
		__h_db_table="${2}"
	else
		_ssu_ErrExit "h_db"
	fi
	
	typeset __h_db_table_backup_src=`_ssu_TempFileName "${__h_db_table}"`;
	touch "${__h_db_table_backup_src}"
	typeset __h_db_table_backup_tbl=`basename ${__h_db_table_backup_src}`
	
	#db to file
	u_db_select_to "${__h_db_table_backup_src}" "${__h_db_table}"
	
    #TODO db to backup db
    case ${SSU_DB_TYPE} in
	"Oracle")
	    echo "CREATE TABLE ${__h_db_table_backup_tbl} AS SELECT * FROM ${__h_db_table};">${__h_db_table_backup_src}
	    ;;

	*)
	    #for DB2
	    echo "CREATE TABLE ${__h_db_table_backup_tbl} LIKE ${__h_db_table}">${__h_db_table_backup_src}
	    u_db_sql_exec "${__h_db_table_backup_src}"
	    echo "INSERT INTO ${__h_db_table_backup_tbl} SELECT * FROM ${__h_db_table}">${__h_db_table_backup_src}
	    ;;
    esac
	u_db_sql_exec "${__h_db_table_backup_src}"

	#all erase
	u_db_delete "${__h_db_table}" > /dev/null
	
	#file to db
	u_db_insert "${__h_db_file}" "${__h_db_table}"
	
	typeset __h_db_ind=`echo ${#_ssu_h_db_table_backup[@]}`
	_ssu_h_db_table_backup[${__h_db_ind}]="${__h_db_table_backup_src}"
	_ssu_h_db_table_name[${__h_db_ind}]="${__h_db_table}"
	
	__h_db_ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${__h_db_ind}]="_ssu_tearDown_h_db"
}

_ssu_tearDown_h_db(){
	typeset ___ssu_tearDown_h_db_ind=`echo ${#_ssu_h_db_table_backup[@]}`
	___ssu_tearDown_h_db_ind=$((${___ssu_tearDown_h_db_ind}-1))
	
	typeset ___ssu_tearDown_h_db_table_backup=${_ssu_h_db_table_backup[${___ssu_tearDown_h_db_ind}]}
	typeset ___ssu_tearDown_h_db_table_name=${_ssu_h_db_table_name[${___ssu_tearDown_h_db_ind}]}
	typeset ___ssu_tearDown_h_db_table_name_bk=`basename ${___ssu_tearDown_h_db_table_backup}`
	
	#all erase
	u_db_delete "${___ssu_tearDown_h_db_table_name}" > /dev/null
	
	#file to db
	u_db_insert "${___ssu_tearDown_h_db_table_backup}" "${___ssu_tearDown_h_db_table_name}"

	#TODO recover from backup table
	echo "INSERT INTO ${___ssu_tearDown_h_db_table_name} SELECT * FROM ${___ssu_tearDown_h_db_table_name_bk}">${___ssu_tearDown_h_db_table_backup}
	u_db_sql_exec "${___ssu_tearDown_h_db_table_backup}"
	echo "DROP TABLE ${___ssu_tearDown_h_db_table_name_bk}">${___ssu_tearDown_h_db_table_backup}
	u_db_sql_exec "${___ssu_tearDown_h_db_table_backup}"
	
	rm -f "${___ssu_tearDown_h_db_table_backup}"
	
	unset _ssu_h_db_table_backup[${___ssu_tearDown_h_db_ind}]
	unset _ssu_h_db_table_name[${___ssu_tearDown_h_db_ind}]
}
