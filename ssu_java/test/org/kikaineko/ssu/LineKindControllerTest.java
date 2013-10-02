package org.kikaineko.ssu;

import org.kikaineko.ssu.LineKind;
import org.kikaineko.ssu.LineKindController;

import junit.framework.TestCase;

public class LineKindControllerTest extends TestCase implements LineKind {
	LineKindController lineKindController;

	protected void setUp() {
		lineKindController = new LineKindController();
	}

	public void testNullLine() {
		assertEquals(NULL_LINE, lineKindController.whitch(""));
		assertEquals(NULL_LINE, lineKindController.whitch("     "));
		assertEquals(NULL_LINE, lineKindController.whitch("#ddd"));
		assertEquals(NULL_LINE, lineKindController.whitch("	#ddd"));
		assertEquals(NULL_LINE, lineKindController.whitch("		#ddd"));
		assertEquals(NULL_LINE, lineKindController.whitch("	     	#ddd"));

		assertTrue(NULL_LINE != lineKindController.whitch("	a	#ddd"));
	}

	public void testEND() {
		assertEquals(END_LINE, lineKindController.whitch("fi"));
		assertEquals(END_LINE, lineKindController.whitch("fi;aaaa"));
	}

	public void testEND_WITH_CONT() {
		assertEquals(END_WITH_CONTINUE_LINE, lineKindController
				.whitch("fi;   \\"));
		assertTrue(END_WITH_CONTINUE_LINE != lineKindController
				.whitch("fi;   \"\\\""));
	}

	public void testCASE() {
		assertEquals(CASE_LINE, lineKindController.whitch("case"));
		assertEquals(CASE_LINE, lineKindController.whitch("case "));
		assertEquals(CASE_LINE, lineKindController.whitch("case _aa"));
		assertEquals(CASE_LINE, lineKindController.whitch("case;aa"));
		assertTrue(CASE_LINE != lineKindController.whitch("case_aa"));
	}

	public void testContinue() {
		assertEquals(RUN_WITH_CONTINUE_LINE, lineKindController
				.whitch("aaa \\"));
		assertEquals(RUN_WITH_CONTINUE_LINE, lineKindController
				.whitch("case \\"));
	}

	public void testRun() {
		assertEquals(RUN_LINE, lineKindController.whitch("aaa "));
		assertEquals(
				RUN_WITH_CONTINUE_LINE,
				lineKindController
						.whitch("db2exfmt -d ${DB} -g tic -e ${INSTANCE} -n % -s % -w -1 -# 0 -o ${exp_log} \\"));

	}

	public void testHere() {
		assertEquals(HERE_DOC_START_LINE, lineKindController
				.whitch("aaa << EOD"));
		assertEquals("EOD", lineKindController.getHereDocMark());
		assertEquals(HERE_DOC_END_LINE, lineKindController.whitch("EOD"));
		assertNull(lineKindController.getHereDocMark());
		assertEquals(HERE_DOC_START_LINE, lineKindController
				.whitch("aaa <<- EOD2  #888\\"));
		assertEquals("EOD2", lineKindController.getHereDocMark());
		assertEquals(HERE_DOC_IN_LINE, lineKindController
				.whitch("aaa <<- EOD2  #888\\"));
		assertEquals(HERE_DOC_IN_LINE, lineKindController
				.whitch("EOD2 <<- EOD2  #888\\"));
		assertEquals(HERE_DOC_END_LINE, lineKindController.whitch("EOD2"));

	}
}
