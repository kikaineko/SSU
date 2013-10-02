package org.kikaineko.ssu;

import org.kikaineko.ssu.LineStateController;

import junit.framework.TestCase;

public class LineStateControllerTest extends TestCase {
	LineStateController cnt;
	protected void setUp(){
		cnt=new LineStateController();
	}
	
	public void testNormal(){
		assertEquals(true,cnt.isSkipLine("#aaa"));
		assertEquals(false,cnt.isSkipLine("bbb#aaa"));
	}
	public void testPipe(){
		assertEquals(false,cnt.isSkipLine("hoge aaa |"));
		assertEquals(true,cnt.isSkipLine("hoge aaa |"));
		assertEquals(true,cnt.isSkipLine("hoge aaa"));
	}
	
	public void testelif(){
		assertEquals(false,cnt.isSkipLine("bbb#aaa"));
		assertEquals(false,cnt.isSkipLine("if aaa"));
		assertEquals(false,cnt.isSkipLine("echo 333"));
		assertEquals(true,cnt.isSkipLine("  else"));
		assertEquals(false,cnt.isSkipLine("  echo 33"));
		assertEquals(true,cnt.isSkipLine("  fi"));
	}
	
	public void testEsc(){
		assertEquals(false,cnt.isSkipLine("echo 333"));
		assertEquals(false,cnt.isSkipLine("mv aaa \\"));
		assertEquals(true,cnt.isSkipLine("bbb"));
		assertEquals(false,cnt.isSkipLine("bbb"));
		assertEquals(false,cnt.isSkipLine("bbb"));
	}
	
	public void testEscEsc(){
		assertEquals(false,cnt.isSkipLine(">/dev/null 2>&1"));

		assertEquals(false,cnt.isSkipLine("echo 333"));
		assertEquals(false,cnt.isSkipLine("mv aaa \\"));
		assertEquals(true,cnt.isSkipLine("bbb \\"));
		assertEquals(true,cnt.isSkipLine("bbb\\"));
		assertEquals(true,cnt.isSkipLine("bbb"));
		assertEquals(false,cnt.isSkipLine("bbb"));

		assertEquals(false,cnt.isSkipLine("db2exfmt -d ${DB} -g tic -e ${INSTANCE} -n % -s % -w -1 -# 0 -o ${exp_log} \\"));
		assertEquals(true,cnt.isSkipLine(">/dev/null 2>&1"));
	}
}
