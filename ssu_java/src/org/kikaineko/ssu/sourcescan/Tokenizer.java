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
package org.kikaineko.ssu.sourcescan;

import java.util.ArrayList;

import org.kikaineko.ssu.source.util.Token;
import org.kikaineko.ssu.source.util.TokenKind;

/**
 * 
 * @author Masayuki Ioki
 *
 */
public class Tokenizer {
	private String st;

	private int index;

	private TokenAutomaton tokenAutomaton;

	private char lastchar = (char) 0;//prevent re-read.

	private boolean hasMore = true;

	private Token[] tk;

	/**
	 * @param string
	 */
	public Tokenizer(String string) {
		st = string;
		index = 0;
		tokenAutomaton = new TokenAutomaton();
		if (st.length() == 0)
			hasMore = true;
		
		makeTokens();
		index=0;
	}

	protected Token nextToken() {
		return tk[index++];
	}

	/**
	 * @return
	 */
	protected Token innerNextToken() {
		StringBuffer sb = new StringBuffer();
		if (lastchar != 0)
			sb.append(lastchar);

		for (int i = index; i < st.length(); i++) {
			char c = st.charAt(i);
			boolean flag = tokenAutomaton.isToken(c);

			if (flag) {
				lastchar = c;
				index = i + 1;
				return new Token(tokenAutomaton.getState(), sb.toString());
			} else {
				sb.append(c);
			}
		}

		hasMore = false;
		return new Token(tokenAutomaton.endState(), sb.toString());
	}

	private void makeTokens() {
		ArrayList vec = new ArrayList();
		while (hasMore()) {
			vec.add(innerNextToken());
		}
		
		boolean isString = false;
		boolean isChar = false;
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < vec.size(); i++) {
			Token t = (Token) vec.get(i);
			if (isString) {
				if (t.getKind() == TokenKind.DoubleQ) {
					isString = false;
					if (sb.length() > 0) {
						vec.add(i,new Token(TokenKind.STring, sb
								.toString()));
						i++;
						sb = new StringBuffer();
					}
				} else {
					sb.append(t.getVal());
					vec.remove(i);
					i--;
				}
			} else if (isChar) {
				if (t.getKind() == TokenKind.SingleQ) {
					isChar = false;
				} else {
					t.setKind(TokenKind.Char);
				}
			} else {
				if (t.getKind() == TokenKind.DoubleQ) {
					isString = true;
				} else if (t.getKind() == TokenKind.SingleQ) {
					isChar = true;
				} else if (t.getKind() == TokenKind.Kuuhaku) {
					vec.remove(i);
					i--;
				}
			}
		}

		tk = new Token[vec.size()];
		for (int i = 0; i < tk.length; i++) {
			tk[i] = (Token) vec.get(i);
		}
	}

	/**
	 * @return
	 */
	public Token[] getTokens() {

		Token[] tks = new Token[tk.length];
		System.arraycopy(tk, 0, tks, 0, tks.length);
		return tks;
	}

	/**
	 * @return
	 */
	private boolean hasMore() {
		return hasMore;
	}
}