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
public class FormatException extends RuntimeException {
	private static final long serialVersionUID = -3675672693479902135L;
	private String data;
	private int csvLine = -1;
	private int cnmIndex = -1;
	private String columnTypeName;
	private String columnName;

	public FormatException(String mes, Throwable e) {
		super(mes, e);
	}

	public FormatException(Throwable e) {
		super(e);
	}

	public String getMessage() {
		return "Format Error! csvLine=" + getCSVLine() + ", cnmIndex="
				+ getCnmIndex() + ", data=" + getData() + ", columnName="
				+ getColumnName()+", columnTypeName="+getColumnTypeName();
	}

	public int getCnmIndex() {
		return cnmIndex;
	}

	public void setCnmIndex(int cnmInde) {
		this.cnmIndex = cnmInde;
	}

	public void setData(String s) {
		this.data = s;
	}

	public String getData() {
		return data;
	}

	public void setCSVLine(int i) {
		csvLine = i;
	}

	public int getCSVLine() {
		return csvLine;
	}

	public void setColumnTypeName(String columnTypeName) {
		this.columnTypeName = columnTypeName;
	}

	public String getColumnTypeName() {
		return columnTypeName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getColumnName() {
		return columnName;
	}

}
