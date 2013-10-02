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
package org.kikaineko.ssu;

import java.util.ArrayList;
import java.util.Arrays;

import org.kikaineko.util.FileIO;

/**
 * 
 * @author Masayuki Ioki
 *
 */
public class Analyzer {

	public static void analyze(String expectedFile, String resultFile,
			String name) throws Exception {
		ArrayList resultlines = cleaned(FileIO.getFileDatas(resultFile,
				FileIO.FileReadCode));
		ArrayList tempResult = new ArrayList();
		for (int i = 0; i < resultlines.size(); i++) {
			String s = (String) resultlines.get(i);
			if (!tempResult.contains(s)) {
				tempResult.add(s);
			}
		}

		int[] results = new int[tempResult.size()];
		for (int i = 0; i < tempResult.size(); i++) {
			results[i] = Integer.parseInt((String) tempResult.get(i));
		}
		ArrayList expectedlines = cleaned(FileIO.getFileDatas(expectedFile,
				FileIO.FileReadCode));
		if (expectedlines.size() == 0) {
			return;
		}
		int[] expecteds = new int[expectedlines.size()];
		for (int i = 0; i < expectedlines.size(); i++) {
			expecteds[i] = Integer.parseInt((String) expectedlines.get(i));
		}
		Arrays.sort(results);
		Arrays.sort(expecteds);
		StringBuffer sb = new StringBuffer();
		float cnt = 0;
		for (int i = 0; i < expecteds.length; i++) {
			if (!isInclude(results, expecteds[i])) {
				cnt++;
				sb.append(expecteds[i] + " ");
			}
		}
		float doneLines = expecteds.length - cnt;
		result(sb, doneLines, expectedlines.size(), name);
	}

	private static ArrayList cleaned(ArrayList fileDatas) {
		ArrayList tmp = new ArrayList();
		for (int i = 0; i < fileDatas.size(); i++) {
			if (fileDatas.get(i) != null
					&& ((String) fileDatas.get(i)).length() != 0) {
				tmp.add(fileDatas.get(i));
			}
		}
		return tmp;
	}

	protected static void result(StringBuffer sb, float doneLines, int max,
			String name) {
		int rate = (int) (((doneLines) / max) * 100);
		System.out.println("==Coverage Report.==========================");
		if (sb.length() > 0) {
			System.out.println(name);
			System.out.println(rate + "% passed!(" + (int) (doneLines) + "/"
					+ max + "[passedCommandLines/allCommandLines])");
			if (max - doneLines > 1) {
				System.out.println("below lines unpassed.");
			} else {
				System.out.println("below line unpassed.");
			}
			System.out.println(sb.toString().trim() + ".");
		} else {
			System.out.println("100%! perfect!!(" + (int) (doneLines) + "/"
					+ max + "[passedCommandLines/allCommandLines])");
		}
		System.out.println("============================================");
	}

	private static final boolean isInclude(int[] arr, int count) {
		int flag = arr.length / 2;
		if (flag >= count) {
			for (int i = 0; i < arr.length; i++) {
				if (arr[i] > count) {
					return false;
				} else if (arr[i] == count) {
					return true;
				}
			}
		} else {
			for (int i = arr.length - 1; i >= 0; i--) {
				if (arr[i] < count) {
					return false;
				} else if (arr[i] == count) {
					return true;
				}
			}
		}
		return false;
	}

}
