package org.kikaineko.ssu.csv;

import org.kikaineko.ssu.csv.CSVState;
import org.kikaineko.ssu.csv.CSVTokenAutomaton;

import junit.framework.TestCase;

public class CSVTokenAutomatonTest extends TestCase {
	CSVTokenAutomaton aut;
	public void testSimple(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	public void testDQ(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	public void testDQWithNULL(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	public void testDQWITHComma(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	public void testDQ2(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	/*
	public void testDQ(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.End,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	public void testDQWithNULL(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken(','));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.End,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	
	public void testDQWITHComma(){
		aut=new CSVTokenAutomaton();
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.End,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken(','));
		assertEquals(CSVState.NotWord,aut.isToken('\"'));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.NotYetEnd,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('b'));
		assertEquals(CSVState.End,aut.isToken('\"'));
		assertEquals(CSVState.NotWord,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
		assertEquals(CSVState.End,aut.isToken(','));
		assertEquals(CSVState.NotYetEnd,aut.isToken('a'));
	}
	*/
}
