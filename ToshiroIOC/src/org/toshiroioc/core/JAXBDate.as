/*
	Copyright (c) 2010, Jaroslaw Szczepankiewicz
	All rights reserved.

	Redistribution and use in source and binary forms, with or without modification, 
	are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, 
	this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the 
	documentation and/or other materials provided with the distribution.
	Neither the name of the Toshiro-IOC nor the names of its contributors 
	may be used to endorse or promote products derived from this software 
	without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
	OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
	EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.toshiroioc.core
{
	public class JAXBDate{
		
		public static function fromJAXB(dstring:String):Date{
			if(dstring == null){
				return null;
			}
			//"2009-09-20T21:45:49.296+02:00"
			var retval:Date = new Date(
				dstring.substr(0, 4),
				dstring.substr(5, 2),
				dstring.substr(8, 2),
				
				dstring.substr(11, 2),	//	hour
				dstring.substr(14, 2),	//	minute
				dstring.substr(17, 2),	//	seconds
				dstring.substr(20, 3));	//	miliseconds
			//TODO: uwzględnij róznice w czasie otrzymanym a lokalnym!!!
			return retval;
		}
		
		private static function fillZero2(value:Number):String{
			if(value < 10.0){
				return "0" + value.toString();
			}	
			return value.toString();
		}
		
		private static function fillZero3(value:Number):String{
			if(value < 10.0){
				return "00" + value.toString();
			}
			else if(value < 100.0){
				return "0" + value.toString();
			}
			
			return value.toString();
		}
		
		private static function fillZero4(value:Number):String{
			if(value < 10.0){
				return "000" + value.toString();
			}
			else if(value < 100.0){
				return "00" + value.toString();
			}
			else if(value < 1000.0){
				return "0" + value.toString();
			}
			
			return value.toString();
		}
		
		
		/**
		 * FIXME: check the time zone of source date
		 */
		public static function toJAXB(date:Date):String{
			if(date == null){
				return null;
			}
			var retval:String = 
				fillZero4(date.fullYear)+"-"+
				fillZero2(date.month)+"-"+
				fillZero2(date.date)+"T"+
				
				fillZero2(date.hours)	+":"+
				fillZero2(date.minutes)	+":"+
				fillZero2(date.seconds)	+"."+
				fillZero3(date.milliseconds) + "+02:00"
					;
			
			
			return retval;
			
			
		}
		

	}
}