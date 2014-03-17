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
package org.kikaineko.ssu.csv;
/**
 *
 * @author Masayuki Ioki
 *
 */
class CSVTokenKind {
	public static CSVTokenKind Start=new CSVTokenKind(0);
	public static CSVTokenKind DoubleQ=new CSVTokenKind(1);
	public static CSVTokenKind ClosedStart=new CSVTokenKind(2);
	public static CSVTokenKind Delimiter=new CSVTokenKind(3);
	public static CSVTokenKind ClosedWord=new CSVTokenKind(4);
	public static CSVTokenKind ClosedEnd=new CSVTokenKind(5);
	public static CSVTokenKind Word=new CSVTokenKind(6);
	private int index=-1;
	private CSVTokenKind(int i){
		index=i;
	}
	public boolean equals(Object other){
		if(other==null){
			return false;
		}
		if(other instanceof CSVTokenKind){
			CSVTokenKind o=(CSVTokenKind)other;
			return o.index==this.index;
		}
		return false;
	}
}
