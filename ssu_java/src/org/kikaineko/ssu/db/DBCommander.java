/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package org.kikaineko.ssu.db;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class DBCommander {
	public static final String SELECT_COMP = "selectComp";
	public static final String SELECT_COMP_CONV = "selectComp.conv";
	public static final String SELECT_INC = "selectInc";
	public static final String SELECT_INC_CONV = "selectInc.conv";
	public static final String SELECT_COMP_ORDER = "selectCompOrder";
	public static final String SELECT_COMP_ORDER_CONV = "selectCompOrder.conv";
	public static final String SELECTTO = "selectto";
	public static final String SELECTOUT = "selectout";
	public static final String COUNT = "count";
	public static final String COUNTNOT = "countnot";
	public static final String INSERT = "insert";
	public static final String DELETE = "delete";
	public static final String QUERY = "query";
	public static final String EXEC = "exec";

	public static void exec(String db_option_flag, String filePath,
			String table, String jdbcClass, String url, String where,
			String user, String password,String convpath) throws Throwable {
		Mapper.setDbmsType(jdbcClass);

		if (SELECT_COMP.equals(db_option_flag)) {
			SelectCommand.selectAssert("complete", filePath, jdbcClass, url,
					user, password, table, where,null);
			
			//conv
		}else if (SELECT_COMP_CONV.equals(db_option_flag)) {
			SelectCommand.selectAssert("complete", filePath, jdbcClass, url,
					user, password, table, where,convpath);
		}else if (SELECT_INC_CONV.equals(db_option_flag)) {
			SelectCommand.selectAssert("include", filePath, jdbcClass, url,
					user, password, table, where,convpath);
		} else if (SELECT_COMP_ORDER_CONV.equals(db_option_flag)) {
			SelectCommand.selectAssertOrder(filePath, jdbcClass, url, user,
					password, table, where,convpath);
			//convend
			
		} else if (SELECT_INC.equals(db_option_flag)) {
			SelectCommand.selectAssert("include", filePath, jdbcClass, url,
					user, password, table, where,null);
		} else if (SELECT_COMP_ORDER.equals(db_option_flag)) {
			SelectCommand.selectAssertOrder(filePath, jdbcClass, url, user,
					password, table, where,null);
		} else if (COUNT.equals(db_option_flag)) {
			String count = filePath;
			SelectCommand.countAssert(count, jdbcClass, url, user, password,
					table, where);
		} else if (COUNTNOT.equals(db_option_flag)) {
			String count = filePath;
			SelectCommand.countAssertNot(count, jdbcClass, url, user, password,
					table, where);
		} else if (INSERT.equals(db_option_flag)
				&& (where == null || where.trim().length() == 0)) {
			InsertCommand.insert(filePath, jdbcClass, url, user, password,
					table);
		} else if (SELECTTO.equals(db_option_flag)) {
			SelectCommand.selectTo(SELECTTO, filePath, jdbcClass, url, user,
					password, table, where);
		} else if (SELECTOUT.equals(db_option_flag)) {
			SelectCommand.selectTo(SELECTOUT, filePath, jdbcClass, url, user,
					password, table, where);
		} else if (DELETE.equals(db_option_flag)) {
			DeleteCommand.delete(jdbcClass, url, user, password, table, where);
		} else if (QUERY.equals(db_option_flag)) {
			SQLExec.query(filePath, jdbcClass, url, user, password);
		} else if (EXEC.equals(db_option_flag)) {
			SQLExec.exec(filePath, jdbcClass, url, user, password);
		} else {
			throw new Exception("invalid args");
		}
	}

	public static void exec(String db_option_flag, String targetFile,
			String table, String jdbcClass, String url, String where)
			throws Throwable {
		exec(db_option_flag, targetFile, table, jdbcClass, url, where, null,
				null,null);
	}

	public static void exec(String db_option_flag, String targetFile,
			String table, String jdbcClass, String url, String user,
			String password) throws Throwable {
		exec(db_option_flag, targetFile, table, jdbcClass, url, null, user,
				password,null);
	}

	public static void exec(String db_option_flag, String targetFile,
			String table, String jdbcClass, String url) throws Throwable {
		exec(db_option_flag, targetFile, table, jdbcClass, url, null, null,
				null,null);
	}
}
