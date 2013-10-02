/*
 * 作成日： 2005/02/04
 *
 * TODO この生成されたファイルのテンプレートを変更するには次を参照。
 * ウィンドウ ＞ 設定 ＞ Java ＞ コード・スタイル ＞ コード・テンプレート
 */
package org.kikaineko.ssu.sourcescan;

import org.kikaineko.ssu.source.util.Token;
import org.kikaineko.ssu.source.util.TokenKind;
import org.kikaineko.ssu.sourcescan.Tokenizer;

import junit.framework.TestCase;

/**
 * @author masayuki
 * 
 */
public class TokenizerTest extends TestCase {
	public void testWithSharpe(){
		Tokenizer t = new Tokenizer("db2exfmt -# \\");
		assertEquals("db2exfmt", t.nextToken().getVal());
		assertEquals("-#", t.nextToken().getVal());
		assertEquals("\\", t.nextToken().getVal());
		
		t = new Tokenizer("db2exfmt s# \\");
		assertEquals("db2exfmt", t.nextToken().getVal());
		assertEquals("s#", t.nextToken().getVal());
		assertEquals("\\", t.nextToken().getVal());
		
		t = new Tokenizer("db2exfmt 11120# \\");
		assertEquals("db2exfmt", t.nextToken().getVal());
		assertEquals("11120#", t.nextToken().getVal());
		assertEquals("\\", t.nextToken().getVal());
	}
	
