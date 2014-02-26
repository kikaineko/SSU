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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.kikaineko.ssu.csv.CSVParser;
import org.kikaineko.ssu.exception.SSUException;
import org.kikaineko.util.FileIO;
/**
 *
 * @author Masayuki Ioki
 *
 */
public class InsertCommand {
	public static void insert(String filePath, String jdbcClass, String url,
			String user, String password, String table) throws Exception {
		ArrayList fileData = FileIO.getFileDatas(filePath,FileIO.FileReadCodeToDB);
		if (fileData.size() < 1) {
			throw new SSUException("no data in " + filePath);
		}

		String head = (String) fileData.get(0);
		List names = null;
		if (!"*".equals(head.trim())) {
			names = CSVParser.lineParse(head);
		}
		fileData.remove(0);
		//sano - if last row is blank, remove.
		if(fileData.size()>0){
			int lastRec = fileData.size() - 1;
			if(((String) fileData.get(lastRec)).equals("")){
				fileData.remove(lastRec);
			}
		}
		List csvdata = CSVParser.getCSVLineList(fileData);
		Connection conn = null;
		Statement stmt = null;
		String sql = "";
		try {
			conn = connect(jdbcClass, url, user, password);
			Object[] os = clmDefs(jdbcClass, url, user, password, table, conn);
			Map map = (Map) os[0];
			if (names == null) {
				names = (List) os[1];
			}
			conn.setAutoCommit(false);
			stmt = conn.createStatement();
			for (int i = 0; i < csvdata.size(); i++) {
				List data = (List) csvdata.get(i);
				sql = createSQL(names, map, data, table);
				stmt.executeUpdate(sql);
			}
			conn.commit();
		} catch (Throwable e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (Exception e1) {
				}
			}
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, null, stmt);
		}
	}
	protected static String createSQL(List names, Map map, List data,String table)
			throws Throwable {
		StringBuffer presql = new StringBuffer("insert into ");
		presql.append(table).append(" (");
		StringBuffer val = new StringBuffer();
		int i = 0;
		String inputData=null;
		try {
			for (i = 0; i < names.size(); i++) {
				String s = (String) names.get(i);
				inputData=(String) data.get(i);
				Object o=InsertMapper.norm(((Integer) map.get(s)).intValue(),
						inputData);
				if(o!=null){
					presql.append(s).append(",");
					val.append(o).append(",");
				}
			}
			presql=new StringBuffer(presql.substring(0, presql.length()-1));
			val=new StringBuffer(val.substring(0, val.length()-1));
			val.append(")");
		} catch (Throwable e) {
			throw new RuntimeException("ColumnName " + names.get(i)
					+ " is correct? or Data ["+inputData+"] is wrong?", e);
		}
		presql.append(") values (").append(val);
		return presql.toString();
	}

	protected static Object[] clmDefs(String jdbcClass, String url,
			String user, String password, String table, Connection conn)
			throws Exception {
		Map map = new HashMap();
		ResultSet rset = null;
		Statement stmt = null;
		List names = new ArrayList();
		try {
			stmt = conn.createStatement();
			String sql = "select * from " + table;
			if (Mapper.getDbmsType().equals(Mapper.DB2)) {
				sql += " fetch first 1 row only";
			} else if (Mapper.getDbmsType().equals(Mapper.NETEZZA)) {
				sql += " limit 1";
			}

			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				String s = rsmd.getColumnName(i + 1);
				names.add(s);
				map.put(s, new Integer(rsmd.getColumnType(i + 1)));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close(null, rset, stmt);
		}
		return new Object[] { map, names };
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
