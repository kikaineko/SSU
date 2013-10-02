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

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.kikaineko.util.FileIO;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class Utiler {
	public static void exec(String string, String string2) throws IOException {
		if (string.equals("file-time")) {
			File f = FileIO.getFile_NotDir(string2);
			Date fileDate = new Date(f.lastModified());
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			System.out.print(dateFormat.format(fileDate));
		}
	}

	public static void includeInFile(String str,String fileName) throws Exception{
		String s=FileIO.getFileData(fileName, FileIO.FileReadCode);
		if(s.indexOf(str)!=-1){
			System.out.print(1);
		}else{
			System.out.print(0);
		}
	}
	public static void fileSame(String string, String string2) throws Throwable {
		File f1 = FileIO.getFile_NotDir(string.trim());
		File f2 = FileIO.getFile_NotDir(string2.trim());
		if (f1.length() != f2.length()) {
			File ff=null;
			if(f1.length()==0){
				ff=f1;
			}else if(f2.length()==0){
				ff=f2;
			}
			if(ff!=null && !ff.exists()){
				throw new FileNotFoundException("Not Found "+ff.getName());
			}
			System.out.print(1);
			return;
		}
		
		byte[] bs1 = FileIO.getFileDataAsBytes(f1.getAbsolutePath());
		byte[] bs2 = FileIO.getFileDataAsBytes(f2.getAbsolutePath());
		if (bs1.length != bs2.length) {
			System.out.print(1);
			return;
		}

		for (int i = 0; i < bs1.length; i++) {
			if (bs1[i] != bs2[i]) {
				System.out.print(1);
				return;
			}
		}
		System.out.print(0);
	}

}
