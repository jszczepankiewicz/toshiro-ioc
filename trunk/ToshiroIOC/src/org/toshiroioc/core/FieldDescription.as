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
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	
	public class FieldDescription{
		
		private static var registryKeys:Vector.<String> = new Vector.<String>();
		private static var registryValues:Vector.<Class> = new Vector.<Class>();
		
		public static const FIELD_TYPE_INVALID:uint = 0;
		public static const FIELD_TYPE_NUMBER:uint = 1;
		public static const FIELD_TYPE_STRING:uint = 2;
		public static const FIELD_TYPE_BOOLEAN:uint = 3;
		public static const FIELD_TYPE_DATE:uint = 4;
		public static const FIELD_TYPE_COLLECTION:uint = 5;
		public static const FIELD_TYPE_CUSTOM_OBJECT:uint = 6;
		public static const FIELD_TYPE_UINT:uint	=	7;
		public static const FIELD_TYPE_INT:uint	= 8;
		public static const FIELD_TYPE_CLASS:uint	= 9;
		public static const CONSTRUCTOR_FLAG:uint = 1;
		public static const CONSTRUCTOR_DETECTED:String = "toshiro.constructor.detected";
		
		/**
		 * classDescriptionCache
		 */
		private static var classDescriptionCache:Object = new Object();
		
		private static var registryCache:Array = new Array();		
		
		public static function registerClass(clazz:Class):void{			
			
			registryKeys.push(getQualifiedClassName(clazz));
			registryValues.push(clazz);
		}
		
		public static function resolveShortClassname(shortName:String):ClassRegistryEntry{
			
			
			//	searching the cache
			var cacheResult:Class = registryCache[shortName];
			
			if(cacheResult != null){
				//	found entry in cache
				return new ClassRegistryEntry(cacheResult, false);
			}
			
			var keyIndex:uint = 0;
			
			
			
			//	result not found in cache, should search in registry
			for each (var fullname:String in registryKeys){
				
				var pos:int = fullname.toLowerCase().indexOf(shortName.toLowerCase());
				
				if(pos> -1){
					
					//	TODO: add checking if the type was at the end (now when querying "User", might return
					//	SomeUserOfMachine, which is error	
					var retclazz:Class = registryValues[keyIndex];
					 
					//	saving to the cache
					registryCache[shortName] = retclazz;
					
					return new ClassRegistryEntry(retclazz, false);
				}
				keyIndex++;	
			}
			
			//	checking for indirect collection
			
			if(shortName.charAt(shortName.length-1) == "s"){
				
				keyIndex = 0;
				var multipliedCollectionName:String = shortName.toLowerCase().substr(0,shortName.length-1);
			
				for each (var fullname2:String in registryKeys){
				
					var pos2:int = fullname2.toLowerCase().indexOf(multipliedCollectionName);
				
					if(pos2> -1){
					
						//	TODO: add checking if the type was at the end (now when querying "User", might return
						//	SomeUserOfMachine, which is error	
						var retclazz2:Class = registryValues[keyIndex];
					 	//trace("## found collection of objects: " + retclazz2);
					 	
						return new ClassRegistryEntry(retclazz2, true);						
					}
					keyIndex++;	
				}
			}
			 
			throw new ArgumentError("ClassRegistry can not resolve class for shortname: " + shortName + ", make sure you have registered the class binded to this xml object, and/or you have added collection hint for unmarshaller");
			
		}
		
		/*
		private static function detectConstructorPresence(clazz:Class, fieldsInfo):void{
			
		}
		*/
		
		public static function getClassFieldTypeDescription(clazz:Class):Object{
			//	check if adding cache for getQualifiedClassName speeds up
			var qualifiedClazzName:String = getQualifiedClassName(clazz);
			var fieldsInfo:Object = classDescriptionCache[qualifiedClazzName];
			
			//	detecting the constructor
			
			/*
				constructor looks like:
				 <factory type="org.toshiroioc.test.beans::BeanWithConstructor">
    <extendsClass type="Object"/>
    <constructor>
      <parameter index="1" type="*" optional="false"/>
      <parameter index="2" type="*" optional="false"/>
      <parameter index="3" type="*" optional="false"/>
      <parameter index="4" type="*" optional="false"/>
    </constructor>
    <accessor name="prototype" access="readonly" type="*" declaredBy="Class"/>
			*/
			if(fieldsInfo == null){
				fieldsInfo = new Object();
				
				var classInfo:XML = describeType(clazz);
				
				for each (var variable:XML in classInfo..accessor){
					
					//trace("=== " + variable.@name + " = " + variable.@type.toString());
					switch (variable.@type.toString()){
						
						case ("Number"):
							fieldsInfo[variable.@name] = FIELD_TYPE_NUMBER;
							break;
						case ("int"):						
							fieldsInfo[variable.@name] = FIELD_TYPE_INT;
							
							break;
						case ("uint"):						
							fieldsInfo[variable.@name] = FIELD_TYPE_UINT;
							
							break;
						case ("String"):
							fieldsInfo[variable.@name] = FIELD_TYPE_STRING;
							break;
						
						case ("Boolean"):
							fieldsInfo[variable.@name] = FIELD_TYPE_BOOLEAN;
							break;
						
						case ("Date"):
							fieldsInfo[variable.@name] = FIELD_TYPE_DATE;
							break;
							
						case ("Array"):						
							fieldsInfo[variable.@name] = FIELD_TYPE_COLLECTION;							
							break;	
							
						case ("Class"):
							fieldsInfo[variable.@name] = FIELD_TYPE_CLASS;
							break;
											
						default:
							if(variable.@name.toString() == "prototype"){
								//	ommiting standard prototype field
								continue;
							}
							//	we have custom class, instead of registering some constant
							//	we put here class name
							//trace("classRegistry, putting class: " + variable.@type.toString() + ", into: " + variable.@name); 
							fieldsInfo[variable.@name] = variable.@type.toString();
							break;
					}
					//trace("description of field: " + variable.@type.toString() +", type: " + fieldsInfo[variable.@name] );
				}
				
				//	saving in cache for future use
				classDescriptionCache[qualifiedClazzName] = fieldsInfo;
			}
			
			return fieldsInfo;
		}
		
		
	}
}