/*
 * 作成日： 2005/02/06
 *
 * TODO この生成されたファイルのテンプレートを変更するには次を参照。
 * ウィンドウ ＞ 設定 ＞ Java ＞ コード・スタイル ＞ コード・テンプレート
 */
package org.kikaineko.ssu.sourcescan;

import org.kikaineko.ssu.source.util.TokenKind;
import org.kikaineko.ssu.sourcescan.TokenAutomaton;

import junit.framework.TestCase;

/**
 * @author masayuki
 *
 */
public class TokenAutomatonTest extends TestCase {
	TokenAutomaton ta;

	/*
	 * @see TestCase#setUp()
	 */
	protected void setUp() throws Exception {
		super.setUp();
		ta=new TokenAutomaton();
	}
	
	public void testSharpe(){
		assertEquals(false,ta.isToken(' '));
		assertEquals(false,ta.isToken(' '));
		assertEquals(true,ta.isToken('#'));
		assertEquals(TokenKind.Kuuhaku,ta.getState());
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenKind.Sharpe,ta.getState());
		assertEquals(false,ta.isToken('a'));
		assertEquals(TokenKind.Word,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('#'));
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenKind.Sharpe,ta.getState());
		assertEquals(false,ta.isToken('a'));
		assertEquals(TokenKind.Word,ta.endState());
	}
	
	public void testCommentOpen(){
		assertEquals(false,ta.isToken('p'));
		assertEquals(true,ta.isToken(' '));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Kuuhaku,ta.getState());
		assertEquals(true,ta.isToken('/'));
		assertEquals(false,ta.isToken('*'));
		assertEquals(TokenAutomaton.Number,ta.getState());
		assertEquals(TokenAutomaton.CommentOpen,ta.endState());
	}
	public void testLineComment(){
		assertEquals(false,ta.isToken('p'));
		assertEquals(true,ta.isToken(' '));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Kuuhaku,ta.getState());
		assertEquals(true,ta.isToken('/'));
		assertEquals(false,ta.isToken('/'));
		assertEquals(TokenAutomaton.Number,ta.getState());
		assertEquals(TokenAutomaton.LineComment,ta.endState());
	}
	
	public void testCommentClose(){
		assertEquals(false,ta.isToken('p'));
		assertEquals(true,ta.isToken(' '));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Kuuhaku,ta.getState());
		assertEquals(true,ta.isToken('*'));
		assertEquals(false,ta.isToken('/'));
		assertEquals(TokenAutomaton.Number,ta.getState());
		assertEquals(TokenAutomaton.CommentClose,ta.endState());
	}
	
	public void testIsToken(){
		assertEquals(false,ta.isToken('p'));
		assertEquals(true,ta.isToken(' '));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Kuuhaku,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
	}
	
	public void testIsToken1(){
		assertEquals(false,ta.isToken('p'));
		assertEquals(true,ta.isToken(' '));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Kuuhaku,ta.getState());
		assertEquals(false,ta.isToken('1'));
		
		assertEquals(TokenAutomaton.Number,ta.endState());
	}
	
	public void testShiki(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(false,ta.isToken('1'));

		assertEquals(TokenAutomaton.Number,ta.endState());
	}
	
	public void testKanma(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken(','));
		assertEquals(true,ta.isToken('j'));
		assertEquals(TokenKind.Kanme,ta.getState());
		
		assertEquals(TokenAutomaton.Word,ta.endState());
	}
	
	public void testDoll(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('$'));
		assertEquals(true,ta.isToken('j'));
		assertEquals(TokenKind.Doller,ta.getState());
		
		assertEquals(TokenAutomaton.Word,ta.endState());
	}
	
	public void testSeki(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('*'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Star,ta.getState());
		assertEquals(false,ta.isToken('1'));
		
		assertEquals(TokenAutomaton.Number,ta.endState());

	}
	
	public void testShou(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('/'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Slash,ta.getState());
		assertEquals(false,ta.isToken('1'));
		
		assertEquals(TokenAutomaton.Number,ta.endState());

	}
	
	public void testTasuHiku(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('+'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Plus,ta.getState());
		assertEquals(false,ta.isToken('1'));
		
		assertEquals(TokenAutomaton.Number,ta.endState());
		ta=null;
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('-'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Minus,ta.getState());
		assertEquals(false,ta.isToken('1'));
		
		assertEquals(TokenAutomaton.Number,ta.endState());

	}

	public void testPPMMKakeKake(){
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('+'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(false,ta.isToken('+'));
		
		assertEquals(TokenAutomaton.PP,ta.endState());
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('-'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(false,ta.isToken('-'));
		
		assertEquals(TokenAutomaton.MM,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('='));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.Eq,ta.getState());
		assertEquals(true,ta.isToken('*'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(false,ta.isToken('*'));
		assertEquals(true,ta.isToken('2'));
		assertEquals(TokenAutomaton.DoubleStar,ta.getState());
		assertEquals(false,ta.isToken('0'));
		
		assertEquals(TokenAutomaton.Number,ta.endState());
	}
	
	public void testKakko(){
		assertEquals(false,ta.isToken('('));
		assertEquals(true,ta.isToken('x'));
		assertEquals(TokenAutomaton.OpenKakko,ta.getState());
		assertEquals(true,ta.isToken(')'));
		assertEquals(TokenAutomaton.Word,ta.getState());

		assertEquals(TokenAutomaton.CloseKakko,ta.endState());
	}
	
	public void testPiriod(){
		assertEquals(false,ta.isToken('a'));
		assertEquals(false,ta.isToken('i'));
		assertEquals(true,ta.isToken('.'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(true,ta.isToken('u'));
		assertEquals(TokenAutomaton.Piriod,ta.getState());

		assertEquals(TokenAutomaton.Word,ta.endState());
	}
	
	public void testSankouEnzan(){
		assertEquals(false,ta.isToken('a'));
		assertEquals(true,ta.isToken('?'));
		assertEquals(true,ta.isToken('b'));
		assertEquals(TokenKind.Quest,ta.getState());
		assertEquals(true,ta.isToken(':'));
		assertEquals(true,ta.isToken('c'));
		assertEquals(TokenKind.Koron,ta.getState());
		
	}
	
	public void testSemiKoron(){
		assertEquals(false,ta.isToken('a'));
		assertEquals(false,ta.isToken('h'));
		assertEquals(true,ta.isToken(';'));
		assertEquals(TokenKind.SemiKoron,ta.endState());
		
	}
	
	public void testDoubleQSingleQ(){
		assertEquals(false,ta.isToken('\"'));
		assertEquals(true,ta.isToken('i'));
		assertEquals(TokenAutomaton.DoubleQ,ta.getState());
		assertEquals(true,ta.isToken('\"'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(TokenAutomaton.DoubleQ,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('\''));
		assertEquals(true,ta.isToken('i'));
		assertEquals(TokenAutomaton.SingleQ,ta.getState());
		assertEquals(true,ta.isToken('\''));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(TokenAutomaton.SingleQ,ta.endState());
	}
	
	public void testEsc(){
		assertEquals(false,ta.isToken('\"'));
		assertEquals(true,ta.isToken('i'));
		assertEquals(TokenAutomaton.DoubleQ,ta.getState());
		assertEquals(false,ta.isToken('\\'));
		assertEquals(false,ta.isToken('\"'));
		assertEquals(false,ta.isToken('o'));
		assertEquals(true,ta.isToken('\"'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(TokenAutomaton.DoubleQ,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('\"'));
		assertEquals(true,ta.isToken('i'));
		assertEquals(TokenAutomaton.DoubleQ,ta.getState());
		assertEquals(false,ta.isToken('\\'));
		assertEquals(false,ta.isToken('\''));
		assertEquals(false,ta.isToken('o'));
		assertEquals(true,ta.isToken('\"'));
		assertEquals(TokenAutomaton.Word,ta.getState());
		assertEquals(TokenAutomaton.DoubleQ,ta.endState());
	}
	
	public void testArray(){
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('['));
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.ArrayOpen,ta.getState());
		assertEquals(false,ta.isToken('0'));
		assertEquals(true,ta.isToken(']'));
		assertEquals(TokenAutomaton.Number,ta.getState());
		assertEquals(TokenAutomaton.ArrayClose,ta.endState());
	}
	
	public void testAmari(){
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('%'));
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.Amari,ta.getState());
		
		assertEquals(TokenAutomaton.Number,ta.endState());
	}
	
	public void testBitEnzan(){
		assertEquals(false,ta.isToken('>'));
		assertEquals(false,ta.isToken('>'));
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenKind.BitMigiShift,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('>'));
		assertEquals(false,ta.isToken('>'));
		assertEquals(false,ta.isToken('>'));
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenKind.BitMigiShiftWithZero,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('<'));
		assertEquals(false,ta.isToken('<'));
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenKind.BitHidariShift,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('~'));
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenKind.Tiruda,ta.getState());
		
	}
	
	public void testBlock(){
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('{'));
		assertEquals(true,ta.isToken('1'));
		assertEquals(TokenAutomaton.BlockOpen,ta.getState());
		assertEquals(false,ta.isToken('0'));
		assertEquals(true,ta.isToken('}'));
		assertEquals(TokenAutomaton.Number,ta.getState());
		assertEquals(TokenAutomaton.BlockClose,ta.endState());
	}
	
	public void testWithSharpe(){
		assertEquals(false,ta.isToken('c'));
		assertEquals(false,ta.isToken('s'));
		assertEquals(false,ta.isToken('#'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.WithSharpe,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('1'));
		assertEquals(false,ta.isToken('2'));
		assertEquals(false,ta.isToken('#'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.WithSharpe,ta.getState());
	
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('-'));
		assertEquals(false,ta.isToken('#'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.WithSharpe,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken(' '));
		assertEquals(true,ta.isToken('#'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.Sharpe,ta.getState());
		
	}
	public void testSaikiDainyu(){
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('+'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.SaikiWa,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('-'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.SaikiSa,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('*'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.SaikiSeki,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('/'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.SaikiShou,ta.getState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('%'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.SaikiAmari,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
	}
	
	public void testCond(){
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('='));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.CondEq,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('!'));
		assertEquals(true,ta.isToken('a'));
		assertEquals(TokenAutomaton.Bikkuri,ta.getState());
		assertEquals(false,ta.isToken('h'));
		assertEquals(TokenAutomaton.Word,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('!'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.CondNotEq,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('<'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.CondLT,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('<'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.CondLE,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('>'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.CondGT,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('>'));
		assertEquals(false,ta.isToken('='));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.CondGE,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('|'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.SingleBar,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('|'));
		assertEquals(false,ta.isToken('|'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.DoubleBar,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('&'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.SingleAnpa,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('&'));
		assertEquals(false,ta.isToken('&'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenAutomaton.DoubleAnpa,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
		
		ta=new TokenAutomaton();
		assertEquals(false,ta.isToken('c'));
		assertEquals(true,ta.isToken('^'));
		assertEquals(true,ta.isToken('0'));
		assertEquals(TokenKind.Kasa,ta.getState());
		assertEquals(TokenAutomaton.Number,ta.endState());
	}
}
