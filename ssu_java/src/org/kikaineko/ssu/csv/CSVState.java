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
class CSVState {
	public static CSVState End=new CSVState(0);
	public static CSVState NotYetEnd=new CSVState(1);
	public static CSVState NotWord=new CSVState(2);
	private int index=-1;
	private CSVState(int i){
		index=i;
	}
	public boolean equals(Object other){
		if(other==null){
			return false;
		}
		if(other instanceof CSVState){
			CSVState o=(CSVState)other;
			return o.index==this.index;
		}
		return false;
	}
}
