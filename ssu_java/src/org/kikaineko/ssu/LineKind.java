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
package org.kikaineko.ssu;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public interface LineKind {
	public static final int NULL_LINE=0;
	public static final int RUN_LINE=1;
	public static final int RUN_WITH_CONTINUE_LINE=2;
	public static final int END_LINE=3;
	public static final int END_WITH_CONTINUE_LINE=4;
	public static final int CASE_LINE=5;
	public static final int HERE_DOC_START_LINE=6;
	public static final int HERE_DOC_END_LINE=7;
	public static final int HERE_DOC_IN_LINE=8;
	public static final int ELIF_LINE=9;
}
