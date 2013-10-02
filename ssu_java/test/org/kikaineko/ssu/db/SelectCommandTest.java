package org.kikaineko.ssu.db;

import org.kikaineko.ssu.db.SelectCommand;

import junit.framework.TestCase;

public class SelectCommandTest extends TestCase {
	/*public void testSanit(){
		assertEquals("ab c", SelectCommand.sanit("ab c"));
		assertEquals("ab , c", SelectCommand.sanit("ab , c"));
		assertEquals("ab ,\\\" c", SelectCommand.sanit("ab ,\" c"));
		assertEquals("ab ,\\\" \\\\ \\\\ \\\\ c", SelectCommand.sanit("ab ,\" \\ \\ \\ c"));
	}*/
	public void testMain() throws Throwable {
		String filePath = "v_database.csv";
		String jdbcClass = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "system";
		String password = "ioki0da";
		String table = "V$DATABASE";
		SelectCommand.selectAssert("complete", filePath, jdbcClass, url, user,
				password, table, null,null);
	}

	public void atestHELP() throws Throwable {
		String filePath = "help.csv";
		String jdbcClass = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "system";
		String password = "ioki0da";
		String table = "HELP";
		//SelectCommand.selectAssert("include", filePath, jdbcClass, url, user,
			//	password, table, null);
		SelectCommand.selectAssert("complete", filePath, jdbcClass, url, user,
				password, table, "seq = 60 ",null);

		SelectCommand.selectAssert("complete", filePath, jdbcClass, url, user,
				password, table, "seq = 60 and topic ='TOPICS'",null);
	}
	
}
