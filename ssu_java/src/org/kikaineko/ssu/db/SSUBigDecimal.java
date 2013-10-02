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
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class SSUBigDecimal {
	public BigDecimal bd;
	public SSUBigDecimal(BigDecimal bd){
		this.bd=bd;
	}
	public boolean equals(Object other){
		if(other==null || !(other instanceof SSUBigDecimal)){
			return false;
		}
		BigDecimal ob=((SSUBigDecimal)other).bd;
		if(this.bd.equals(ob)){
			return true;
		}
		if(this.bd.compareTo(ob)==0){
			return true;
		}
		int thisScale=this.bd.scale();
		int otherScale=ob.scale();
		if(thisScale<otherScale){
			thisScale=otherScale;
		}
		BigDecimal b0=this.bd.setScale(thisScale);
		BigDecimal b1=ob.setScale(thisScale);
		if(b0.equals(b1)){
			return true;
		}
		return false;
	}
	
	public String toString(){
		return bd.toString();
	}
}
