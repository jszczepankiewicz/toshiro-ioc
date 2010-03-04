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

package org.toshiroioc
{
	public class ContainerError extends Error
	{
		public static const ERROR_UNKNOWN:int = 1;
		public static const ERROR_CYCLIC_DEPENDENCY:int = 2;
		public static const ERROR_OBJECT_NOT_FOUND:int = 3;
		public static const ERROR_INVALID_OBJECT_TYPE:int = 4;
		public static const ERROR_INVALID_STATIC_REFERENCE:int = 5;
		public static const ERROR_REQUIRED_METATAG_NOT_SATISFIED:int = 6;
		public static const ERROR_OBJECT_OF_THE_CLASS_NOT_FOUND:int = 7;
		public static const ERROR_MORE_THAN_ONE_OBJECT_OF_THE_CLASS:int = 8;
		public static const ERROR_MULTIPLE_BEANS_WITH_THE_SAME_ID:int = 9;
		
		private var errorCodeValue:int;
		
		public function ContainerError(message:String="", id:int=0, errorCodeValue:int = ContainerError.ERROR_UNKNOWN)
		{
			super(message, id);
			
			this.errorCodeValue = errorCodeValue;
		}
		
		public function get errorCode():int{
			return errorCodeValue;
		}
		
	}
}