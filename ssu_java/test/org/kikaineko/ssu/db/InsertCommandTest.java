package org.kikaineko.ssu.db;

import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import junit.framework.TestCase;

public class InsertCommandTest extends TestCase {
	public void testSanit(){
		//assertEquals("aa '' vv", InsertCommand.sanit("aa ' vv"));
	}
	/*
	public void testOracleDateAndTimestamp() throws Exception {
		InsertCommand.dbmsType("oracle");
		assertEquals("to_date('2008/01/22','yyyy/mm/dd')", InsertCommand.norm(
				Types.DATE, "2008/01/22"));
		assertEquals("to_date('2008/01/22','yyyy/mm/dd')", InsertCommand.norm(
				Types.DATE, "2008-01-22"));
		assertEquals("to_date('2008/01/22','yyyy/mm/dd')", InsertCommand.norm(
				Types.DATE, "20080122"));

		assertEquals(
				"to_timestamp('2008/01/22 00:12:40','yyyy/mm/dd hh24:mi:ss')",
				InsertCommand.norm(Types.TIMESTAMP, "2008/01/22 00:12:40"));
		assertEquals(
				"to_timestamp('2008/01/22 00:12:40','yyyy/mm/dd hh24:mi:ss')",
				InsertCommand.norm(Types.TIMESTAMP, "2008-01-22 00-12-40"));
		assertEquals(
				"to_timestamp('2008/01/22 00:12:40','yyyy/mm/dd hh24:mi:ss')",
				InsertCommand.norm(Types.TIMESTAMP, "2008-01-22 00/12/40"));
		assertEquals(
				"to_timestamp('2008/01/22 00:12:40','yyyy/mm/dd hh24:mi:ss')",
				InsertCommand.norm(Types.TIMESTAMP, "20080122 001240"));
		assertEquals(
				"to_timestamp('2008/01/22 00:12:40','yyyy/mm/dd hh24:mi:ss')",
				InsertCommand.norm(Types.TIMESTAMP, "20080122001240"));
	}
	*/

	public void testSql() throws Throwable {
		//InsertMapper.setDbmsType("oracle");
		String sql = "insert into emp (id,name,date) values (12,'hoge data',to_timestamp('2009/01/14 01:41:50','yyyy/mm/dd hh24:mi:ss'))";
		List names = new ArrayList();
		names.add("id");
		names.add("name");
		names.add("date");
		Map map = new HashMap();
		map.put("id", Integer.valueOf(Types.INTEGER));
		map.put("date", Integer.valueOf(Types.TIMESTAMP));
		map.put("name", Integer.valueOf(Types.CHAR));
		List data = new ArrayList();
		data.add("12");
		data.add("hoge data");
		data.add("20090114014150");
		//String sql1=InsertCommand.createSQLPre("emp", names);
		//sql1 = InsertCommand.createSQL(sql1, names, map, data);
		//assertEquals(sql, sql1);
	}
	
	public void testBigt() throws Exception{
		String filePath = "bigt/2.csv";
		String jdbcClass = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "system";
		String password = "ioki0da";
		String table = "BIGT";
		
		InsertCommand.insert(filePath, jdbcClass, url, user, password, table);
	}
	
}
