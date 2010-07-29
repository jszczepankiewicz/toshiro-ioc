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
	import org.toshiroioc.ContainerError;
	
	/**
	 * @author Jaroslaw Szczepankiewicz
	 * @since 2010-01-16
	 * 
	 * Class used to do class related operations.
	 */
	public class ClassUtil{
		public static function initializeClassWithNonDefConstructor(beanXML:XML, constructorArgs:XMLList, clazz:Class, factory:XMLBeanFactory):*{
			
			var retval:Object;
			var args:uint = constructorArgs.length();
			
			switch(args){
				case 0:
					retval = new clazz();
					break;
					
				case 1:
					retval = new clazz(factory.parseConstructorArgumentValue(constructorArgs[0]));
					break;
				case 2:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1])						
						);
					break;
				case 3:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2])						
						);
					break;
					
				case 4:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3])
						);
					break;
					
				case 5:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4])
						);
					break;
				case 6:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5])
						);
					break;
				case 7:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6])
						);
					break;
				case 8:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7])
						);
					break;
				case 9:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8])
						);
					break;
				case 10:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9])
						);
					break;
				case 11:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10])
						);
					break;
				case 12:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11])
						);
					break;
				case 13:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12])
						);
					break;
				case 14:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13])
					);
					break;
				case 15:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14])
					);
					break;
				case 16:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15])
					);
					break;
				case 17:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16])
					);
					break;
				case 18:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17])
					);
					break;
				case 19:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18])
					);
					break;
				case 20:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19])
					);
					break;
				case 21:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20])
					);
					break;
				case 22:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21])
					);
					break;
				case 23:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22])
					);
					break;
				case 24:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23])
					);
					break;
				case 25:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23]),
						factory.parseConstructorArgumentValue(constructorArgs[24])
					);
					break;
				case 26:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23]),
						factory.parseConstructorArgumentValue(constructorArgs[24]),
						factory.parseConstructorArgumentValue(constructorArgs[25])
					);
					break;
				case 27:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23]),
						factory.parseConstructorArgumentValue(constructorArgs[24]),
						factory.parseConstructorArgumentValue(constructorArgs[25]),
						factory.parseConstructorArgumentValue(constructorArgs[26])
					);
					break;
				case 28:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23]),
						factory.parseConstructorArgumentValue(constructorArgs[24]),
						factory.parseConstructorArgumentValue(constructorArgs[25]),
						factory.parseConstructorArgumentValue(constructorArgs[26]),
						factory.parseConstructorArgumentValue(constructorArgs[27])
					);
					break;
				case 29:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23]),
						factory.parseConstructorArgumentValue(constructorArgs[24]),
						factory.parseConstructorArgumentValue(constructorArgs[25]),
						factory.parseConstructorArgumentValue(constructorArgs[26]),
						factory.parseConstructorArgumentValue(constructorArgs[27]),
						factory.parseConstructorArgumentValue(constructorArgs[28])
					);
					break;
				case 30:
					retval = new clazz(
						factory.parseConstructorArgumentValue(constructorArgs[0]),
						factory.parseConstructorArgumentValue(constructorArgs[1]),
						factory.parseConstructorArgumentValue(constructorArgs[2]),
						factory.parseConstructorArgumentValue(constructorArgs[3]),
						factory.parseConstructorArgumentValue(constructorArgs[4]),
						factory.parseConstructorArgumentValue(constructorArgs[5]),
						factory.parseConstructorArgumentValue(constructorArgs[6]),
						factory.parseConstructorArgumentValue(constructorArgs[7]),
						factory.parseConstructorArgumentValue(constructorArgs[8]),
						factory.parseConstructorArgumentValue(constructorArgs[9]),
						factory.parseConstructorArgumentValue(constructorArgs[10]),
						factory.parseConstructorArgumentValue(constructorArgs[11]),
						factory.parseConstructorArgumentValue(constructorArgs[12]),
						factory.parseConstructorArgumentValue(constructorArgs[13]),
						factory.parseConstructorArgumentValue(constructorArgs[14]),
						factory.parseConstructorArgumentValue(constructorArgs[15]),
						factory.parseConstructorArgumentValue(constructorArgs[16]),
						factory.parseConstructorArgumentValue(constructorArgs[17]),
						factory.parseConstructorArgumentValue(constructorArgs[18]),
						factory.parseConstructorArgumentValue(constructorArgs[19]),
						factory.parseConstructorArgumentValue(constructorArgs[20]),
						factory.parseConstructorArgumentValue(constructorArgs[21]),
						factory.parseConstructorArgumentValue(constructorArgs[22]),
						factory.parseConstructorArgumentValue(constructorArgs[23]),
						factory.parseConstructorArgumentValue(constructorArgs[24]),
						factory.parseConstructorArgumentValue(constructorArgs[25]),
						factory.parseConstructorArgumentValue(constructorArgs[26]),
						factory.parseConstructorArgumentValue(constructorArgs[27]),
						factory.parseConstructorArgumentValue(constructorArgs[28]),
						factory.parseConstructorArgumentValue(constructorArgs[29])
					);
					break;
				default:
					throw new ContainerError("to many constructor arguments (" + args + "), please extend this class...");
			}
				
			return retval;
		}	
	}
}