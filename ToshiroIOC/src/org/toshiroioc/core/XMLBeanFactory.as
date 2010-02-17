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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.toshiroioc.ContainerError;
	
	/**
	 * @author Jaroslaw Szczepankiewicz
	 * @since 2010-01-15
	 * 
	 * Dependency Injection container driven by XML.
	 * 
	 * TODO: add post bean create type safe check, unfortunatelly
	 * actionscript 3 does not allow for constructor arguments
	 * type checking before class instance creation (the method
	 * requires allocated object). To add type safe check do after construct
	 * type check (after creating object check if objects are in valid formats)
	 */
	public class XMLBeanFactory extends EventDispatcher implements IBeanFactory{
		
		private var xmlSource:XML;
		/**
		 * beans map with key as id
		 */
		private var beansMap:Object = new Object();
		
		private var nodes:Object = new Object();
		
		private var prototypesIDList:Vector.<String>  = new Vector.<String>();
		
		private var nodeNames:Vector.<String> = new Vector.<String>();
		
		//	objects that have dependencies on each other, needs to be resolved later
		private var postInitializedBeans:Array = new Array();
		
		internal var unresolvedNodes:Vector.<DINode> = new Vector.<DINode>();
		
		private var propertyEditorsMap:Object = new Object();
		
		public function XMLBeanFactory(xml:XML){			
			xmlSource = xml;		
		}
		
		/**
		 * initializes the container, parse xml. Dispatches Event.COMPLETE 
		 * when it is ready to start
		 */
		public function initialize():void{
			
			
			//	registering built in property editors			
			registerPropertyEditor(new CorePropertyEditors());			
			startContainerParseBeans();
		}
		
		private function parseConstAttribute(constans:String, id:String):*{
				var words:Array = constans.split(".");
				// get static variable name
				var staticVarName:String = words[words.length-1];			
				// get full name of the class (without variable name)
				var fullClassName:String = constans.substring(0, constans.indexOf(staticVarName)-1);
				// get class reference
				var clazz:Class = getDefinitionByName(fullClassName) as Class;
				// get variable value or null, if doesn't exist
				var staticVar:* = clazz[staticVarName];
				if (staticVar)
					return staticVar;
				
				throw new ContainerError("Bean with name: [" + id + "] " + 
						 	"references to nonexistent static field [" + fullClassName + "." + staticVarName + "]", 0, ContainerError.ERROR_INVALID_STATIC_REFERENCE);
		}
		
		internal function parseConstructorArgumentValue(xml:XML):*{
			
			var constans:String = xml.attribute("const");
			var id:String = xml.parent().attribute("id");
			
		 	if (constans.length > 0){
				return parseConstAttribute(constans, id); 
			} 
			
			//	checking for constructor param
			var ref:String = xml.attribute("ref").toXMLString();
			 
			if(ref.length>0){
				
				//	constructor with dependencies
								
				var val2:* = getObject(ref, true);
				
				if(val2 == null){
					throw ArgumentError("beansMap does not contain initialized bean: " + ref);
				}
								
				return val2;
			}
			
			//	checking for special type date
			var dateAsString:* = xml.child("date")[0];
			
			if(dateAsString!=null){
				return JAXBDate.fromJAXB(String(dateAsString));	
			}
			
			
			var val:* = xml.attribute("value")[0];
			
			/*
			 *	we must implicitly convert string representation of false
			 *	into "false" boolean. In case of String field with "false" String
			 *	this works without problems 
			 */
			if(String(val) == "false"){
				return false;	
			}
			
			return val;
		}
				
		/**
		 * retrieves node (if object initialized found then retrieves object, otherways
		 * retrieves 
		 */
		private function getNode(id:String):DINode{
			
			//	check for initialzed DINodes
			var initializedNode:DINode = nodes[id];
			
			if(initializedNode != null){
				//	node found in cache
				return initializedNode;
			}
			
			//	initialized node not found check for initialized objects			
			var initializedObject:* = getObject(id, true);
			
			if(initializedObject != null){
				
				//	node NOT found in node cache but found in object cache
				var nodeWithObject:DINode = new DINode(null, initializedObject, id);
				
				nodeNames.push(id);
				nodes[id] = nodeWithObject;
				return nodeWithObject;
			}
					
			//	node not found in either node & object cache, posponing return
			var node:DINode = new DINode (null, null, id, true);
			nodeNames.push(id);
			
			nodes[id] = node;
			return node;
			 
			
		}
		
		private function hasDependencies(beanXML:XML):Boolean{
			
			//	filtering by optional "ref" attribute
			var propertiesDependent:XMLList = beanXML.child("property").(attribute("ref").toXMLString().length > 0);
			
			if(propertiesDependent.length() > 0){
				
				var depNode:DINode = new DINode(beanXML);
				
				for each (var property:XML in propertiesDependent){	
				
					var dependentS:String = property.attribute("ref");
					
					depNode.addNodeDependency(getNode(dependentS));
				}
				var id:String = beanXML.attribute("id");
				nodes[id] = depNode;
				this.nodeNames.push(id);
								
				return true;
			}
			
			//	TODO: add checking for constructor dependencies
			var constructorDependent:XMLList = beanXML.child("constructor-arg").(attribute("ref").toXMLString().length > 0);
			
			if(constructorDependent.length() > 0){
				var depNode2:DINode = new DINode(beanXML);
				
				for each (var constructor:XML in constructorDependent){	
				
					var dependentS:String = constructor.attribute("ref");					
					depNode2.addNodeDependency(getNode(dependentS));
				}
				var id2:String = beanXML.attribute("id");
				nodes[id2] = depNode2;
				this.nodeNames.push(id2);
				
				return true;
			}
			
			return false;
		}
		
		
		
		
		
		private function initializeBean(beanXML:XML, proceedIfSettingDependencyFound:Boolean = false):Object{
			
			var clazz:Class = getDefinitionByName(beanXML.attribute("class")) as Class;
			
			var retval:Object = null;
			
			//	checking for beans with dependencies
			if((!proceedIfSettingDependencyFound) && hasDependencies(beanXML)){
				//	do nothing
				return null;
			}
			
			var constructorArgs:XMLList = beanXML.child("constructor-arg");
			
			if(constructorArgs.length() > 0){				
				
				retval = ClassUtil.initializeClassWithNonDefConstructor(beanXML, constructorArgs, clazz, this);
			}
			else{
				retval = new clazz();
			}
			
			processBeanProperties(clazz, retval, beanXML.child("property"), proceedIfSettingDependencyFound);
			
			//	refill nodes
			putObjectIntoNodeCache(retval, beanXML);			
			
			return retval;
		}
		
		/**
		 * refill nodes with newly created object
		 */
		private function putObjectIntoNodeCache(object:*, beanXML:XML):void{
			
			var id:String = beanXML.attribute("id")
			
			var node:DINode = nodes[id];
			
			if(node == null){
				node = new DINode(null, object, id);
				
				//	object not found in node cache creating new one				
				nodeNames.push(id);
				
				nodes[id] = node; 
			}
			else{
				//	object found in node cache but we assume that it is not initialized, altering object which was uninitilized				
				node.updateInitializedObject(object);
				
				/*	saving xml in order to be available in case there is prototype 
					prototypes are initialzed from xml
				*/
				node.updateXml(beanXML);
				//	updating the objects
				
				beansMap[id] = object;
			}			
		}
		
		private function startContainerParseBeans():void{
			var beans:XMLList = xmlSource.child("object");
			var beanXML:XML;
			
			for each(beanXML in beans){
				var idString:String = String(beanXML.attribute("id")); 
				
				//	checking for prototype
				if(beanXML.attribute("lifecycle").toXMLString() == "prototype"){
					prototypesIDList.push(idString);
				}
				
				var bean:Object = initializeBean(beanXML);
				
				if(bean!=null){
					beansMap[idString] = bean;
				}
			}			
			
			resolveDependentBeans();
			
			//	dispatch complete event to inform that container is ready
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function processBeanProperties(clazz:Class, bean:*, properties:XMLList, processDependencies:Boolean = false):void{
			var fieldDescriptionMap:Object = FieldDescription.getClassFieldTypeDescription(clazz);
			
			//	initializing			
			
			for each (var property:XML in properties){
				
				//	FIXME: there should be some better way to check existence of attribute
				var refProp:String = property.attribute("ref").toXMLString();
				var propertyName:String = property.attribute("name").toXMLString();
				var constProp:String = property.attribute("const").toXMLString();
				
				if(processDependencies && refProp.length > 0){
					
					//	late initialization for ref property										
					bean[propertyName] = getObject(refProp, true);
					continue;
				}
				
				if(constProp.length>0){
					bean[propertyName] = parseConstAttribute(constProp, property.parent().attribute("id"));
					continue;
				}
				
				
				
				//	checking for implicit null property value
				if(property.child("null").length()!=0){
					bean[propertyName] = null;
					continue;
				}
				
				
								
				var propertyType:uint = fieldDescriptionMap[propertyName];
				
				var editor:IPropertyEditor = propertyEditorsMap[propertyType];
				
				if(editor == null){
					throw new ContainerError("Property editor for property: [" + propertyName + "], type: [" + propertyType);	
				}
				
				bean[propertyName] = editor.parseProperty(propertyType, property);				
				
			}
		}
		
		/**
		 * @param id id from the xml 
		 * @retval initialized bean 
		 */
		public function getObject(id:String, ignoreBeanNotFound:Boolean = false):*{
			var retval:* = beansMap[id];	
			
			if(retval == null){
				if(ignoreBeanNotFound){
					return null;
				}
				
				throw new ContainerError("Bean with id: [" + id + "] not found, make sure there is one in the XML");
			}
			
			//	checking for prototype
			if(isPrototype(id)){
								
				/*
					we need to initialize bean from xml
					can not do cloning since in case of class
					with constructor arguments it is impossible
					to correctly construct / pass such arguments
					extracted from source class
				*/
				var node:DINode = nodes[id];				
				return initializeBean(node.xml, true);
			}			
			
			return retval;
		}
		
		private function isPrototype(idToBeChecked:String):Boolean{
			
			for each(var id:String in prototypesIDList){
				
				if(id == idToBeChecked){					
					return true;
				}
			}
			return false;
		}
		/**
		 * @param editor custom property editor 
		 * @see IPropertyEditor
		 */
		public function registerPropertyEditor(editor:IPropertyEditor):void{
			var editorKeys:Array = editor.listPropertyInterests();
			
			for each (var propertyKind:String in editorKeys){
				propertyEditorsMap[propertyKind] = editor;
			}
		}
		
		public function containsObject(id:String):Boolean{
			var retval:* = beansMap[id];
			
			return (retval!=null);
		}		
		
		private function resolveDependentBeans():void{
			
			if(nodeNames.length < 2){
				return;
			}
			
			var resolutionOrder:Vector.<DINode> = new Vector.<DINode>();
			var unresolved:Vector.<DINode> = new Vector.<DINode>();
			
			for each(var name:String in nodeNames){
				
				var node:DINode = nodes[name];
				node.resolve(resolutionOrder, unresolved);
			}
			
			
			for each(var di:DINode in resolutionOrder){
				
				//	initialize ONLY uninitialized objects
				if(di.object == null){										
					initializeBean(di.xml, true);
				}							
			}			
		}
		
		public function getTypedObject(id:String, clazz:Class):*{
			var bean:* = getObject(id);
			
			if(bean is clazz){
				return bean;
			}
			
			throw new ContainerError("Bean with name: [" + id + "] is not of expected type: [" + clazz + "]", 0, ContainerError.ERROR_INVALID_OBJECT_TYPE);
		}
		
		public function getType(id:String):Class{
			var bean:* = getObject(id);
			return Class(getDefinitionByName(getQualifiedClassName(bean)));
		}
		
		public function isSingleton(id:String):Boolean{
			return !isPrototype(id);
		} 	
		
	}
}