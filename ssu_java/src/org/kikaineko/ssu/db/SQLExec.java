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

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.kikaineko.util.FileIO;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class SQLExec {
	private static String BR = System.getProperty("line.separator");
	
	public static void exec(String filePath, String jdbcClass,
			String url, String user, String password) throws Exception{
		Connection conn = null;
		Statement stmt = null;
		StringBuffer sb = new StringBuffer();
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);
			sql=FileIO.getFileData(filePath, FileIO.FileReadCodeToDB);
			
			stmt.execute(sql);
		} catch (Throwable e) {
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, null, stmt);
			System.out.print(sb);
		}
	}

	public static void query( String filePath, String jdbcClass,
			String url, String user, String password)
			throws Exception {
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		StringBuffer sb = new StringBuffer();
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);
			sql=FileIO.getFileData(filePath, FileIO.FileReadCodeToDB);
			
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();
			List names = new ArrayList();
			List types = new ArrayList();
			names.add(rsmd.getColumnName(1));
			types.add(new Integer(rsmd.getColumnType(1)));
			sb.append(rsmd.getColumnName(1));
			for (int i = 1; i < rsmd.getColumnCount(); i++) {
				names.add(rsmd.getColumnName(i + 1));
				types.add(new Integer(rsmd.getColumnType(i + 1)));
				sb.append(",");
				sb.append(rsmd.getColumnName(i + 1));
			}
			sb.append(BR);
			while (rset.next()) {
				String name = (String) names.get(0);
				int type = ((Integer) types.get(0)).intValue();
				sb.append(Mapper.normTOCSV(rset, name, type));
				for (int i = 1; i < names.size(); i++) {
					name = (String) names.get(i);
					type = ((Integer) types.get(i)).intValue();
					sb.append(",");
					sb.append(Mapper.normTOCSV(rset, name, type));
				}
				sb.append(BR);
			}
		} catch (Throwable e) {
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, rset, stmt);
			System.out.print(sb);
		}
	}

	private static Statement connect(String jdbcClass, Connection conn,
			String url, String user, String password)
			throws ClassNotFoundException, SQLException {
		Class.forName(jdbcClass);
		if (user != null && user.length() != 0) {
			conn = DriverManager.getConnection(url, user, password);
		} else {
			conn = DriverManager.getConnection(url);
		}
		return conn.createStatement();
	}

	private static void close(Connection conn, ResultSet rset, Statement stmt) {
		if (rset != null) {
			try {
				rset.close();
			} catch (SQLException e) {
			}
		}
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
			}
		}
	}
}
