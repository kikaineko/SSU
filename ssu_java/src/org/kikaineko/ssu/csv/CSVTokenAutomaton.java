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
class CSVTokenAutomaton {
	private CSVTokenKind state = CSVTokenKind.Start;

	/**
	 * @param c
	 * @return
	 */
	public CSVState isToken(char c) {
		if (state == CSVTokenKind.Start)
			start(c);
		else if (state == CSVTokenKind.ClosedStart)
			closedStart(c);
		else if (state == CSVTokenKind.ClosedEnd)
			closedEnd(c);
		else if (state == CSVTokenKind.Word)
			word(c);
		else if (state == CSVTokenKind.Delimiter)
			start(c);
		else if (state == CSVTokenKind.ClosedWord)
			closedWord(c);
		else
			end();

		if (state == CSVTokenKind.Delimiter) {
			return CSVState.End;
		} else if (state == CSVTokenKind.ClosedStart) {
			return CSVState.NotWord;
		} else if (state == CSVTokenKind.ClosedEnd) {
			return CSVState.NotWord;
		}
		return CSVState.NotYetEnd;
	}

	private void closedStart(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.DoubleQ) {
			closedEnd();
		} else {
			state = CSVTokenKind.ClosedWord;
		}
	}

	private void word(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.Delimiter) {
			end();
		}
	}

	private void closedWord(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.DoubleQ) {
			closedEnd();
		}
	}

	private void closedEnd(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.Delimiter) {
			state = CSVTokenKind.Delimiter;
		}else if(ss==CSVTokenKind.DoubleQ){
			state=CSVTokenKind.ClosedWord;
		}
	}

	private void end() {
		state = CSVTokenKind.Delimiter;
	}

	private void closedEnd() {
		state = CSVTokenKind.ClosedEnd;
	}

	private CSVTokenKind findCharKind(char c) {
		if (c == '\"') {
			return CSVTokenKind.DoubleQ;
		} else if (c == '\t') {
			return CSVTokenKind.Delimiter;
		} else {
			return CSVTokenKind.Word;
		}
	}

	private void start(char c) {
		CSVTokenKind k = findCharKind(c);
		if (k == CSVTokenKind.DoubleQ)
			state = CSVTokenKind.ClosedStart;
		else if (k == CSVTokenKind.Delimiter)
			state = k;
		else
			state = CSVTokenKind.Word;
	}
}
