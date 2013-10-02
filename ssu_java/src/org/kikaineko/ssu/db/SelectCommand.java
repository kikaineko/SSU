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

import org.kikaineko.ssu.csv.CSVParser;
import org.kikaineko.ssu.exception.DBCheckException;
import org.kikaineko.ssu.exception.SSUException;
import org.kikaineko.util.FileIO;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class SelectCommand {
	private static String BR = System.getProperty("line.separator");

	public static void selectTo(String flag, String filePath, String jdbcClass,
			String url, String user, String password, String table, String where)
			throws Exception {
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		StringBuffer sb = new StringBuffer();
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select * from " + table;
			if (where != null && where.trim().length() != 0) {
				sql += " " + where;
			}
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
		}
		if (DBCommander.SELECTTO.equals(flag)) {
			FileIO.writeOutPutFile(filePath, sb.toString(),
					FileIO.FileWriteCodeFromDB);
		} else {
			System.out.print(sb);
		}
	}

	public static void selectAssertOrder(String filePath, String jdbcClass,
			String url, String user, String password, String table,
			String where, String convertPath) throws Throwable {
		ArrayList fileData = FileIO.getFileDatas(filePath,
				FileIO.FileReadCodeToDB);
		if (fileData.size() < 2) {
			throw new SSUException("no data in " + filePath);
		}
		if (convertPath != null && convertPath.length() != 0) {
			Convertor.init(convertPath);
		} else {
			convertPath = null;
		}

		String head = (String) fileData.get(0);
		fileData.remove(0);
		List csvdata = CSVParser.getCSVLineList(fileData);
		int max = ((List) csvdata.get(0)).size();
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select " + head + " from " + table;
			if (where != null && where.trim().length() != 0
					&& !where.trim().equals(".")) {
				sql += " " + where.trim();
			}
			
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();

			while (rset.next()) {
				ArrayList temp = new ArrayList();
				for (int i = 1; i <= max; i++) {
					// temp.add(Mapper.normFromDB(rset, i,
					// rsmd.getColumnType(i)));
					Object o = Mapper
							.normFromDB(rset, i, rsmd.getColumnType(i));
					if (convertPath != null && o instanceof String) {
						String s = (String) o;
						s = Convertor.convert(s);
						temp.add(s);
					} else {
						temp.add(o);
					}
				}

				if (csvdata.size() == 0) {
					throw new DBCheckException("not find " + temp.toString()
							+ " in " + filePath + "\n sql => " + sql);
				}
				List data = (List) csvdata.get(0);
				List csvtmp = new ArrayList();
				for (int i = 0; i < data.size(); i++) {
					// csvtmp.add(Mapper.normFromCSV((String) data.get(i), rsmd
					// .getColumnType(i + 1)));
					Object o = Mapper.normFromCSV((String) data.get(i), rsmd
							.getColumnType(i + 1));
					if (convertPath != null && o instanceof String) {
						String s = (String) o;
						s = Convertor.convert(s);
						csvtmp.add(s);
					} else {
						csvtmp.add(o);
					}
				}

				if (csvtmp.size() != temp.size()) {
					throw new DBCheckException("unmuched count of columns DB:"
							+ temp.toString() + " FILE:" + csvtmp
							+ "\n sql => " + sql);
				}
				for (int i = 0; i < csvtmp.size(); i++) {
					Object co = csvtmp.get(i);
					Object dbo = temp.get(i);
					if (co != null && co.equals(dbo)) {
					} else if (co == null && dbo == null) {
					} else {
						throw new DBCheckException("unmuched DB:"
								+ temp.toString() + " FILE:" + csvtmp
								+ "\n unmuched column number is " + (i + 1)
								+ " DB:" + dbo + " FILE:" + co + "  \n sql => "
								+ sql);
					}
				}
				csvdata.remove(0);
			}

			if (csvdata.size() != 0) {
				throw new DBCheckException("not find " + csvdata.toString()
						+ " in table<" + table + ">\n sql => " + sql);
			}
		} catch (Throwable e) {
			if (e instanceof DBCheckException) {
				throw e;
			} else {
				throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
			}
		} finally {
			close(conn, rset, stmt);
		}
	}

	/**
	 * 
	 * flag is complete or include. complete is [CSV = Table].
	 * include is [CSV <= Table].<br/>
	 * 
	 * @param flag
	 * @param filePath
	 * @param jdbcClass
	 * @param url
	 * @param user
	 * @param password
	 * @param table
	 * @param where
	 * @throws Throwable
	 */
	public static void selectAssert(String flag, String filePath,
			String jdbcClass, String url, String user, String password,
			String table, String where, String convertPath) throws Throwable {
		if (!flag.equals("complete")) {
			flag = "include";
		}
		if (convertPath != null && convertPath.length() != 0) {
			Convertor.init(convertPath);
		} else {
			convertPath = null;
		}
		ArrayList fileData = FileIO.getFileDatas(filePath,
				FileIO.FileReadCodeToDB);
		if (fileData.size() < 2) {
			throw new SSUException("no data in " + filePath);
		}
		String head = (String) fileData.get(0);
		fileData.remove(0);
		List csvdata = CSVParser.getCSVLineList(fileData);
		int max = ((List) csvdata.get(0)).size();
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select " + head + " from " + table;
			if (where != null && where.trim().length() != 0
					&& !where.trim().equals(".")) {
				sql += " " + where.trim();
			}
			
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();

			int clmnSize = rsmd.getColumnCount();

			List csvMapped = new ArrayList();
			for (int i = 0; i < csvdata.size(); i++) {
				List data = (List) csvdata.get(i);
				List csvtmp = new ArrayList();
				if (clmnSize != data.size()) {
					throw new DBCheckException(
							"Unmuched ColumnCount! RowCount=" + clmnSize
									+ " CSVCount=" + data.size() + "\n sql => "
									+ sql);
				}
				for (int j = 0; j < data.size(); j++) {
					Object o = null;
					try {
						o = Mapper.normFromCSV((String) data.get(j), rsmd
								.getColumnType(j + 1));
					} catch (FormatException e) {
						e.setData((String) data.get(j));
						e.setColumnTypeName(rsmd.getColumnTypeName(j+1));
						e.setColumnName(rsmd.getColumnName(j+1));
						e.setCSVLine(i);
						e.setCnmIndex(j);
						throw e;
					}
					if (convertPath != null && o instanceof String) {
						String s = (String) o;

						s = Convertor.convert(s);
						csvtmp.add(s);
					} else {
						csvtmp.add(o);
					}
				}
				csvMapped.add(csvtmp);
			}

			while (rset.next()) {
				if (!flag.equals("complete")) {
					if (csvdata.size() == 0) {
						break;
					}
				}
				
				ArrayList temp = new ArrayList();
				for (int i = 1; i <= max; i++) {
					Object o = Mapper
							.normFromDB(rset, i, rsmd.getColumnType(i));

					if (convertPath != null && o instanceof String) {
						String s = (String) o;

						s = Convertor.convert(s);
						temp.add(s);
					} else {
						temp.add(o);
					}
				}

				int index = -1;
				for (int i = 0; i < csvMapped.size(); i++) {
					List csvtmp = (List) csvMapped.get(i);
										
					if (csvtmp.equals(temp)) {
						index = i;
						break;
					}
				}
				if (flag.equals("complete")) {
					if (index == -1) {
						throw new DBCheckException("not find "
								+ temp.toString() + " in " + filePath
								+ "\n sql => " + sql);
					}
				}
				if (index != -1) {
					csvMapped.remove(index);
				}
			}

			if (csvMapped.size() != 0) {
				throw new DBCheckException("not find " + csvMapped.toString()
						+ " in table<" + table + ">\n sql => " + sql);
			}
		} catch (Throwable e) {
			if (e instanceof DBCheckException) {
				throw e;
			} else {
				throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
			}
		} finally {
			close(conn, rset, stmt);
		}
	}

	public static void countAssert(String count, String jdbcClass, String url,
			String user, String password, String table, String where)
			throws Throwable {
		try {
			Integer.parseInt(count);
		} catch (Throwable t) {
			throw new DBCheckException(
					"UnCorrect Count! ExpectedValue is not number? " + count);
		}
		String[] ss = count(jdbcClass, url, user, password, table, where);
		String res = ss[1];
		String sql = ss[0];
		if (res != null && res.length() != 0) {
			if (!res.trim().equals(count.trim())) {
				throw new DBCheckException("UnCorrect Count! Expected:" + count
						+ " ,but Actual:" + res + "!! \n sql => " + sql);
			}
		} else {
			throw new DBCheckException("UnCorrect Count! Expected:" + count
					+ " ,but We cannnot get Count!! \n sql => " + sql);
		}
	}

	public static void countAssertNot(String count, String jdbcClass,
			String url, String user, String password, String table, String where)
			throws Throwable {
		try {
			Integer.parseInt(count);
		} catch (Throwable t) {
			throw new DBCheckException(
					"UnCorrect Count! UnExpectedValue is not number? " + count);
		}
		String[] ss = count(jdbcClass, url, user, password, table, where);
		String res = ss[1];
		String sql = ss[0];
		if (res != null && res.length() != 0) {
			if (res.trim().equals(count.trim())) {
				throw new DBCheckException("UnCorrect Count! UnExpected:"
						+ count + " ,but Actual:" + res + "!! \n sql => " + sql);
			}
		} else {
			throw new DBCheckException("UnCorrect Count! Expected:" + count
					+ " ,but We cannnot get Count!! \n sql => " + sql);
		}
	}

	private static String[] count(String jdbcClass, String url, String user,
			String password, String table, String where) throws Throwable {

		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select count(1) from " + table;
			if (where != null && where.trim().length() != 0) {
				sql += " " + where;
			}
			
			rset = stmt.executeQuery(sql);
			rset.next();
			String res = rset.getString(1);
			String[] ss = new String[2];
			ss[0] = sql;
			ss[1] = res.trim();
			return ss;
		} catch (Throwable e) {
			if (e instanceof DBCheckException) {
				throw e;
			}
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, rset, stmt);
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
