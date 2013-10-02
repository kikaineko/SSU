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

import org.kikaineko.ssu.sourcescan.Tokenizer;

/**
 * @author Masayuki Ioki
 */
public class TokenArray {
	private Token[] tokens;

	private int addLength = 50;

	private int length;

	/**
	 * @param tokens
	 */
	public TokenArray(Token[] ts) {
		this.tokens = new Token[ts.length];
		length = ts.length;
		System.arraycopy(ts, 0, tokens, 0, tokens.length);
	}

	public TokenArray(String context) {

		Token[] ts = (new Tokenizer(context)).getTokens();
		this.tokens = new Token[ts.length];
		length = ts.length;
		System.arraycopy(ts, 0, tokens, 0, tokens.length);

	}

	public TokenArray() {
		tokens = new Token[addLength];
		length = 0;
	}

	/**
	 * @return
	 */
	public int length() {
		return length;
	}

	/**
	 * 
	 * @param word
	 * @return
	 */
	public int indexOfKind(int kind) {
		return indexOfKind(kind, 0);
	}

	/**
	 * 
	 * @param number
	 * @param i
	 * @return
	 */
	public int indexOfKind(int kind, int fromIndex) {
		for (int i = fromIndex; i < length(); i++) {
			if (tokens[i].getKind() == kind && !tokens[i].isStringOrChar)
				return i;
		}
		return -1;
	}

	/**
	 * 
	 * @param string
	 * @return
	 */
	public int indexOfVal(String string) {
		return indexOfVal(string, 0);
	}

	/**
	 * 
	 * @param string
	 * @param fromIndex
	 * @return
	 */
	public int indexOfVal(String string, int fromIndex) {
		for (int i = fromIndex; i < length(); i++) {
			if (tokens[i].getVal().equals(string) && !tokens[i].isStringOrChar)
				return i;
		}
		return -1;
	}

	/**
	 * same getToken.
	 * 
	 * @param i
	 * @return
	 */
	public Token get(int i) {
		return tokens[i];
	}

	int counter = 0;

	/**
	 * 
	 * @param i
	 * @return
	 */
	public Token getToken(int i) {
		return tokens[i];
	}

	/**
	 * 
	 * @param i
	 * @return
	 */
	public String getVal(int i) {
		return get(i).getVal();
	}

	/**
	 * 
	 * @param i
	 * @return
	 */
	public int getKind(int i) {
		return get(i).getKind();
	}

	/**
	 * 
	 * @param i
	 * @param j
	 * @return
	 */
	public TokenArray subArray(int from, int end) {
		Token[] tt = new Token[end - from];
		System.arraycopy(tokens, from, tt, 0, tt.length);
		return new TokenArray(tt);
	}

	/**
	 * 
	 * @param i
	 * @return
	 */
	public TokenArray subArray(int from) {
		return subArray(from, length());
	}

	/**
	 * @param ts
	 * @param word
	 * @return
	 */
	public static int indexOfKind(Token[] ts, int kind) {
		return indexOfKind(ts, kind, 0);
	}

	public static int indexOfKind(Token[] ts, int kind, int from) {
		for (int i = from; i < ts.length; i++) {
			if (ts[i].getKind() == kind && !ts[i].isStringOrChar)
				return i;
		}
		return -1;
	}

	public static int indexOfVal(Token[] ts, String val) {
		return indexOfVal(ts, val, 0);
	}

	public static int indexOfVal(Token[] ts, String val, int from) {
		for (int i = from; i < ts.length; i++) {
			if (ts[i].getVal().equals(val) && !ts[i].isStringOrChar)
				return i;
		}
		return -1;
	}

	public static Token[] subArray(Token[] ts, int from, int end) {
		Token[] tt = new Token[end - from];
		System.arraycopy(ts, from, tt, 0, tt.length);
		return tt;
	}

	public static Token[] subArray(Token[] ts, int from) {
		return subArray(ts, from, ts.length);
	}

	/**
	 * 
	 * @param ts
	 * @param i
	 * @param j
	 * @return
	 */
	public static Token[] removeArray(Token[] ts, int from, int end) {
		Token[] tt = new Token[ts.length - end + from];
		System.arraycopy(ts, 0, tt, 0, from);
		System.arraycopy(ts, end, tt, from, tt.length - from);
		return tt;
	}

	/**
	 * @param ts
	 * @param i
	 * @return
	 */
	public static Token[] removeArray(Token[] ts, int from) {
		Token[] tt = new Token[from];
		System.arraycopy(ts, 0, tt, 0, from);
		return tt;
	}
	
	

	/**
	 * 
	 * @param tokens2
	 */
	public void addArray(Token[] ts) {

		if (ts.length == 0)
			return;

		if (tokens.length > ts.length + length()) {
			System.arraycopy(ts, 0, tokens, length(), ts.length);
			length += ts.length;
		} else {
			Token[] ts2 = new Token[tokens.length];
			System.arraycopy(tokens, 0, ts2, 0, tokens.length);
			tokens = new Token[ts2.length + addLength];
			System.arraycopy(ts2, 0, tokens, 0, ts2.length);
			addArray(ts);
		}
	}

