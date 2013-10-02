package org.kikaineko.ssu.db;

import junit.framework.TestCase;

public class MapperTest extends TestCase {
	public static void main(String[] args) {
		System.out.println(Short.valueOf("1"));
		System.out.println(Byte.valueOf("1"));
		System.out.println(Integer.valueOf("1.0"));
		System.out.println(Float.valueOf(" 1.0 "));
		System.out.println(Long.valueOf(" 1 "));
		System.out.println(Double.valueOf(" 1.0"));
		System.out.println(Double.valueOf("   1    "));
		System.out.println(Double.valueOf("1.0").equals(Double.valueOf("1")));
	}
}
