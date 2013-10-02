package org.kikaineko.ssu;

import org.kikaineko.ssu.Analyzer;

import junit.framework.TestCase;

public class AnalyzerTest extends TestCase {
	public void testa() {
		Analyzer.result(new StringBuffer("10 11 "),18,20,"");
	}
}