	/**
	 * 
	 * @param tokens2
	 */
	public void addArray(TokenArray ta) {
		addArray(ta.tokens);
	}

	/**
	 * @param i
	 * @return
	 */
	public boolean isLiteral(int i) {
		return get(i).isStringOrChar;
	}

	/**
	 * 
	 * @param ts
	 * @param word
	 * @return
	 */
	public static int howManyOfKind(Token[] ts, int kind) {
		int index = -1;
		int num = -1;
		do {
			num++;
			index = indexOfKind(ts, kind, index + 1);
		} while (index != -1);
		return num;
	}

	/**
	 * @param string
	 * @param string2
	 * @return
	 */
	public int indexOfVal(String string, String string2) {
		return indexOfVal(string, string2, 0);
	}

	public int indexOfVal(String string, String string2, int ind) {
		int index = ind - 1;
		do {
			index = indexOfVal(string, index + 1);
			if (index == -1 || index == length() - 1)
				return -1;
		} while (!getVal(index + 1).equals(string2));

		return index;
	}

	/**
	 * @param string
	 * @param string2
	 * @param string3
	 * @return
	 */
	public int indexOfVal(String string, String string2, String string3) {
		int index = -1;

		do {
			index = indexOfVal(string, string2, index + 1);
			if (index == -1 || index >= length() - 2)
				return -1;
		} while (!getVal(index + 2).equals(string3));

		return index;
	}

	/**
	 * 
	 * @param i
	 * @param j
	 * @return
	 */
	public TokenArray takeSubArray(int from, int to) {
		TokenArray ta = subArray(from, to);
		length = length() + from - to;
		tokens = removeArray(tokens, from, to);
		return ta;
	}

	/**
	 * @param i
	 * @param j
	 * @return
	 */
	public TokenArray takeSubArray(int from) {
		return takeSubArray(from, length());
	}

	public String toString() {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length(); i++) {
			sb.append(tokens[i].getVal());
			sb.append(" ");
		}
		return sb.toString();
	}

	/**
	 * 
	 * @param string
	 * @return
	 */
	public int howManyOfVal(String val) {
		int index = -1;
		int num = -1;
		do {
			num++;
			index = indexOfVal(val, index + 1);
		} while (index != -1);
		return num;
	}

	public void setToken(Token t, int index) {
		tokens[index] = t;
	}

	public void setToken(String val, int type, int index) {
		Token t = new Token(type, val);
		t.lineNo = tokens[index].lineNo;
		t.isStringOrChar = tokens[index].isStringOrChar;
		tokens[index] = t;
	}

	public void deleteThisVal(String name) {
		if (indexOfVal(name) == -1)
			return;
		Token[] temp = new Token[length];
		int index = 0;
		int tempLength = 0;
		for (int i = 0; i < length; i++) {
			if (!tokens[i].getVal().equals(name)) {
				temp[index++] = tokens[i];
				tempLength++;
			}
		}
		tokens = temp;
		length = tempLength;
	}

	public void pushToken(Token t) {
		if (tokens.length == length()) {
			Token[] ts=new Token[tokens.length+addLength];
			System.arraycopy(tokens, 0, ts, 0, length());
			tokens=ts;
		}
		tokens[length()]=t;
		length++;
	}
	
	/**
	 * @param t
	 */
	public void insertIntoFirstToken(Token t){
		if ((tokens.length-1) >= length()) {
			Token[] ts=new Token[tokens.length+addLength];
			System.arraycopy(tokens, 0, ts, 1, length()+1);
			tokens=ts;
		}else{
			Token[] ts=new Token[tokens.length];
			System.arraycopy(tokens, 0, ts, 1, length()+1);
			tokens=ts;
		}
		tokens[0]=t;
		length++;
	}

	public void insertIntoTokens(Token[] insertTokens, int fromindex) {
		Token[] ta1=takeSubArray(fromindex).tokens;
		Token[] ta2=takeSubArray(0, fromindex).tokens;
		Token[] newTokens=new Token[insertTokens.length+ta1.length+ta2.length];
		System.arraycopy(ta2, 0, newTokens, 0, ta2.length);
		System.arraycopy(insertTokens, 0, newTokens, ta2.length, insertTokens.length);
		System.arraycopy(ta1, 0, newTokens, (ta2.length+insertTokens.length), ta1.length);
		
		tokens=newTokens;
		length=tokens.length;
	}
	
	
	public void removeFrom(int from) {
		Token[] tt = new Token[from];
		System.arraycopy(tokens, 0, tt, 0, from);
		tokens=tt;
		length=tokens.length;
	}

}