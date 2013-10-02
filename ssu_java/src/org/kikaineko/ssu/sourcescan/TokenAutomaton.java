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

import org.kikaineko.ssu.source.util.TokenKind;


/**
 * @author Masayuki Ioki
 */
public class TokenAutomaton implements TokenKind{
	
	private int state=Start;
	private int lastState=Start;
	
	public boolean escf=false;
	
	/**
	 * @param c
	 * @return
	 */
	public boolean isToken(char c) {
		if(c=='#' && (state!=Start && state!=Kuuhaku && state!=DoubleQ && state!=SingleQ  && state!=End )){
			state=WithSharpe;
			return false;
		}
		
		if(state==Start)
			start(c);
		else if(state==Word)
			word(c);
		else if(state==Kuuhaku)
			kuuhaku(c);
		else if(state==Number)
			number(c);
		else if(state==Eq)
			eq(c);
		else if(state==Star)
			seki(c);
		else if(state == Slash)
			shou(c);
		else if(state==Plus)
			wa(c);
		else if(state==Minus)
			sa(c);
		else if(state==Esc)
			esc(c);
		else if(state==Bikkuri)
			bikkuri(c);
		else if(state==CondLT)
			condLt(c);
		else if(state==CondGT)
			condGt(c);
		else if(state==SingleBar)
			singleBar(c);
		else if(state==SingleAnpa)
			singleAnpa(c);
		else if(state==Amari)
			amari(c);
		else if(state==BitMigiShift)
			bitMigiShift(c);
		else
			end();
		
		if(state==End){
			start(c);
			return true;
		}
		return false;
	}

	/**
	 * JUnit4
     * @param c
     */
    //private void attmark(char c) {
        //TODO
    //}

	/**
	 * @param c
	 */
	private void bitMigiShift(char c) {
		if(c=='>')
			state=BitMigiShiftWithZero;
		else
			end();
	}


	/**
	 * @param c
	 */
	private void amari(char c) {
		if(c=='=')
			state=SaikiAmari;
		else
			end();
	}

	/**
	 * @param c
	 */
	private void singleAnpa(char c) {
		if(c=='&')
			state=DoubleAnpa;
		else
			end();
	}


	/**
	 * @param c
	 */
	private void singleBar(char c) {
		if(c=='|')
			state=DoubleBar;
		else
			end();
	}

	/**
	 * @param c
	 */
	private void condGt(char c) {
		if(c=='=')
			state=CondGE;
		else if(c=='>')
			state=BitMigiShift;
		else
			end();
	}

	/**
	 * @param c
	 */
	private void condLt(char c) {
		if(c=='=')
			state=CondLE;
		else if(c=='<')
			state=BitHidariShift;
		else
			end();
	}
	/**
	 * @param c
	 */
	private void bikkuri(char c) {
		if(c=='=')
			state=CondNotEq;
		else
			end();
	}

	/**
	 * @param c
	 */
	private void esc(char c) {
		state=Word;
	}
	
	/**
	 * @param c
	 */
	private void sa(char c) {
		if(c=='-'){
			state=MM;
		}else if(c=='='){
			state=SaikiSa;
		}else{
			end();
		}
	}
	/**
	 * @param c
	 */
	private void wa(char c) {
		if(c=='+'){
			state=PP;
		}else if(c=='='){
			state=SaikiWa;
		}else{
			end();
		}
	}
	/**
	 * @param c
	 */
	private void shou(char c) {
		if(c=='=')
			state=SaikiShou;
		else if(c=='*')
			state=CommentOpen;
		else if(c=='/')
			state=LineComment;
		else
			end();
	}
	/**
	 * @param c
	 */
	private void seki(char c) {
		if(c=='*')
			state=DoubleStar;
		else if(c=='=')
			state=SaikiSeki;
		else if(c=='/')
			state=CommentClose;
		else
			end();
	}
	/**
	 * @param c
	 */
	private void eq(char c) {
		if(c=='=')
			state=CondEq;
		else
			end();
	}
	/**
	 * @param c
	 */
	private void number(char c) {
		if(c<'0' || c >'9')
			end();
	}
	private void kuuhaku(char c){
		if(c>' ')
			end();
	}
	private void word(char c){
		int ss=findFirstState(c);
		
		if(ss==Esc)
			state=Esc;
		else if(ss!=Word && ss!=Number){
			end();
		}
		
	}
	
	private void end(){
		lastState=state;
		state=End;
	}
	
	private int findFirstState(char c){
		if(c<=' '){
			return Kuuhaku;
		}else if(c>='0' && c<='9'){
			return Number;
		}else if(c=='='){
			return Eq;
		}else if(c=='*'){
			return Star;
		}else if(c=='/'){
			return Slash;
		}else if(c=='+'){
			return Plus;
		}else if(c=='-'){
			return Minus;
		}else if(c=='('){
			return OpenKakko;
		}else if(c==')'){
			return CloseKakko;
		}else if(c=='.'){
			return Piriod;
		}else if(c=='\"'){
			return DoubleQ;
		}else if(c=='\''){
			return SingleQ;
		}else if(c=='\\'){
			return Esc;
		}else if(c=='['){
			return ArrayOpen;
		}else if(c==']'){
			return ArrayClose;
		}else if(c=='{'){
			return BlockOpen;
		}else if(c=='}'){
			return BlockClose;
		}else if(c=='!'){
			return Bikkuri;
		}else if(c=='<'){
			return CondLT;
		}else if(c=='>'){
			return CondGT;
		}else if(c=='|'){
			return SingleBar;
		}else if(c=='&'){
			return SingleAnpa;
		}else if(c=='%'){
			return Amari;
		}else if(c=='^'){
			return Kasa;
		}else if(c=='?'){
			return Quest;
		}else if(c==':'){
			return Koron;
		}else if(c==';'){
			return SemiKoron;
		}else if(c=='~'){
			return Tiruda;
		}else if(c==','){
			return Kanme;
		}else if(c=='$'){
			return Doller;
		}else if(c=='@'){
		    return AttMark;
		}else if(c=='#'){
		    return Sharpe;
		}else{
			return Word;
		}
	}
	
	private void start(char c){
		state=findFirstState(c);
	}
	/**
	 * @return
	 */
	public int getState() {
		return lastState;
	}
	/**
	 * @return
	 */
	public int endState() {
		end();
		return getState();
	}

}
