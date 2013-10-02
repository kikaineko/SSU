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
 * 
 * @author Masayuki Ioki
 *
 */
public interface TokenKind {
    /** Starts Automaton */
	public static final int Start = 0;
	/** Ends Automaton */
	public static final int End = -1;
	/** number*/
	public static final int Number = 1;
	/** ' ','\t','\n' */
	public static final int Kuuhaku = 2;
	/** Math symbol*/
	public static final int MathToken = 3;
	/** like variables.*/
	public static final int Word = 4;//
	/** = */
	public static final int Eq=5;// =
	/** * */
	public static final int Star = 6;// *
	/** / */
	public static final int Slash = 7;// /
	/** + */
	public static final int Plus = 8;// +
	/** - */
	public static final int Minus = 9; //-
	/** ++ */
	public static final int PP = 10;//++
	/** -- */
	public static final int MM = 11;//--
	/** ** */
	public static final int DoubleStar = 12;//**
	/** ( */
	public static final int OpenKakko = 13;//(
	/** ) */
	public static final int CloseKakko = 14;//)
	/** . */
	public static final int Piriod = 15;// .
	/** " */
	public static final int DoubleQ = 16;//"
	/** ' */
	public static final int SingleQ = 17;//'
	
	/** escape */
	public static final int Esc = 18; //\
	/** [ */
	public static final int ArrayOpen = 19;//[
	/** ] */
	public static final int ArrayClose = 20;//]
	/** { */
	public static final int BlockOpen = 21;//{
	/** } */
	public static final int BlockClose = 22;//}
	/** == */
	public static final int CondEq = 23;//==
	/** ! */
	public static final int Bikkuri = 24;//!
	/** != */
	public static final int CondNotEq = 25;//!=
	/** <= */
	public static final int CondLE = 26;//<=
	/** < */
	public static final int CondLT = 27;//<
	/** > */
	public static final int CondGT = 28;//>
	/** >= */
	public static final int CondGE = 29;//>=
	/** | */
	public static final int SingleBar = 30;//|
	/** || */
	public static final int DoubleBar = 31;//||
	/** & */
	public static final int SingleAnpa = 32;//&
	/** && */
	public static final int DoubleAnpa = 33;//&&
	/** % */
	public static final int Amari = 34;//%
	/** ^ */
	public static final int Kasa = 35;//^
	/** += */
	public static final int SaikiWa = 36; // +=
	/** -= */
	public static final int SaikiSa = 37;//-=
	/** *= */
	public static final int SaikiSeki = 38; //*=
	/** /= */
	public static final int SaikiShou = 39;///=
	/** %= */
	public static final int SaikiAmari = 40;//%=
	/** ? */
	public static final int Quest = 41; //?
	/** : */
	public static final int Koron = 42; //:
	/** ; */
	public static final int SemiKoron = 43;//;
	/** >> */
	public static final int BitMigiShift = 44;//>>
	/** >>> */
	public static final int BitMigiShiftWithZero = 45;//>>>
	/** << */
	public static final int BitHidariShift = 46;//<<
	/** ~ */
	public static final int Tiruda = 47;//~
	/** , */
	public static final int Kanme = 48;// ,
	/** $ */
	public static final int Doller = 49;//$
	
	/** /* */
	public static final int CommentOpen = 50;// /*
	/** *\/ */
	public static final int CommentClose = 51; // */
	/** // */
	public static final int LineComment = 52; // //
	
	/** string */
	public static final int STring = 53; // string
	/** char */
	public static final int Char = 54; // char
	
	public static final int AttMark=55; //@

	public static final int Sharpe=56; //#
	
	public static final int WithSharpe=57; //like -#,$#
}
