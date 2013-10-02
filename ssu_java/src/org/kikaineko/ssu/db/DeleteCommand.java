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
import java.sql.SQLException;
import java.sql.Statement;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class DeleteCommand {
	public static void delete(String jdbcClass, String url,
			String user, String password, String table,String where) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		String sql=null;
		try {
			conn = connect(jdbcClass, url, user, password);
			sql="delete from "+table;
			if(where!=null && where.trim().length()!=0){
				sql+=" "+where;
			}
			conn.setAutoCommit(false);
			stmt=conn.createStatement();
			int count= stmt.executeUpdate(sql);
			conn.commit();
			System.out.print(count);
		} catch (Throwable e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (Exception e1) {
				}
			}
			throw new Exception(e.getMessage()+"\n sql=>"+sql,e);
		} finally {
			close(conn, null, stmt);
		}
	}
	private static Connection connect(String jdbcClass, String url,
			String user, String password) throws ClassNotFoundException,
			SQLException {
		Class.forName(jdbcClass);
		Connection conn = null;
		if (user != null && user.length() != 0) {
			conn = DriverManager.getConnection(url, user, password);
		} else {
			conn = DriverManager.getConnection(url);
		}
		return conn;
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
