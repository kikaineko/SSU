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

import java.math.BigDecimal;
import java.sql.Types;
/**
 *
 * @author Masayuki Ioki
 *
 */
public class InsertMapper {

	private static boolean isEmpty(String s) {
		return s == null || s.length() == 0;
	}

	private static boolean isNull(String s){
		return s.equalsIgnoreCase("null");
	}


	protected static String sanit(String s) {
		if (s.indexOf("'") != -1) {
			s = s.replaceAll("'", "''");
		}
		return s;
	}

	public static String norm(int type, String s) {
		String ss=s;
		if(ss!=null){
			s=ss.trim();
		}
		switch (type) {
		case Types.CHAR:
		case Types.VARCHAR:
		case Types.LONGVARCHAR:
		case Types.BINARY:
		case Types.VARBINARY:
		case Types.LONGVARBINARY:
		case Types.NVARCHAR:
		case Types.LONGNVARCHAR:
			if (isEmpty(s)) {
				return "''";
			}
			if (isNull(s)){
				return "null";
			}
			return "'"+sanit(ss)+"'";
		case Types.BIT:
			if ("0".equals(s)
					|| (!isEmpty(s) && "true".equals(s.toLowerCase()))) {
				return "'0'";
			} else {
				if(!isEmpty(s) && "false".equals(s.toLowerCase())){
					//check number type
					Integer.parseInt(s);
				}
				return "'1'";
			}
		case Types.TINYINT:
		case Types.SMALLINT:
			if (isNull(s)){
				return "null";
			}else if (!isEmpty(s)) {
				return Short.valueOf(s).toString();
			} else  {
				return "0";
			}
		case Types.INTEGER:
			if (isNull(s)){
				return "null";
			} else if (!isEmpty(s)) {
				return Integer.valueOf(s).toString();
			} else  {
				return "0";
			}
		case Types.BIGINT:
			if (isNull(s)){
				return "null";
			} else if (!isEmpty(s)) {
				return Long.valueOf(s).toString();
			} else  {
				return "0";
			}
		case Types.REAL:
			if (isNull(s)){
				return "null";
			} else if (!isEmpty(s)) {
				return Float.valueOf(s).toString();
			} else  {
				return "0";
			}
		case Types.FLOAT:
		case Types.DOUBLE:
			if (isNull(s)){
				return "null";
			} else if (!isEmpty(s)) {
				return Double.valueOf(s).toString();
			} else  {
				return "0";
			}
		case Types.NUMERIC:
		case Types.DECIMAL:
			if (isNull(s)){
				return "null";
			} else if (!isEmpty(s)) {
				return new BigDecimal(s).toString();
			} else  {
				return null;
			}

		case Types.DATE:
			if (isNull(s)){
				return "null";
			} else {return datef(s);}
		case Types.TIME:
			if (isNull(s)){
				return "null";
			} else if (Mapper.getDbmsType().equals(Mapper.DB2)) {
				return (!isEmpty(s)) ? "'" + s + "'" : null;
			}
		case Types.TIMESTAMP:
			if (isNull(s)){
				return "null";
			}else{return timestampf(s);}
		default:
			break;
		}
		return null;
	}

	protected static String timestampf(String s) {
		String t = TimeF.toSFromTimestamp(s);
		if(t.length()==0){
			return null;
		}
		if (Mapper.getDbmsType().equals(Mapper.DB2)) {
			return "'" + t + "'";
		}
		if (Mapper.getDbmsType().equals(Mapper.ORACLE)) {
			return "to_timestamp('" + t + "','yyyy-mm-dd hh24:mi:ss.ff3')";
		}
		return "'" + s + "'";
	}

	protected static String datef(String s) {
        String t = null;
		if (Mapper.getDbmsType().equals(Mapper.DB2)) {
			t = TimeF.toSFromDate(s);
		}
		if (Mapper.getDbmsType().equals(Mapper.ORACLE)) {
			t = TimeF.toSFromTimestamp(s);
        }
		else {
			//TODO
			t = TimeF.toSFromDate(s);
		}

		if(t.length()==0){
			return null;
		}
		String[] ss=t.split("\\.");
		t=ss[0];
		if (Mapper.getDbmsType().equals(Mapper.DB2)) {
			return "'" + t + "'";
		}
		if (Mapper.getDbmsType().equals(Mapper.ORACLE)) {
			return "to_date('" + t + "','yyyy-mm-dd hh24:mi:ss')";
		}
		return "'" + s + "'";
	}
}
