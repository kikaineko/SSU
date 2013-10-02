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
package org.kikaineko.ssu.source.util;

/**
 * @author Masayuki Ioki
 *
 */
public class Token {
	private int kind;
	private String val;
	public boolean isStringOrChar=false;
	int lineNo;
	
	public Token(int kind,String val){
		this.kind=kind;
		this.val=val;
	}
	
	public void setKind(int kind){
		this.kind=kind;
	}
	/**
	 * @return kind
	 */
	public int getKind() {
		return kind;
	}
	/**
	 * @return val
	 */
	public String getVal() {
		return val;
	}

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}
	
	public String toString(){
		return "["+kind+","+val+","+isStringOrChar+","+lineNo+"]";
	}
}
