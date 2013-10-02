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
import java.sql.Types;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class UpdateCommand {

	// "${TARGET_DBMS_COMMAND}" "${TARGET_DBNAME}" "${TARGET_DB_USER}"
	// "${TARGET_DB_PASSWORD}" "${TARGET_DB_DRIVER}" "${table}" "${values}"
	// "${where}"
	public static void createSQL(String dbms, String dbUrl, String user,
			String pswd, String driver, String table, String values,
			String where) throws ClassNotFoundException, SQLException {

	}

	private static String makeSetCommand(int type, ResultSet rs, String name)
			throws SQLException {
		switch (type) {
		case Types.CHAR:
		case Types.VARCHAR:
		case Types.LONGVARCHAR:
			return setPartString(name,rs.getString(name));
		case Types.NUMERIC:
		case Types.DECIMAL:
		case Types.BIT:
		case Types.TINYINT:
		case Types.SMALLINT:
		case Types.INTEGER:
		case Types.BIGINT:
		case Types.REAL:
		case Types.FLOAT:
		case Types.DOUBLE:
			return setPartNumber(name,rs.getString(name));
		case Types.BINARY:
		case Types.VARBINARY:
		case Types.LONGVARBINARY:
			return setPartString(name,rs.getString(name));
		case Types.DATE:
		case Types.TIME:
		case Types.TIMESTAMP:
			return setPartString(name,rs.getString(name));
		default:
			break;
		}
		return null;
	}
	
	private static String setPartString(String name,String value){
		return name + "=\'" + value + "\'";
	}
	private static String setPartNumber(String name,String value){
		return name + "=" + value;
	}

	public static String buildSQL(String dbms, String dbUrl, String user,
			String pswd, String driver, String table, String values,
			String where)throws ClassNotFoundException, SQLException {
		Class.forName(driver);
		Connection con = DriverManager.getConnection(dbUrl, user, pswd);
		Statement stmt = con.createStatement();
		String sql = "SELECT " + values + " FROM " + table;
		String[] rowNames = values.split(",");
		if (where != null && where.trim().length() != 0) {
			sql = sql + " where " + where;
		}
		ResultSet rs = stmt.executeQuery(sql);
		ResultSetMetaData metaData = rs.getMetaData();
		int[] clmTypes = new int[rowNames.length];
		for (int i = 1; i <= metaData.getColumnCount(); i++) {
			String name = metaData.getColumnName(i).toUpperCase();
			for (int j = 0; j < rowNames.length; j++) {
				if (name.equals(rowNames[j].toUpperCase())) {
					clmTypes[j] = metaData.getColumnType(i);
					break;
				}
			}
		}

		while (rs.next()) {
			for (int i = 0; i < rowNames.length; i++) {
				String s = makeSetCommand(clmTypes[i], rs, rowNames[i]);
				System.out.println(s);
			}
		}
		stmt.close();
		con.close();
		return null;
	}

}
