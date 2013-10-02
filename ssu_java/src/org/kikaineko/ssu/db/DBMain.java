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
package org.kikaineko.ssu.db;

import org.kikaineko.util.FileIO;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class DBMain {

	/**
	 * @param args
	 * @throws Throwable
	 */
	public static void main(String[] args) {
		FileIO.init();
		try {
			if (args.length != 7 && args.length != 8 && args.length != 9
					&& args.length != 10 && args.length != 11) {
				badArgs();
			}
			FileIO.CodeFilePATH = args[0];

			if (args[1].equals("db")) {
				if (args.length == 4
						|| (!args[2].equals(DBCommander.SELECT_COMP)
								&& !args[2]
										.equals(DBCommander.SELECT_COMP_CONV)
										&& !args[2].equals(DBCommander.SELECT_INC)
								&& !args[2].equals(DBCommander.SELECT_INC_CONV)
								&& !args[2]
										.equals(DBCommander.SELECT_COMP_ORDER)
								&& !args[2]
										.equals(DBCommander.SELECT_COMP_ORDER_CONV)
								&& !args[2].equals(DBCommander.COUNT)
								&& !args[2].equals(DBCommander.COUNTNOT)
								&& !args[2].equals(DBCommander.INSERT)
								&& !args[2].equals(DBCommander.DELETE)
								
								
								&& !args[2].equals(DBCommander.QUERY)
								&& !args[2].equals(DBCommander.EXEC)
								
								&& !args[2].equals(DBCommander.SELECTOUT) && !args[2]
								.equals(DBCommander.SELECTTO))) {
					badArgs();
					return;
				}
				if (args.length == 11) {
					DBCommander.exec(args[2], args[3], args[4], args[5],
							args[6], args[7], args[8], args[9], args[10]);
				} else if (args.length == 10) {
					DBCommander.exec(args[2], args[3], args[4], args[5],
							args[6], args[7], args[8], args[9], null);
				} else if (args.length == 9) {
					DBCommander.exec(args[2], args[3], args[4], args[5],
							args[6], args[7], args[8]);
				} else if (args.length == 8) {
					DBCommander.exec(args[2], args[3], args[4], args[5],
							args[6], args[7]);
				} else if (args.length == 7) {
					DBCommander.exec(args[2], args[3], args[4], args[5],
							args[6]);
				} else {
					badArgs();
				}
			}
		} catch (Throwable e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}

	}

	private static void badArgs() {

	}
}
