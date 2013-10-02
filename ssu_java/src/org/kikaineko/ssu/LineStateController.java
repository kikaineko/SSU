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
public class LineStateController implements LineKind{
	private static final int First=0;
	private static final int NOT_SKIPPED_RUN_LINE=1;
	private static final int SKIPPED_END_LINE=1;
	private static final int SKIPPED_CASE_LINE=2;
	private static final int NOT_SKIPPED_HERE_DOC_START_LINE=3;
	private static final int SKIPPED_HERE_DOC_IN_LINE=4;
	
	private boolean elifFlag=false;
	
	private LineKindController lineKindController=new LineKindController();
	private int lineState=First;
	public boolean isSkipLine(String line) {
		int kind=lineKindController.whitch(line);
		
		elifFlag=false;
		if(kind==ELIF_LINE){
			elifFlag=true;
			kind=RUN_LINE;
		}
		
		if(lineState==First){
			return fromF(kind);
		}else if(lineState==NOT_SKIPPED_RUN_LINE){
			return fromNSRL(kind);
		}else if(lineState==SKIPPED_CASE_LINE){
			return fromSCL(kind);
		}else if(lineState==SKIPPED_HERE_DOC_IN_LINE){
			if(kind==HERE_DOC_END_LINE){
				lineState=First;
			}
			return false;
		}
		return false;
	}
	
	private boolean fromSCL(int kind) {
		switch (kind) {
		case NULL_LINE:
			lineState=SKIPPED_CASE_LINE;
			return true;
		case RUN_LINE:
			lineState=First;
			return true;
		case RUN_WITH_CONTINUE_LINE:
			lineState=NOT_SKIPPED_RUN_LINE;
			return true;
		case END_LINE:
			lineState=First;
			return true;
		case END_WITH_CONTINUE_LINE:
			lineState=SKIPPED_END_LINE;
			return true;
		case CASE_LINE:
			lineState=SKIPPED_CASE_LINE;
			return true;
		case HERE_DOC_START_LINE:
			lineState=NOT_SKIPPED_HERE_DOC_START_LINE;
			return true;
		}
		return false;
	}

	private boolean fromNSRL(int kind) {
		switch (kind) {
		case NULL_LINE:
			lineState=First;
			return true;
		case RUN_LINE:
			lineState=First;
			return true;
		case RUN_WITH_CONTINUE_LINE:
			lineState=NOT_SKIPPED_RUN_LINE;
			return true;
		case END_LINE:
			lineState=First;
			return true;
		case END_WITH_CONTINUE_LINE:
			lineState=SKIPPED_END_LINE;
			return true;
		case CASE_LINE:
			lineState=SKIPPED_CASE_LINE;
			return true;
		case HERE_DOC_START_LINE:
			lineState=NOT_SKIPPED_HERE_DOC_START_LINE;
			return true;
		}
		return false;
	}

	private boolean fromF(int kind){
		switch (kind) {
		case NULL_LINE:
			return true;
		case RUN_LINE:
			return false;
		case RUN_WITH_CONTINUE_LINE:
			lineState=NOT_SKIPPED_RUN_LINE;
			return false;
		case END_LINE:
			return true;
		case END_WITH_CONTINUE_LINE:
			lineState=SKIPPED_END_LINE;
			return true;
		case CASE_LINE:
			lineState=SKIPPED_CASE_LINE;
			return false;
		case HERE_DOC_START_LINE:
			lineState=NOT_SKIPPED_HERE_DOC_START_LINE;
			return false;
		}
		return false;
	}

	public boolean isElifFlag() {
		return elifFlag;
	}
}
