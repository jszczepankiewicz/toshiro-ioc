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
	import flash.utils.getDefinitionByName;
	
	import org.toshiroioc.ContainerError;
	
	public class CorePropertyEditors implements IPropertyEditor{
		
		public function listPropertyInterests():Array{
			return [
				FieldDescription.FIELD_TYPE_STRING,
				FieldDescription.FIELD_TYPE_BOOLEAN,
				FieldDescription.FIELD_TYPE_NUMBER,
				FieldDescription.FIELD_TYPE_DATE,
				FieldDescription.FIELD_TYPE_COLLECTION,
				FieldDescription.FIELD_TYPE_INT,
				FieldDescription.FIELD_TYPE_UINT,
				FieldDescription.FIELD_TYPE_CLASS,
				];			 
		}
			
		
		public function parseProperty(type:uint,child:XML):*{
			
			switch (type){
				case FieldDescription.FIELD_TYPE_STRING:
					return child.attribute("value").toString();
					break;
					
				case FieldDescription.FIELD_TYPE_BOOLEAN:
					
					var value:String = child.attribute("value").toString().toLowerCase();
					
					if(value == "true"){
						return true;
					}
					else if(value == "false"){
						return false;
					}
					
					throw new ContainerError("Invalid Boolean value for type: [" + type + "], found: [" + value + "]");
					break;
										
				case FieldDescription.FIELD_TYPE_NUMBER:
					return Number(child.attribute("value").toString());
					break;
					
				case FieldDescription.FIELD_TYPE_UINT:
					//TODO: add validation of format
					return uint(child.attribute("value").toString());
					break;
				case FieldDescription.FIELD_TYPE_INT:
					//TODO: add validation of format
					return int(child.attribute("value").toString());
					break;
				/* case FieldDescription.FIELD_TYPE_COLLECTION:
					throw new ContainerError("Unsupported property type: [" + type + "]");
					break; */
					
				case FieldDescription.FIELD_TYPE_DATE:
					return JAXBDate.fromJAXB(child.child("date").toString());
					break;
					
				case FieldDescription.FIELD_TYPE_CLASS:		
					trace(child.attribute("class").toString())			
					return Class(getDefinitionByName(child.attribute("class").toString()));
					break;
				/* case FieldDescription.FIELD_TYPE_VECTOR:
					
					break; */
				
				default:
					throw new ContainerError("Unsupported property type: [" + type + "]");
					break;
			}
			
			return null;				
		}	
		
	}
}