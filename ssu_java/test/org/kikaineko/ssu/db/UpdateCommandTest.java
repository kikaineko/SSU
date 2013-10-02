package org.kikaineko.ssu.db;


import java.sql.SQLException;

import org.kikaineko.ssu.db.UpdateCommand;

import junit.framework.TestCase;

public class UpdateCommandTest extends TestCase {
	public void testMain() throws ClassNotFoundException, SQLException{
		UpdateCommand.buildSQL("db2","jdbc:db2://127.0.0.1:50000/foxdb01m","masayuki","masayuki0x","com.ibm.db2.jcc.DB2Driver","AHO","name","");
	}
}
