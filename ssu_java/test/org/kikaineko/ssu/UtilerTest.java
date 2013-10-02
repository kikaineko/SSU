package org.kikaineko.ssu;

import java.io.IOException;

import org.kikaineko.ssu.Utiler;

import junit.framework.TestCase;

public class UtilerTest extends TestCase {
public void testMain() throws IOException{
	Utiler.exec("file-time","cl.sh");
}
}