	public void testSharpe() {
		Tokenizer t = new Tokenizer("#aa");
		assertEquals("#", t.nextToken().getVal());
		assertEquals("aa", t.nextToken().getVal());
		t = new Tokenizer("    #aa");
		Token tk=t.nextToken();
		assertEquals(TokenKind.Sharpe, tk.getKind());
		assertEquals(false, tk.isStringOrChar);
		
		assertEquals("aa", t.nextToken().getVal());

		t = new Tokenizer("  \"#aa\"");
		assertEquals("\"", t.nextToken().getVal());
		assertEquals("#aa", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
		
		t = new Tokenizer("  '#aa'");
		assertEquals("'", t.nextToken().getVal());
		assertEquals("#", t.nextToken().getVal());
		assertEquals("aa", t.nextToken().getVal());
		assertEquals("'", t.nextToken().getVal());
	}

	public void testAttoMark() {
		Tokenizer t = new Tokenizer("@aho");
		assertEquals("@", t.nextToken().getVal());
		assertEquals("aho", t.nextToken().getVal());

		t = new Tokenizer("hoge@aho");
		assertEquals("hoge", t.nextToken().getVal());
		assertEquals(TokenKind.AttMark, t.nextToken().getKind());
		assertEquals("aho", t.nextToken().getVal());
	}

	public void test空文字() {
		Token tk;
		Tokenizer t = new Tokenizer("\"\"a");
		tk = t.nextToken();
		assertEquals("\"", tk.getVal());
		tk = t.nextToken();
		assertEquals("\"", tk.getVal());
		assertEquals(TokenKind.DoubleQ, tk.getKind());
		tk = t.nextToken();
		assertEquals("a", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());
	}

	public void testComment() {
		Token tk;
		Tokenizer t = new Tokenizer("i=1/*aho*/y //hoge   ");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("1", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals("/*", tk.getVal());
		assertEquals(TokenKind.CommentOpen, tk.getKind());
		assertEquals("aho", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals("*/", tk.getVal());
		assertEquals(TokenKind.CommentClose, tk.getKind());
		assertEquals("y", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals("//", tk.getVal());
		assertEquals(TokenKind.LineComment, tk.getKind());
		assertEquals("hoge", t.nextToken().getVal());
	}

	public void testStringWithKuuhaku() {
		Tokenizer t = new Tokenizer("\" a g\"");
		assertEquals("\"", t.nextToken().getVal());
		assertEquals(" a g", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
	}

	public void testStringWithKuuhaku2() {
		Tokenizer t = new Tokenizer("\" a g\"a");
		assertEquals("\"", t.nextToken().getVal());
		assertEquals(" a g", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
		assertEquals("a", t.nextToken().getVal());
	}

	public void testCharWithKuuhaku() {
		Tokenizer t = new Tokenizer("\' \'\"a g\"");
		assertEquals("\'", t.nextToken().getVal());
		assertEquals(" ", t.nextToken().getVal());
		assertEquals("\'", t.nextToken().getVal());

		assertEquals("\"", t.nextToken().getVal());
		assertEquals("a g", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
	}

	public void testIsNextLast() {
		Tokenizer t = new Tokenizer("i=1");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("1", t.nextToken().getVal());

		t = new Tokenizer("_i=11");
		assertEquals("_i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("11", t.nextToken().getVal());
	}

	public void testGetTokens() {
		Tokenizer t = new Tokenizer("p 1");
		Token[] tk = t.getTokens();
		assertEquals("p", tk[0].getVal());
		assertEquals(TokenKind.Word, tk[0].getKind());
		assertEquals("1", tk[1].getVal());
		assertEquals(TokenKind.Number, tk[1].getKind());

		t = new Tokenizer("p 12");
		tk = t.getTokens();
		assertEquals("p", tk[0].getVal());
		assertEquals(TokenKind.Word, tk[0].getKind());
		assertEquals("12", tk[1].getVal());
		assertEquals(TokenKind.Number, tk[1].getKind());

	}

	public void testTemp() {
		Tokenizer t = new Tokenizer("if(<<		a_0?    >>a:b*=1),;");

		Token tk = t.nextToken();
		assertEquals("if", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("(", tk.getVal());
		assertEquals(TokenKind.OpenKakko, tk.getKind());

		tk = t.nextToken();
		assertEquals("<<", tk.getVal());
		assertEquals(TokenKind.BitHidariShift, tk.getKind());

		tk = t.nextToken();
		assertEquals("a_0", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("?", tk.getVal());
		assertEquals(TokenKind.Quest, tk.getKind());

		tk = t.nextToken();
		assertEquals(">>", tk.getVal());
		assertEquals(TokenKind.BitMigiShift, tk.getKind());

		tk = t.nextToken();
		assertEquals("a", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals(":", tk.getVal());
		assertEquals(TokenKind.Koron, tk.getKind());

		tk = t.nextToken();
		assertEquals("b", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("*=", tk.getVal());
		assertEquals(TokenKind.SaikiSeki, tk.getKind());

		tk = t.nextToken();
		assertEquals("1", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());

		tk = t.nextToken();
		assertEquals(")", tk.getVal());
		assertEquals(TokenKind.CloseKakko, tk.getKind());

		tk = t.nextToken();
		assertEquals(",", tk.getVal());
		assertEquals(TokenKind.Kanme, tk.getKind());

		tk = t.nextToken();
		assertEquals(";", tk.getVal());
		assertEquals(TokenKind.SemiKoron, tk.getKind());
	}

	public void testPrint() {
		Tokenizer t = new Tokenizer("p 1");
		Token tk = t.nextToken();
		assertEquals("p", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());
		tk = t.nextToken();
		assertEquals("1", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());

		t = new Tokenizer("p    11");
		assertEquals("p", t.nextToken().getVal());
		assertEquals("11", t.nextToken().getVal());

	}

	public void testShiki() {
		Tokenizer t = new Tokenizer("i=11");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("11", t.nextToken().getVal());

		t = new Tokenizer("i = 11");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("11", t.nextToken().getVal());
	}

	public void testSeki() {
		Tokenizer t = new Tokenizer("i=x*11");
		Token tk = t.nextToken();
		assertEquals("i", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("=", tk.getVal());
		assertEquals(TokenKind.Eq, tk.getKind());

		tk = t.nextToken();
		assertEquals("x", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("*", tk.getVal());
		assertEquals(TokenKind.Star, tk.getKind());

		tk = t.nextToken();
		assertEquals("11", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());

		t = new Tokenizer("i = x3 * 101");
		tk = t.nextToken();
		assertEquals("i", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("=", tk.getVal());
		assertEquals(TokenKind.Eq, tk.getKind());

		tk = t.nextToken();
		assertEquals("x3", tk.getVal());
		assertEquals(TokenKind.Word, tk.getKind());

		tk = t.nextToken();
		assertEquals("*", tk.getVal());
		assertEquals(TokenKind.Star, tk.getKind());

		tk = t.nextToken();
		assertEquals("101", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());

	}

	public void testShou() {
		Tokenizer t = new Tokenizer("i=x/11");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		Token tk = t.nextToken();
		assertEquals("/", tk.getVal());
		assertEquals(TokenKind.Slash, tk.getKind());

		tk = t.nextToken();
		assertEquals("11", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());
	}

	public void testAmari() {
		Tokenizer t = new Tokenizer("i=x%11");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		Token tk = t.nextToken();
		assertEquals("%", tk.getVal());
		assertEquals(TokenKind.Amari, tk.getKind());

		tk = t.nextToken();
		assertEquals("11", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());
	}

	public void testTasuHiku() {
		Tokenizer t = new Tokenizer("i=x+11");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		Token tk = t.nextToken();
		assertEquals("+", tk.getVal());
		assertEquals(TokenKind.Plus, tk.getKind());

		tk = t.nextToken();
		assertEquals("11", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());

		t = new Tokenizer("i=x-11");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("-", tk.getVal());
		assertEquals(TokenKind.Minus, tk.getKind());

		tk = t.nextToken();
		assertEquals("11", tk.getVal());
		assertEquals(TokenKind.Number, tk.getKind());

		// マイナス
		t = new Tokenizer("-11");
		tk = t.nextToken();
		assertEquals("-", tk.getVal());
		assertEquals(TokenKind.Minus, tk.getKind());
		assertEquals("11", t.nextToken().getVal());
	}

	public void testPPMMKakeKake() {
		Tokenizer t = new Tokenizer("i=x++");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		Token tk = t.nextToken();
		assertEquals("++", tk.getVal());
		assertEquals(TokenKind.PP, tk.getKind());

		t = new Tokenizer("i=x--");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("--", tk.getVal());
		assertEquals(TokenKind.MM, tk.getKind());

		t = new Tokenizer("i=x**20");
		assertEquals("i", t.nextToken().getVal());
		assertEquals("=", t.nextToken().getVal());
		assertEquals("x", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("**", tk.getVal());
		assertEquals(TokenKind.DoubleStar, tk.getKind());

		assertEquals("20", t.nextToken().getVal());

	}

	public void testKakko() {
		Tokenizer t = new Tokenizer("(x/i)");
		Token tk = t.nextToken();
		assertEquals("(", tk.getVal());
		assertEquals(TokenKind.OpenKakko, tk.getKind());
		assertEquals("x", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("/", tk.getVal());
		assertEquals(TokenKind.Slash, tk.getKind());
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(")", tk.getVal());
		assertEquals(TokenKind.CloseKakko, tk.getKind());

		t = new Tokenizer("(x+11)");
		tk = t.nextToken();
		assertEquals("(", tk.getVal());
		assertEquals(TokenKind.OpenKakko, tk.getKind());
		assertEquals("x", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("+", tk.getVal());
		assertEquals(TokenKind.Plus, tk.getKind());
		assertEquals("11", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(")", tk.getVal());
		assertEquals(TokenKind.CloseKakko, tk.getKind());
	}

	public void testPiriod() {
		Tokenizer t = new Tokenizer("aho.get()");
		assertEquals("aho", t.nextToken().getVal());
		Token tk = t.nextToken();
		assertEquals(".", tk.getVal());
		assertEquals(TokenKind.Piriod, tk.getKind());
		assertEquals("get", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("(", tk.getVal());
		assertEquals(TokenKind.OpenKakko, tk.getKind());
		tk = t.nextToken();
		assertEquals(")", tk.getVal());
		assertEquals(TokenKind.CloseKakko, tk.getKind());
	}

	public void testDoubleQSingleQ() {
		Tokenizer t = new Tokenizer("\"aho\"");
		Token tk = t.nextToken();
		assertEquals("\"", tk.getVal());
		assertEquals(TokenKind.DoubleQ, tk.getKind());

		assertEquals("aho", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("\"", tk.getVal());
		assertEquals(TokenKind.DoubleQ, tk.getKind());

		t = new Tokenizer("return \"aa\"");
		assertEquals("return", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
		assertEquals("aa", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
	}

	public void testEsc() {
		Tokenizer t = new Tokenizer("\"ah\\\"o\"");
		Token tk = t.nextToken();
		assertEquals("\"", tk.getVal());
		assertEquals(TokenKind.DoubleQ, tk.getKind());

		assertEquals("ah\\\"o", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("\"", tk.getVal());
		assertEquals(TokenKind.DoubleQ, tk.getKind());

		t = new Tokenizer("ToStringer.get('\'')");
		assertEquals("ToStringer", t.nextToken().getVal());
		assertEquals(".", t.nextToken().getVal());
		assertEquals("get", t.nextToken().getVal());
		assertEquals("(", t.nextToken().getVal());
		assertEquals("'", t.nextToken().getVal());
		assertEquals("\'", t.nextToken().getVal());
		assertEquals("'", t.nextToken().getVal());
		assertEquals(")", t.nextToken().getVal());

		t = new Tokenizer("ToStringer.get('\"')");
		assertEquals("ToStringer", t.nextToken().getVal());
		assertEquals(".", t.nextToken().getVal());
		assertEquals("get", t.nextToken().getVal());
		assertEquals("(", t.nextToken().getVal());
		assertEquals("'", t.nextToken().getVal());
		assertEquals("\"", t.nextToken().getVal());
		assertEquals("'", t.nextToken().getVal());
		assertEquals(")", t.nextToken().getVal());

	}

	public void testArray() {
		Tokenizer t = new Tokenizer("x[10]");
		assertEquals("x", t.nextToken().getVal());
		Token tk = t.nextToken();
		assertEquals("[", tk.getVal());
		assertEquals(TokenKind.ArrayOpen, tk.getKind());

		assertEquals("10", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("]", tk.getVal());
		assertEquals(TokenKind.ArrayClose, tk.getKind());
	}

	public void testBlock() {
		Tokenizer t = new Tokenizer("{aho}");
		Token tk = t.nextToken();
		assertEquals("{", tk.getVal());
		assertEquals(TokenKind.BlockOpen, tk.getKind());
		assertEquals("aho", t.nextToken().getVal());

		tk = t.nextToken();
		assertEquals("}", tk.getVal());
		assertEquals(TokenKind.BlockClose, tk.getKind());
	}

	public void testCond() {
		Tokenizer t = new Tokenizer("i==0");
		assertEquals("i", t.nextToken().getVal());
		Token tk = t.nextToken();
		assertEquals(TokenKind.CondEq, tk.getKind());
		assertEquals("==", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i!=0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.CondNotEq, tk.getKind());
		assertEquals("!=", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i<0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.CondLT, tk.getKind());
		assertEquals("<", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i<=0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.CondLE, tk.getKind());
		assertEquals("<=", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i>0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.CondGT, tk.getKind());
		assertEquals(">", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i>=0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.CondGE, tk.getKind());
		assertEquals(">=", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i|0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.SingleBar, tk.getKind());
		assertEquals("|", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i||0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.DoubleBar, tk.getKind());
		assertEquals("||", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i&0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.SingleAnpa, tk.getKind());
		assertEquals("&", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i  &&  0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.DoubleAnpa, tk.getKind());
		assertEquals("&&", tk.getVal());
		assertEquals("0", t.nextToken().getVal());

		t = new Tokenizer("i  ^  0");
		assertEquals("i", t.nextToken().getVal());
		tk = t.nextToken();
		assertEquals(TokenKind.Kasa, tk.getKind());
		assertEquals("^", tk.getVal());
		assertEquals("0", t.nextToken().getVal());
	}

}
