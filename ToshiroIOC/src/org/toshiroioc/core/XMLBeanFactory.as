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
		
		private var classesWithRegisteredPostprocessors:Vector.<Array> = new Vector.<Array>();
		
		private var registeredPostprocessors:Vector.<IClassPostprocessor>;
		
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
			startParseBeans(xmlSource);
			//	dispatch complete event to inform that container is ready
			runPostprocessorsOnContextLoaded();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	
		
		public function loadDynamicConfig(xml:XML):void{
			var oldNodeNamesClassesMap:Vector.<Array> = nodeNamesClassesMap.concat();
			try{
				startParseBeans(xml);
			}
			catch (err:Error){
				clearEverythingFromNewBeans(oldNodeNamesClassesMap);
				throw err;
			}
			runPostprocessorsOnContextLoaded();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function clearEverythingFromNewBeans(oldNodeNamesClassesMap:Vector.<Array>):void{
			var oldBeansNames:Vector.<String> = new Vector.<String>;
			var newBeansMap:Object = new Object();
			var newNodes:Object = new Object();
			var newPrototypesIDList:Vector.<String> = new Vector.<String>;
			// get old beans names
			for each (var arr:Array in oldNodeNamesClassesMap){
				oldBeansNames.push(arr[0]);
			}
			//c
			for each (var oldBeanId: String in oldBeansNames){
				
				newBeansMap[oldBeanId] = beansMap[oldBeanId];
				newNodes[oldBeanId] = nodes[oldBeanId];
				for each (var prototypeId:String in prototypesIDList){
					if (prototypeId == oldBeanId){
						newPrototypesIDList.push(prototypeId);
					}
				}
				
			}
			postInitializedBeans = new Array();
			unresolvedNodes = new Vector.<DINode>;
			beansMap = newBeansMap;
			nodes  = newNodes;
			nodeNamesClassesMap = oldNodeNamesClassesMap;
			prototypesIDList = newPrototypesIDList;
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
		
/* 		private function checkIfNodeReady(id:String):Boolean{
			var initializedNode:DINode = nodes[id];
			if(initializedNode){
				//if node object instantiated or prototype without ref
				if(initializedNode.object 
				|| initializedNode.xml.child("property").(attribute("ref").toXMLString().length == 0))
					return true;
			}
			return false;
		} */
				
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
					
			//node not found in either node & object cache, posponing return
			var node:DINode = new DINode (null, null, id, true);
			nodeNamesClassesMap.push([id, null]);
			
			nodes[id] = node;
			return node;
			 
			
		}
		
		private function hasDependencies(beanXML:XML):Boolean{
			
			//	filtering by optional "ref" attribute
			var propertiesDependent:XMLList = beanXML.child("property").(attribute("ref").toXMLString().length > 0);
			
			if(propertiesDependent.length() > 0){
				var id:String = beanXML.attribute("id");
				//take from cache if previously created by parents ref
				var depNode:DINode = nodes[id];
				if(!depNode){ 
					depNode = new DINode(beanXML);
					nodes[id] = depNode;
				}else{
					// created by ref, so set xml and remove null class from map
					depNode.updateXml(beanXML);
					removeFromNodeNamesClassesMapById(id);
				}
				this.nodeNamesClassesMap.push([id, getDefinitionByName(beanXML.attribute("class"))]);
				for each (var property:XML in propertiesDependent){	
				
					var dependentS:String = property.attribute("ref");
					depNode.addNodeDependency(getNode(dependentS));
				}
				return true;
			}
			
			//	TODO: add checking for constructor dependencies
			var constructorDependent:XMLList = beanXML.child("constructor-arg").(attribute("ref").toXMLString().length > 0);
			
			if(constructorDependent.length() > 0){
				var id2:String = beanXML.attribute("id");
				//take from cache if previously created by parents ref
				var depNode2:DINode = nodes[id2];
				if(!depNode2){ 
					depNode2 = new DINode(beanXML);
					nodes[id2] = depNode2;
				}else{
					// created by ref, so set xml and remove null class from map
					depNode2.updateXml(beanXML);
					removeFromNodeNamesClassesMapById(id2);
				}
				this.nodeNamesClassesMap.push([id2, getDefinitionByName(beanXML.attribute("class"))]);

				for each (var constructor:XML in constructorDependent){	
				
					var dependentS:String = constructor.attribute("ref");					
					depNode2.addNodeDependency(getNode(dependentS));
				}
				return true;
			}
			
			return false;
		}
		
		private function initializeBean(beanXML:XML, proceedIfSettingDependencyFound:Boolean = false,
			putToNodeCache:Boolean = true):Object{

			var clazz:Class = getDefinitionByName(beanXML.attribute("class")) as Class;
			
			var retval:Object = null;
			
			
				var constructorArgs:XMLList = beanXML.child("constructor-arg");
				
				if(constructorArgs.length() > 0){				
					
					retval = ClassUtil.initializeClassWithNonDefConstructor(beanXML, constructorArgs, clazz, this);
				}
				else{
					retval = new clazz();
				}
				
				processBeanProperties(clazz, retval, beanXML.child("property"), proceedIfSettingDependencyFound);

			
			
			return retval;
		}
				
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
				if(!isPrototype(id))
					beansMap[id] = object;
					
				var clazz:Class = getDefinitionByName(beanXML.attribute("class")) as Class;
				
				try{
					getObjectByClass(clazz);
				}
				catch(err:ContainerError){
					removeFromNodeNamesClassesMapById(id);
					nodeNamesClassesMap.push([id, clazz]);	
				}	
					
				
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
		 
		 private function nameExists(name:String):Boolean{
		 	//return true if exists map between name and not null class
		 	//asserts map not created by ref
		 	for each(var arr:Array in nodeNamesClassesMap){
		 		if (arr[0] == name && arr[1]){
		 			return true;
		 		}
		 	}
		 	return false;
		 }
		 
		 private function startParseBeans(xmlSource:XML):Array{
			var beans:XMLList = xmlSource.child("object");
			var beanXML:XML;
			var arrayOfInnerObjects:Array;
			var isRoot : Boolean = (beans.parent() as XML).localName().toString() == "objects";
			var bean:Object;
			
			for each(beanXML in beans){
				var idString:String = String(beanXML.attribute("id")); 
				if (nameExists(idString))
					throw new ContainerError("Id: ["+idString+"] not unique",0,ContainerError.ERROR_MULTIPLE_BEANS_WITH_THE_SAME_ID);
				bean = null;	
				
				//	checking for prototype
				if(beanXML.attribute("lifecycle").toXMLString() == "prototype"){
					prototypesIDList.push(idString);
				}
				
				//	checking for beans with dependencies
				if(hasDependencies(beanXML)){ //if already initialized, should be injected
				//	do nothing
					continue;
				}
				
				//if prototype don't initialize
				if (!isPrototype(idString)){
					bean = initializeBean(beanXML, false);
				}
				
				//	refill nodes
				if(isRoot)
					putObjectIntoNodeCache(bean, beanXML);
				
				if(bean!=null && isRoot){
						beansMap[idString] = bean;
				}else if(bean){
					if (!arrayOfInnerObjects){
						arrayOfInnerObjects = new Array();
					}
					arrayOfInnerObjects.push(bean);
				}
			}			
			if(isRoot){
				resolveDependentBeans();
			}
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
			
			for each (var arr:Array in classesWithRegisteredPostprocessors){
				if(bean is arr[0]){
					runPostprocessors(bean, arr[1] as Array);
					return
				}
					
			}
		}
		
 		private function parseArrayOfObjects(innerObjects:XML):Array{
 			
 			var arrayOfInnerObjects:Array;
 			arrayOfInnerObjects = startParseBeans(innerObjects);
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
		public function runPostprocessorsOnContextLoaded():void{
			for each(var postprocessor:IClassPostprocessor in registeredPostprocessors){
				postprocessor.onContextLoaded();
			}	
		}

		private function runPostprocessors(bean:*, postprocessors:Array):void{
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
		
		public function removeFromNodeNamesClassesMapById(id:String):void{
			var resultVector:Vector.<Array> = new Vector.<Array>();
			for each(var arr:Array in nodeNamesClassesMap){
				if (id == arr[0]){
					continue
				}
				resultVector.push(arr);
			}
			nodeNamesClassesMap = resultVector;
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
			
			//	checking for prototype
			if(isPrototype(id)){
				
					/* we need to initialize bean from xml
					can not do cloning since in case of class
					with constructor arguments it is impossible
					to correctly construct / pass such arguments
					extracted from source class */
				
				var node:DINode = nodes[id];
				if(node){
					return initializeBean(node.xml, true);	
				}				
				throw new ContainerError("Bean with id: [" + id + "] not found, make sure there is one in the XML");
			}	
			
			var retval:* = beansMap[id];		
			
			if(retval == null){
				if(ignoreBeanNotFound){
					return null;
				}
				throw new ContainerError("Bean with id: [" + id + "] not found, make sure there is one in the XML");
			}
			return retval;
		}
		 
		 
/* 		 public function getObject(id:String, ignoreBeanNotFound:Boolean = false):*{
			var node:DINode = nodes[id];	
			var retval:* = beansMap[id];
			
			if(isPrototype(id)){
				return initializeBean(node.xml, true);
			}	
			
			if(retval == null){
				if(ignoreBeanNotFound){
					return null;
				}
				throw new ContainerError("Bean with id: [" + id + "] not found, make sure there is one in the XML");
			}
			
			return retval;
		}
		  */
		private function isPrototype(idToBeChecked:String):Boolean{
			
			for each(var id:String in prototypesIDList){
				
				if(id == idToBeChecked){					
					return true;
				}
			}
			return false;
		}
		
		private function getRegisteredPostprocessors(clazz:Class):Array{
			for each(var arr:Array in classesWithRegisteredPostprocessors){
				if(clazz == arr[0]){
					return arr[1] as Array;
				}
			}
			return null;
		}
		
		public function registerObjectPostprocessor(postprocessor:IClassPostprocessor):void{

			
			for each (var clazz:Class in postprocessor.listClassInterests()){
				var postprocessorsOfClass:Array = getRegisteredPostprocessors(clazz);
				//if not already registered
				if(!postprocessorsOfClass){
					//create array of postprocessors for any given class 
					var map:Array = new Array();
					map[0] = clazz;
					map[1] = [postprocessor];
					classesWithRegisteredPostprocessors.push(map);
				} 
				else{
					//add new postprocessor
					postprocessorsOfClass.push(postprocessor);	
				}
				
			}
			//get all registered postprocessors to run onContextLoaded()
			if(!registeredPostprocessors){
				registeredPostprocessors = new Vector.<IClassPostprocessor>();
			}
			registeredPostprocessors.push(postprocessor);
			
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
			var bean:Object;
			
			for each(var arr:Array in nodeNamesClassesMap){
				var name:String = arr[0];
				var node:DINode = nodes[name];
				node.resolve(resolutionOrder, unresolved);
			}
			
			
			for each(var di:DINode in resolutionOrder){
				bean = null;
				//	initialize ONLY uninitialized objects
				if(di.object == null){	
				// if there is no definition in xml throw error, else initialize
					if (!di.xml)
						throw new ContainerError("Bean ["+di.id+"] not found", 0, ContainerError.ERROR_OBJECT_NOT_FOUND);
					//initialize, if not prototype
					if(!isPrototype(di.id)){
						bean = initializeBean(di.xml, true);
						putObjectIntoNodeCache(bean, di.xml);						
					}									
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