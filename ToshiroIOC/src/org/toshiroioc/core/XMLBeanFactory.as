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
		
		private var nodeNamesClassesMap:Vector.<Array> = new Vector.<Array>();
		
		//	objects that have dependencies on each other, needs to be resolved later
		private var postInitializedBeans:Array = new Array();
		
		internal var unresolvedNodes:Vector.<DINode> = new Vector.<DINode>();
		
		private var propertyEditorsMap:Object = new Object();
		
		private var classesWithRegisteredPostprocessors:Object;
		
		private var arrayOfObjects:Array;
		
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
			//registerPropertyEditor(new MetatagsEditor());				
			startContainerParseBeans(xmlSource);
			//	dispatch complete event to inform that container is ready
			dispatchEvent(new Event(Event.COMPLETE));
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
		
		private function getClass(name:String):Class{
			var val:Class = getDefinitionByName(name) as Class;
				if(val == null){
					throw ArgumentError("Class: [" + name + "] is not defined");
				} 
				return val;
		}
		
		internal function parseConstructorArgumentValue(xml:XML):*{
			
			var constans:String = xml.attribute("const");
			var id:String = xml.parent().attribute("id");
			var val2:*;
		 	if (constans.length > 0){
				return parseConstAttribute(constans, id); 
			} 
			
			//	checking for ref constructor param
			var ref:String = xml.attribute("ref").toXMLString();
			 
			if(ref.length>0){
				
				//	constructor with dependencies
								
				val2 = getObject(ref, true);
				
				if(val2 == null){
					throw ArgumentError("beansMap does not contain initialized bean: " + ref);
				}
								
				return val2;
			}
			
			//	checking for class constructor param
			var className:String = xml.attribute("class").toXMLString();
			 
			if(className.length>0){
				
				//	constructor with class argument
				return getClass(className);				
				
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
				
				nodeNamesClassesMap.push([id, getDefinitionByName(getQualifiedClassName(initializedObject))]);
				nodes[id] = nodeWithObject;
				return nodeWithObject;
			}
					
			//	node not found in either node & object cache, posponing return
			//CHECK: Why added id if there is no bean
			var node:DINode = new DINode (null, null, id, true);
			nodeNamesClassesMap.push([id, null]);
			
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
				this.nodeNamesClassesMap.push([id, getDefinitionByName(beanXML.attribute("class"))]);
								
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
				this.nodeNamesClassesMap.push([id2, getDefinitionByName(beanXML.attribute("class"))]);
				
				return true;
			}
			
			return false;
		}
		
		
		
		
		
		private function initializeBean(beanXML:XML, proceedIfSettingDependencyFound:Boolean = false,
			putToNodeCache:Boolean = true):Object{

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
			
			//if it is special bean containing mappings
			//mozliwosc podpinania postprocessorow
			//2 metody 1 zwraca wektor typow klas ktorymi jest zainteresowany
			//xmlbeanfactory rejestruje w cachu to, gdy trafia na typ, inicjuje go i przekazuje do postprocessora
		/* 	if (retval is NotificationCommandMap){
				processMappings(retval as NotificationCommandMap, beanXML.child("map"));
				return retval;
			} */
			
			processBeanProperties(clazz, retval, beanXML.child("property"), proceedIfSettingDependencyFound);
			
			//	refill nodes
			if(putToNodeCache){
				putObjectIntoNodeCache(retval, beanXML);
			}			
			
			return retval;
		}
		//TODO: throw error if not correctly defined xml wrong tags, more than one
		/* private function processMappings(map:NotificationCommandMap, mappings:XMLList):void{
			var notification:String;
			var command:String;
			var constans:String;
			for each (var mapping:XML in mappings){
				constans = mapping.attribute("const").toXMLString();
				if (constans.length > 0)
					notification = String(parseConstAttribute(constans, (mapping.parent() as XML).attribute("id")));
				else
					notification = mapping.attribute("notification").toXMLString();
				command = mapping.attribute("command").toXMLString();
				map.addMapping(notification, command);
			}
		
		} */
		
		/**
		 * refill nodes with newly created object
		 */
		private function putObjectIntoNodeCache(object:*, beanXML:XML):void{
			
			var id:String = beanXML.attribute("id")
			
			var node:DINode = nodes[id];
			
			if(node == null){
				node = new DINode(beanXML, object, id); //Why without xml? CHANGE
				
				//	object not found in node cache creating new one				
				nodeNamesClassesMap.push([id, getDefinitionByName(beanXML.attribute("class"))]);
				
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
		
		/* private function startContainerParseBeans():void{
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
		 */
		 
		 private function startContainerParseBeans(xmlSource:XML):Array{
			var beans:XMLList = xmlSource.child("object");
			var beanXML:XML;
			var arrayOfInnerObjects:Array;
			var isRoot : Boolean = (beans.parent() as XML).localName().toString() == "objects";
			
			for each(beanXML in beans){
				var idString:String = String(beanXML.attribute("id")); 
				
				//	checking for prototype
				if(beanXML.attribute("lifecycle").toXMLString() == "prototype"){
					prototypesIDList.push(idString);
				}
				//if prototype why to initialize on its own
				var bean:Object = initializeBean(beanXML, false, isRoot);
				
				if(bean!=null && isRoot){//
						beansMap[idString] = bean;
				}else if(bean){
					if (!arrayOfInnerObjects){
						arrayOfInnerObjects = new Array();
					}
					arrayOfInnerObjects.push(bean);
				}
			}			
			resolveDependentBeans();
			return arrayOfInnerObjects;
		}
		
		 
		private function processBeanProperties(clazz:Class, bean:*, properties:XMLList, processDependencies:Boolean = false):void{
			var fieldDescriptionMap:Object = FieldDescription.getClassDescription(clazz);
			
			
			// call method tagged [BeforeConfigure]
			var beforeConfigureMethodName:String = FieldDescription.getBeforeConfigureMethodName(clazz);
			if (beforeConfigureMethodName)
				bean[beforeConfigureMethodName]();
			
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
 				if (property.child("array").length()!=0){
					bean[propertyName] = parseArrayOfObjects(property.child("array")[0] as XML);
					continue;
				} 
								
				var propertyType:uint = fieldDescriptionMap[propertyName];
				var editor:IPropertyEditor = propertyEditorsMap[propertyType];

				if(editor == null){
					throw new ContainerError("Property editor for property: [" + propertyName + "], type: [" + propertyType +"]");	
				}
				bean[propertyName] = editor.parseProperty(propertyType, property);				
			}
			// call method tagged [AfterConfigure]
			var afterConfigureMethodName:String = FieldDescription.getAfterConfigureMethodName(clazz);
			if (afterConfigureMethodName){
				bean[afterConfigureMethodName]();
			}
			//if any required field not initialized throw an error
			var reqFields:Array = FieldDescription.getRequiredFields(clazz);
			if (reqFields){
				for each(var fieldName:String in reqFields){
					if (!bean[fieldName])
						throw new ContainerError("Required bean [" + fieldName + "] not initialized",0,ContainerError.ERROR_REQUIRED_METATAG_NOT_SATISFIED);
				}
			}
			if (classesWithRegisteredPostprocessors){
				runPostprocessors(bean);
			}
		}
		
 		private function parseArrayOfObjects(innerObjects:XML):Array{
 			
 			var arrayOfInnerObjects:Array;
 			arrayOfInnerObjects = startContainerParseBeans(innerObjects);
 			if (innerObjects.localName().toString() == "array"){
 					return arrayOfInnerObjects;
 			}
 			return null;
 		}
 		
/*  		private function createArrayOfInnerObjects(innerObjects:Array):Array{
 			var array:Array = new Array();
 			for each (var bean:* in innerObjects){
 				array.push(bean);
 			}
 			return array;
 		} */
 				
			/* var entries:XMLList = vectorXML.child("entry");
			var vector.<Array> = new Vector.<Array>();
			for each (var entry:XML in entries){
				var arr:Array = new Array(2);
				if (entry.attribute("key").length()>0){
					arr[0] = entry.attribute("key");
				}
				if (entry.attribute("keyconst").length()>0){
					arr[0] = parseConstAttribute(entry.attribute("keyconst"), 
						(((entry.parent() as XML).parent() as XML).parent() as XML).attribute("id");
				}
				if (entry.attribute("ref").length()>0){
					arr[1] = parseConstAttribute(entry.attribute("keyconst"), 
						(((entry.parent() as XML).parent() as XML).parent() as XML).attribute("id");
				}
					
					
			} */
		 

		private function runPostprocessors(bean:*):void{
			var postprocessors:Array = 
				classesWithRegisteredPostprocessors[getDefinitionByName(getQualifiedClassName(bean))] as Array;
			var inputChange:Boolean;
			var returnedValue:*;
			for each(var postprocessor:IClassPostprocessor in postprocessors){
				if(!inputChange){
					returnedValue = postprocessor.postprocessObject(bean);
					inputChange = true;
					continue;
				}
					returnedValue = postprocessor.postprocessObject(returnedValue); 		
			}
		}
		
		public function getObjectByClass(clazz:Class):*{
			var objectOfTheClassCounter:Number = 0;
			var beanToReturn:*;
			
			for each(var arr:Array in nodeNamesClassesMap){
				if (clazz == (arr[1] as Class)){
					beanToReturn = getObject(arr[0]);
					objectOfTheClassCounter++;
				}
			}
			switch(objectOfTheClassCounter){
				case(0):
					throw new ContainerError("Bean of the class: ["+clazz+"] not found"
						, 0, ContainerError.ERROR_OBJECT_OF_THE_CLASS_NOT_FOUND);
					break;
				case(1):
					return beanToReturn;
					break;
				default:
					throw new ContainerError("There is more than one bean of the class: ["+clazz+"]"
						,0, ContainerError.ERROR_MORE_THAN_ONE_OBJECT_OF_THE_CLASS);
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
		
		public function registerObjectPostprocessor(postprocessor:IClassPostprocessor):void{
			if (!classesWithRegisteredPostprocessors){
				classesWithRegisteredPostprocessors = new Object();
			}
			//create array of postprocessors for any given class
			for each (var clazz:Class in postprocessor.listClassInterests()){
				if(!classesWithRegisteredPostprocessors[clazz]) 
					classesWithRegisteredPostprocessors[clazz] = new Array(); 
				
				(classesWithRegisteredPostprocessors[clazz] as Array).push(postprocessor);
			}
			
			/* classesWithRegisteredPostprocessors = classesWithRegisteredPostprocessors
								.concat(postprocessor.listClassInterests()); */
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
			
			if(nodeNamesClassesMap.length < 2){
				return;
			}
			
			var resolutionOrder:Vector.<DINode> = new Vector.<DINode>();
			var unresolved:Vector.<DINode> = new Vector.<DINode>();
			
			for each(var arr:Array in nodeNamesClassesMap){
				var name:String = arr[0];
				var node:DINode = nodes[name];
				node.resolve(resolutionOrder, unresolved);
			}
			
			
			for each(var di:DINode in resolutionOrder){
				
				//	initialize ONLY uninitialized objects
				if(di.object == null){	
				// if there is no definition in xml throw error, else initialize
					if (!di.xml)
						throw new ContainerError("Bean ["+di.id+"] not found", 0, ContainerError.ERROR_OBJECT_NOT_FOUND);									
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