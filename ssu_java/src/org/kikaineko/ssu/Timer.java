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
import java.io.IOException;
import java.util.ArrayList;

import org.kikaineko.util.FileIO;
/**
 * 
 * @author Masayuki Ioki
 *
 */
public class Timer {
	public static void assertAve(String exp,String fname) throws Exception{
		ArrayList list=FileIO.getFileDatas(fname, null);
		ArrayList ls=new ArrayList();
		long sum=0;
		long max=0;
		long min=Long.MAX_VALUE;
		for(int i=0;i<list.size();i++){
			String s=(String)list.get(i);
			if(s==null || s.trim().length()==0){
				continue;
			}
			s=s.trim();
			long l=Long.parseLong(s);
			sum+=l;
			ls.add(new Long(l));
			if(l > max){
				max=l;
			}
			if(l < min){
				min=l;
			}
		}
		double ave=((double)sum)/ls.size();
		double dexp = Double.valueOf(exp).doubleValue();
		if (dexp >= ave) {
			System.out.print(0);
		} else {
			System.out.print(dexp);
		}
		
	}
	public static void report(String flag,String fname) throws Exception{
		ArrayList list=FileIO.getFileDatas(fname, null);
		ArrayList ls=new ArrayList();
		long sum=0;
		long max=0;
		long min=Long.MAX_VALUE;
		for(int i=0;i<list.size();i++){
			String s=(String)list.get(i);
			if(s==null || s.trim().length()==0){
				continue;
			}
			s=s.trim();
			long l=Long.parseLong(s);
			sum+=l;
			ls.add(new Long(l));
			if(l > max){
				max=l;
			}
			if(l < min){
				min=l;
			}
		}
		double ave=((double)sum)/ls.size();
		double d=0;
		for(int i=0;i<ls.size();i++){
			long l=((Long)ls.get(i)).longValue();
			d+=(ave -l)*(ave-l);
		}
		d=d/ls.size();
		double sd=Math.sqrt(d);
		if(flag.equals(".")){
			String s="average = "+ave+" milli sec.\n";
			s+="standard-deviation = "+sd+" milli sec.\n";
			s+="max = "+max+" milli sec.\n";
			s+="min = "+min+" milli sec.\n";
			s+="count = "+ls.size()+"\n";
			System.out.print(s);
		}else if(flag.equals("ave")){
			System.out.print(ave);
		}else if(flag.equals("max")){
			System.out.print(max);
		}else if(flag.equals("min")){
			System.out.print(min);
		}else if(flag.equals("sd")){
			System.out.print(sd);
		}else if(flag.equals("count")){
			System.out.print(ls.size());
		}else{
			throw new Exception("wrong option! "+flag);
		}
	}
	public static void exec(String time, String start, String end,
			String startD, String endD) throws Exception {
		File startF = FileIO.getFile_NotDir(start);
		File endF = FileIO.getFile_NotDir(end);
		File startDF = FileIO.getFile_NotDir(startD);
		File endDF = FileIO.getFile_NotDir(endD);
		if (!startF.exists() || startF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + start+" PATH=>"+startF.getPath());
		}
		if (!endF.exists() || endF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + end+" PATH=>"+endF.getPath());
		}
		if (!startDF.exists() || startDF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + startDF+" PATH=>"+startDF.getPath());
		}
		if (!endDF.exists() || endDF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + endD+" PATH=>"+endDF.getPath());
		}

		long t = Long.parseLong(time);
		long s = startF.lastModified();
		long e = endF.lastModified();
		long sD = startDF.lastModified();
		long eD = endDF.lastModified();
		long d=((e - s) - (eD - sD));
		if(d < 0){
			d=0;
		}
		if (t >= d) {
			System.out.print(0);
		} else {
			System.out.print(d);
		}
	}

	public static void getTime(String start, String end, String startD,
			String endD) throws Exception {
		File startF = FileIO.getFile_NotDir(start);
		File endF = FileIO.getFile_NotDir(end);
		File startDF = FileIO.getFile_NotDir(startD);
		File endDF = FileIO.getFile_NotDir(endD);
		if (!startF.exists() || startF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + start);
		}
		if (!endF.exists() || endF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + endF);
		}
		if (!startDF.exists() || startDF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + startD);
		}
		if (!endDF.exists() || endDF.isDirectory()) {
			throw new IOException("not found or isDirectory? " + endD);
		}

		long s = startF.lastModified();
		long e = endF.lastModified();
		long sD = startDF.lastModified();
		long eD = endDF.lastModified();
		long d=((e - s) - (eD - sD));
		if(d < 0){
			d=0;
		}
		System.out.print(d);

	}
}
