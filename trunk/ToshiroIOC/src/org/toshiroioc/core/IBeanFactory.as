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
	/**
	 * Dependency Injection container interface. It should be thread safe (no static variables).
	 * 
	 * @author Jaroslaw Szczepankiewicz
	 * @since 2010-01-15
	 */
	public interface IBeanFactory{
		
		/**
		 * Tells wheter container contains specified bean
		 * 
		 * @param id name of the object (taken from id xml) to be retrieved
		 * @return true if container contains initialized bean specified by id, false otherwise
		 */
		function containsObject(id:String):Boolean;
		
		/**
		 * Returns object identified by id. This method does not check 
		 * the type of returned object.
		 * 
		 * @param id name of the object (taken from id xml) to be retrieved
		 * @param ignoreBeanNotFound if set to true then the container will return null instead of throwing
		 * ContainerError
		 * @return initialized object
		 */
		function getObject(id:String, ignoreBeanNotFound:Boolean = false):*;
		
		/**
		 * Returns object identified by id. This method does
		 * type validation (clazz argument). If the type defined
		 * is not as expected ContainerError is thrown.
		 * 
		 * @param id name of the object (taken from id xml) to be retrieved
		 * @param clazz type to be checked for object
		 * @return initialized bean after type check
		 */
		function getTypedObject(id:String, clazz:Class):*;
		
		/**
		 * Returns type of the object identified by id.
		 * 
		 * @param id name of the object (taken from id xml) to be type checked
		 * @return class of the object identified by id
		 * 
		 */
		function getType(id:String):Class;
		
		/**
		 * Checks whether object is singleton.
		 * 
		 * @param id name of the object (taken from id xml) to be checked for singleton
		 * @return true if object is of type singleton, false if the object is prototype
		 */
		function isSingleton(id:String):Boolean; 	
	}
}