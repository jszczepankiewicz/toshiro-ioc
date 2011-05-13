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
	import __AS3__.vec.Vector;
	
	import org.toshiroioc.ContainerError;
	
	/**
	 * @author Jaroslaw Szczepankiewicz
	 * @since 2010-01-15
	 * 
	 * Container class used to represent xml configuration for some identyfied by id bean, 
	 * initialized object and all dependencies. Used mainly to resolve
	 * graph dependencies.
	 */
	public class DINode{
		//private var dependencies:Array = new Array();
		private var dependentNode:Array = new Array();
		
		private var xmlContent:XML;
		private var initializedObject:*;
		private var objectID:String;
		
		private var _isDependency:Boolean;
		
		public function get id():String{
			return objectID;
		}
		
		public function DINode(xmlC:XML = null, initializedObject:* = null, id:String = null, postponedInitialization:Boolean = false):void{
			
			if(initializedObject != null){
				//	we have already initialized object
				this.initializedObject = initializedObject;
				this.objectID = id;
				this.xmlContent = xmlC; //CHANGE
			}
			else if(postponedInitialization){
				//	initialization postponed to later (after obtaining xml)
				this.objectID = id;
			}
			else{
				//	we have xml content now	
				xmlContent = xmlC;
				this.objectID = xmlC.attribute("id");
				
			}
						
		}
		
		public function get object():*{
			return initializedObject;
		}
		
		public function updateInitializedObject(object:*):void{
			this.initializedObject = object;
		}
		
		internal function updateXml(xml:XML):void{
			xmlContent = xml;
		}
		
		public function get xml():XML{
			return xmlContent;
		}
		
		public function addNodeDependency(node:DINode):void{
			
			dependentNode.push(node);
		}
		
		/*public function addDependency(objectID:String):void{
			dependencies.push(objectID);
		}*/
		
		/*public function getDependencies():Array{
			return dependencies;
		}*/	
		
		/**
		 * TODO: refactor to speed up (maybe using only strings instead of objects)
		 */
		private function nodeFound(collection:Vector.<DINode>, searchedNode:DINode):Boolean{
			var searchedID:String = searchedNode.id;
			for each(var node:DINode in collection){
				if(node.id == searchedID){
					return true;
				}
			}
			return false;
		}
		
		private function removeFromArray(collection:Vector.<DINode>, nodeToRemove:DINode):void{
			var counter:Number = 0.0;
			var searched:String = nodeToRemove.id;
			
			for each(var node:DINode in collection){
				if(node.id == searched){
					collection.splice(counter, 1);
					return;
				}
				counter++;
			}
		}
		
		public function resolve(resolved:Vector.<DINode>, unresolved:Vector.<DINode>):void{
						
			unresolved.push(this);			
			
			for each(var dependency:DINode in dependentNode){
				
				//	check if already resolved	
				if(!nodeFound(resolved, dependency)){
					//	checking for circular dependency
					if(nodeFound(unresolved, dependency)){
						throw new ContainerError("Circular dependency found between objects: " + this.id + " and " + dependency.objectID, 0, ContainerError.ERROR_CYCLIC_DEPENDENCY);
					}					
					
					dependency.resolve(resolved, unresolved);					
				}
			}
			
			resolved.push(this);
			//	remove from unresolved
			removeFromArray(unresolved, this);
			
		}	

		public function get isDependency():Boolean
		{
			return _isDependency;
		}

		public function set isDependency(value:Boolean):void
		{
			_isDependency = value;
		}

	}
}