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
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import org.toshiroioc.ContainerError;
	import org.toshiroioc.plugins.i18n.II18NProvider;
	
	/**
	 * @author Jaroslaw Szczepankiewicz
	 * @author Michal Strecker
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
	public class XMLBeanFactory extends EventDispatcher implements IBeanFactory
	{
		private static const KEYWORDS_ATTRIBUTE_NAMES:Array = ["name", "value", "ref", "id", "class", "lifecycle", "creationPolicy",
			"const", "optional"]
		private var xmlSource:XML;
		/**
		 * beans map with key as id
		 */
		private var beansMap:Object = new Object();
		
		private var nodes:Object = new Object();
		
		private var prototypesIDList:Vector.<String> = new Vector.<String>();
		
		private var nodeNamesClassesMap:Vector.<Array> = new Vector.<Array>();
		
		//	objects that have dependencies on each other, needs to be resolved later
		private var postInitializedBeans:Array = new Array();
		
		internal var unresolvedNodes:Vector.<DINode> = new Vector.<DINode>();
		
		private var propertyEditorsMap:Object = new Object();
		
		private var classesWithRegisteredPostprocessors:Vector.<Array> = new Vector.<Array>();
		
		private var registeredPostprocessors:Vector.<IClassPostprocessor>;
		
		private var optionalRefParentsMap:Object = new Object();
		
		private var reservedIdsInterfacesMap:Object = new Object();
		
		private var additConfigLoader:AdditionalConfigLoader;
		
		private static var CREATION_POLICY_IMMEDIATE:String = 'immediate';
		
		public function XMLBeanFactory(xml:XML)
		{
			xmlSource = xml;
			fillReservedIdsMap();
		}
		
		private function fillReservedIdsMap():void
		{
			reservedIdsInterfacesMap['toshiro.i18nProvider'] = II18NProvider;
		}
		
		/**
		 * initializes the container, parse xml. Dispatches Event.COMPLETE
		 * when it is ready to start
		 */
		public function initialize():void
		{
			
			//	registering built in property editors			
			registerPropertyEditor(new CorePropertyEditors());
			startParseBeans(xmlSource);
			
			if(additConfigLoader != null)
			{
				for each(var xml:XML in additConfigLoader.configs)
				{
					loadDynamicConfig(xml, false);
				}
			}
			runPostprocessorsOnContextLoaded();
			//	dispatch complete event to inform that container is ready
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function addConfigsToDynamicLoadAtStartup(arr:Array):void
		{
			additConfigLoader = new AdditionalConfigLoader(arr);
		}
		
		public function concatConfigsWithMainXML(arr:Array):void
		{
			var configLoader:AdditionalConfigLoader = new AdditionalConfigLoader(arr);
			var xmlSourceString:String = xmlSource.toXMLString();
			xmlSourceString = removeTag('</objects>', xmlSourceString);
			for each(var xml:XML in configLoader.configs)
			{
				var xmlString:String = xml.toXMLString();
				xmlString = removeTag('<objects>', xmlString);
				xmlString = removeTag('</objects>', xmlString);
				xmlSourceString = xmlSourceString.concat(xmlString);
			}
			xmlSourceString = xmlSourceString.concat('</objects>');
			xmlSource = new XML(xmlSourceString);
		}
		
		private function removeTag(tag:String, string:String):String
		{
			
			var regExp:RegExp = new RegExp(tag);
			trace(string.match(regExp));
			return string.replace(regExp, '');
		}
		
		private function injectOptionalRefs(oldBeansCount:Number):void
		{
			
			var arr:Array;
			var newBeanId:String;
			var parents:Array;
			//check new beans names if were registered as child of optional ref
			for(var i:Number = oldBeansCount; i < nodeNamesClassesMap.length; i++)
			{
				arr = nodeNamesClassesMap[i];
				newBeanId = arr[0];
				parents = optionalRefParentsMap[newBeanId];
				//if they were, inject them to parents which are not prototypes
				if(parents)
				{
					for each(var parentPropNameMap:Array in parents)
					{
						if(!isPrototype(parentPropNameMap[0]))
						{
							getObject(parentPropNameMap[0])[parentPropNameMap[1]] = getObject(newBeanId);
						}
					}
				}
			}
		}
		
		//TODO: Unregister commands when failed
		public function loadDynamicConfig(xml:XML, dispatchCompleteEvent:Boolean = true):void
		{
			var oldNodeNamesClassesMap:Vector.<Array> = nodeNamesClassesMap.concat();
			try
			{
				startParseBeans(xml);
			}
			catch(err:Error)
			{
				clearEverythingFromNewBeans(oldNodeNamesClassesMap);
				throw err;
			}
			injectOptionalRefs(oldNodeNamesClassesMap.length);
			runPostprocessorsOnContextLoaded();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function clearEverythingFromNewBeans(oldNodeNamesClassesMap:Vector.<Array>):void
		{
			var oldBeansNames:Vector.<String> = new Vector.<String>;
			var newBeansMap:Object = new Object();
			var newNodes:Object = new Object();
			var newPrototypesIDList:Vector.<String> = new Vector.<String>;
			// get old beans names
			for each(var arr:Array in oldNodeNamesClassesMap)
			{
				oldBeansNames.push(arr[0]);
			}
			
			for each(var oldBeanId:String in oldBeansNames)
			{
				
				newBeansMap[oldBeanId] = beansMap[oldBeanId];
				newNodes[oldBeanId] = nodes[oldBeanId];
				for each(var prototypeId:String in prototypesIDList)
				{
					if(prototypeId == oldBeanId)
					{
						newPrototypesIDList.push(prototypeId);
					}
				}
				
			}
			postInitializedBeans = new Array();
			unresolvedNodes = new Vector.<DINode>;
			beansMap = newBeansMap;
			nodes = newNodes;
			nodeNamesClassesMap = oldNodeNamesClassesMap;
			prototypesIDList = newPrototypesIDList;
		}
		
		private function parseConstAttribute(constans:String, id:String):*
		{
			var words:Array = constans.split(".");
			// get static variable name
			var staticVarName:String = words[words.length - 1];
			// get full name of the class (without variable name)
			var fullClassName:String = constans.substring(0, constans.indexOf(staticVarName) - 1);
			// get class reference
			var clazz:Class = getDefinitionByName(fullClassName) as Class;
			// get variable value or null, if doesn't exist
			var staticVar:* = clazz[staticVarName];
			if(staticVar)
			{
				return staticVar;
			}
			
			throw new ContainerError("Bean with name: [" + id + "] " + "references to nonexistent static field [" + fullClassName +
				"." + staticVarName + "]", 0, ContainerError.ERROR_INVALID_STATIC_REFERENCE);
		}
		
		private function getClass(name:String):Class
		{
			var val:Class = getDefinitionByName(name) as Class;
			if(val == null)
			{
				throw ArgumentError("Class: [" + name + "] is not defined");
			}
			return val;
		}
		
		internal function parseConstructorArgumentValue(xml:XML):*
		{
			
			var constans:String = xml.attribute("const");
			var id:String = xml.parent().attribute("id");
			var val2:*;
			if(constans.length > 0)
			{
				return parseConstAttribute(constans, id);
			}
			
			//	checking for ref constructor param
			var ref:String = xml.attribute("ref").toXMLString();
			
			if(ref.length > 0)
			{
				
				//	constructor with dependencies
				
				val2 = getObject(ref, true);
				
				if(val2 == null)
				{
					throw ArgumentError("beansMap does not contain initialized bean: " + ref);
				}
				
				return val2;
			}
			
			//	checking for class constructor param
			var className:String = xml.attribute("class").toXMLString();
			if(className.length > 0)
			{
				
				//	constructor with class argument
				return getClass(className);
			}
			
			//	checking for array constructor param
			if(xml.child("array").toXMLString().length > 0)
			{
				//	constructor with array to parse
				return parseArray(xml.child("array").child("entry"));
			}
			
			//	checking for special type date
			var dateAsString:* = xml.child("date")[0];
			
			if(dateAsString != null)
			{
				return JAXBDate.fromJAXB(String(dateAsString));
			}
			
			var val:* = xml.attribute("value")[0];
			
			/*
			 *	we must implicitly convert string representation of false
			 *	into "false" boolean. In case of String field with "false" String
			 *	this works without problems
			 */
			if(String(val) == "false")
			{
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
		private function getNode(id:String):DINode
		{
			
			//	check for initialzed DINodes
			var initializedNode:DINode = nodes[id];
			
			if(initializedNode != null)
			{
				//	node found in cache
				return initializedNode;
			}
			
			//	initialized node not found check for initialized objects			
			var initializedObject:* = getObject(id, true);
			
			if(initializedObject != null)
			{
				
				//	node NOT found in node cache but found in object cache
				var nodeWithObject:DINode = new DINode(null, initializedObject, id);
				
				nodeNamesClassesMap.push([id, getDefinitionByName(getQualifiedClassName(initializedObject))]);
				nodes[id] = nodeWithObject;
				return nodeWithObject;
			}
			
			//node not found in either node & object cache, posponing return
			var node:DINode = new DINode(null, null, id, true);
			nodeNamesClassesMap.push([id, null]);
			
			nodes[id] = node;
			return node;
		
		}
		
		private function filterAndValidateOptionalAttribute(refProperties:XMLList):XMLList
		{
			if(refProperties.length() == 0)
			{
				return refProperties;
			}
			//var beanId:String = ((refProperties[0] as XML).parent() as XML).attribute("id").toXMLString();
			var optionalAttrib:String;
			var filteredList:XMLList = new XMLList();
			for each(var property:XML in refProperties)
			{
				switch(property.attribute("optional").length())
				{
					case 0:
					{
						//forward
						filteredList += property;
						break;
					}
					case 1:
					{
						switch(property.attribute("optional").toXMLString())
						{
							case "true":
								//do not forward
								break;
							case "false":
							{
								//forward
								filteredList += property;
								break;
							}
							default:
							{
								throw new ArgumentError("Wrong [optional] attribute:[" + property.attribute("optional").
									toXMLString() + "]");
							}
						}
						break;
					}
					default:
						//if too many [optional] arguments, error is thrown by xml parser
				}
			}
			return filteredList;
		
		}
		
		private function hasDependencies(beanXML:XML, dependencies:XMLList):Boolean
		{
			var test:*;
			var dependentS:String;
			
			if(dependencies.length() > 0)
			{
				
				var id:String = beanXML.attribute("id");
				//take from cache if previously created by parents ref
				var depNode:DINode = nodes[id];
				if(!depNode)
				{
					depNode = new DINode(beanXML);
					nodes[id] = depNode;
				}
				else
				{
					// created by ref, so set xml and remove null class from map
					depNode.updateXml(beanXML);
					removeFromNodeNamesClassesMapById(id);
				}
				this.nodeNamesClassesMap.push([id, getDefinitionByName(beanXML.attribute("class"))]);
				for each(var dependency:XML in dependencies)
				{
					
					dependentS = dependency.attribute("ref");
					var dependentNode:DINode = getNode(dependentS)
					depNode.addNodeDependency(dependentNode);
					dependentNode.isDependency = true;
				}
				return true;
			}
			
			return false;
		}
		
		/* private function hasDependencies(beanXML:XML):Boolean{
		var test:*;
		var dependentS:String;
		//	filtering by required "ref" attribute
		var propertiesDependent:XMLList = beanXML.child("property").(attribute("ref").toXMLString().length > 0);
		var constructorDependent:XMLList = beanXML.child("constructor-arg").(attribute("ref").toXMLString().length > 0);
		propertiesDependent = filterAndValidateOptionalAttribute(propertiesDependent);
		if(propertiesDependent.length() > 0 || constructorDependent.length() > 0){
		
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
		
		
				dependentS = property.attribute("ref");
				depNode.addNodeDependency(getNode(dependentS));
			}
			for each (var constructor:XML in constructorDependent){
		
				dependentS = constructor.attribute("ref");
				depNode.addNodeDependency(getNode(dependentS));
			}
			return true;
		}
		
		return false;
	} */
		
		private function processReferencingBean(beanXML:XML):Object
		{
			return getObject(beanXML.attribute('ref'));
		}
		
		private function validateXML(xml:XML):void
		{
			var constructorArgs:XMLList = xml.child("constructor-arg")
			var properties:XMLList = xml.child("property");
			var allChildren:XMLList = xml.children();
			var unsupportedChildren:String = allChildren.toXMLString().replace(properties.toXMLString() + "\\s*", "").replace(constructorArgs.
				toXMLString() + "\\s*", "");
			
			//bean attributes
			var beanAttribsNames:Vector.<String> = new Vector.<String>;
			for each(var lvXmlAttribute:XML in xml.attributes())
			{
				if(beanAttribsNames.indexOf(lvXmlAttribute.name().toString()) == -1)
				{
					beanAttribsNames.push(lvXmlAttribute.name().toString());
				}
			}
			
			for each(var child:XML in xml.children())
			{
				for each(lvXmlAttribute in child.attributes())
				{
					if(beanAttribsNames.indexOf(lvXmlAttribute.name().toString()) == -1)
					{
						beanAttribsNames.push(lvXmlAttribute.name().toString());
					}
				}
			}
			
			trace(beanAttribsNames);
			for each(var keyword:String in KEYWORDS_ATTRIBUTE_NAMES)
			{
				var i:Number = beanAttribsNames.indexOf(keyword)
				if(i > -1)
				{
					beanAttribsNames[i] = "";
				}
			}
			trace(beanAttribsNames.toString());
			var regExp:RegExp = /,+/g;
			var wrongAttribs:String = beanAttribsNames.toString().replace(regExp, ",");
			if(wrongAttribs.indexOf(',') == 0)
			{
				wrongAttribs = wrongAttribs.slice(1);
			}
			if(wrongAttribs.indexOf(',') == wrongAttribs.length - 1)
			{
				wrongAttribs = wrongAttribs.slice(0, wrongAttribs.length - 1);
			}
			if(wrongAttribs.length > 0)
			{
				throw new ContainerError("Not recognized attributes names: [" + wrongAttribs + "]", 0, ContainerError.ERROR_KEYWORD_NOT_RECOGNIZED)
			}
			
			if(xml.children().length() > properties.length() + constructorArgs.length())
			{
				throw new ContainerError("Not supported xml children of the bean: [" + xml.attribute("id").toXMLString() +
					"]" + ":\n " + unsupportedChildren, 0, ContainerError.ERROR_KEYWORD_NOT_RECOGNIZED);
			}
		
		}
		
		private function initializeBean(beanXML:XML, proceedIfSettingDependencyFound:Boolean = false, putToNodeCache:Boolean =
			true):Object
		{
			
			//when processing <object ref="..."/> return target of reference	
			if(beanXML.attribute('ref').length() > 0)
			{
				return processReferencingBean(beanXML);
			}
			
			validateXML(beanXML);
			
			var clazz:Class = getDefinitionByName(beanXML.attribute("class")) as Class;
			
			var retval:Object = null;
			
			var constructorArgs:XMLList = beanXML.child("constructor-arg")
			var properties:XMLList = beanXML.child("property");
			
			if(constructorArgs.length() > 0)
			{
				
				retval = ClassUtil.initializeClassWithNonDefConstructor(beanXML, constructorArgs, clazz, this);
			}
			else
			{
				retval = new clazz();
			}
			
			processBeanProperties(clazz, retval, properties, beanXML.attribute("id").toXMLString(), proceedIfSettingDependencyFound);
			
			return retval;
		}
		
		/**
		 * refill nodes with newly created object
		 */
		private function putObjectIntoNodeCache(object:*, beanXML:XML):void
		{
			
			var id:String = beanXML.attribute("id")
			
			//if bean without name but with ref, treat ref as id
			if(id == null || id.length == 0)
			{
				id = beanXML.attribute("ref");
			}
			if(id == null || id.length == 0)
			{
				throw new ContainerError("Object without id or ref can not be put into node cache: [" + beanXML.toXMLString() +
					"]");
			}
			
			var node:DINode = nodes[id];
			
			if(node == null)
			{
				node = new DINode(beanXML, object, id); //Why without xml? CHANGE
				
				//	object not found in node cache creating new one				
				nodeNamesClassesMap.push([id, getDefinitionByName(beanXML.attribute("class"))]);
				
				nodes[id] = node;
			}
			else
			{
				//	object found in node cache but we assume that it is not initialized, altering object which was uninitilized				
				node.updateInitializedObject(object);
				
				/*	saving xml in order to be available in case there is prototype
					prototypes are initialzed from xml
				*/
				node.updateXml(beanXML);
				//	updating the objects
				if(!isPrototype(id))
				{
					putObjectIntoBeansMap(id, object);
				}
				
					//var clazz:Class = getDefinitionByName(beanXML.attribute("class")) as Class;
				
				/*try{
					getObjectsByClass(clazz);
				}
				catch(err:ContainerError){
					removeFromNodeNamesClassesMapById(id);
					nodeNamesClassesMap.push([id, clazz]);
				}	*/
				
			}
		}
		
		private function putObjectIntoBeansMap(id:String, object:*):void
		{
			beansMap[id] = object;
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
		
		private function nameExists(name:String):Boolean
		{
			//return true if exists map between name and not null class
			//asserts map not created by ref
			for each(var arr:Array in nodeNamesClassesMap)
			{
				if(arr[0] == name && arr[1])
				{
					return true;
				}
			}
			return false;
		}
		
		//check if bean with reserved id implements interface defined in map
		private function isBeanIdReserved(id:String, className:String):Boolean
		{
			if(reservedIdsInterfacesMap[id] != null)
			{
				var objClass:Class = getDefinitionByName(className) as Class;
				var testObj:Object = new objClass();
				var clazz:Class = reservedIdsInterfacesMap[id] as Class;
				if(!(testObj is clazz))
				{
					return true;
				}
			}
			return false;
		}
		
		private function startParseBeans(xmlSource:XML, initBeans:Boolean = false):Object
		{
			var beans:XMLList = xmlSource.child("object");
			var beanXML:XML;
			var isRoot:Boolean = (beans.parent() as XML).localName().toString() == "objects";
			var bean:Object;
			
			//for each(beanXML in beans){
			for(var i:int = 0; i < beans.length(); i++)
			{
				
				beanXML = beans[i];
				
				var idString:String = String(beanXML.attribute("id"));
				var hasId:Boolean = idString && idString.length > 0;
				var isBeanRef:Boolean = (beanXML.attribute("ref").toXMLString().length > 0);
				var creationPolicy:String = (beanXML.attribute("creationPolicy").toXMLString());
				if(creationPolicy.length > 0 && creationPolicy != CREATION_POLICY_IMMEDIATE)
				{
					throw new ArgumentError("Wrong [creationPolicy] attribute:[" + creationPolicy + "] for bean:[" + idString +
						"]");
				}
				
				if(nameExists(idString))
				{
					throw new ContainerError("Id: [" + idString + "] not unique", 0, ContainerError.ERROR_MULTIPLE_BEANS_WITH_THE_SAME_ID);
				}
				
				if(isBeanIdReserved(idString, beanXML.attribute("class").toXMLString()))
				{
					throw new ContainerError("Id: [" + idString + "] reserved as special toshiro bean", 0, ContainerError.
						ERROR_BEAN_ID_RESERVED);
				}
				
				//if ref'ing and has id, throw error
				if(hasId && isBeanRef)
				{
					throw new ContainerError("Only ref attribute (not id) has to be specified in bean referencing (being) other bean",
						0, ContainerError.ERROR_REFERENCING_BEAN_GIVEN_ID);
				}
				else
				{
					//treat ref as id
					if(isBeanRef)
					{
						hasId = true;
						idString = beanXML.attribute("ref").toXMLString();
					}
				}
				
				if(isRoot)
				{
					if(isBeanRef)
					{
						throw new IllegalOperationError("Top-level beans can not be simply references to other beans: " +
							beanXML);
					}
					if(!hasId)
					{
						throw new IllegalOperationError("Top-level beans have to have id: " + beanXML);
					}
				}
				
				bean = null;
				
				//	checking for prototype
				var lifecycleAttrib:String = beanXML.attribute("lifecycle").toXMLString();
				if(lifecycleAttrib == "prototype")
				{
					prototypesIDList.push(idString);
				}
				else if(lifecycleAttrib == "singleton")
				{
					// OK
				}
				else if(lifecycleAttrib.length > 0)
				{
					throw new ArgumentError("Wrong [lifecycle] attribute:[" + lifecycleAttrib + "] for bean:[" + idString +
						"]");
				}
				
				var propertiesDependent:XMLList = new XMLList();
				
				var objects:XMLList = beanXML.descendants('object');
				var dependencyId:String;
				var newXMLSource:XML = null;
				
				for each(var object:XML in objects)
				{
					
					var id:String = object.attribute('id');
					var beanRef:String = object.attribute('ref');
					var optional:String = object.attribute('optional');
					
					if(id.length > 0 && beanRef.length > 0)
					{
						throw new ContainerError("Only ref attribute (not id) has to be specified in bean referencing (being) other bean",
							0, ContainerError.ERROR_REFERENCING_BEAN_GIVEN_ID);
					}
					dependencyId = id + beanRef;
					
					//if(dependencyId != idString){
					if(dependencyId && dependencyId.length > 0)
					{
						
						if(optional.length > 0)
						{
							throw new IllegalOperationError("Optional attribute for ref'ing bean not supported: [" + object +
								"]");
								//propertiesDependent += XML('<property ref="'+dependencyId+'" optional="'+optional+'"/>');
						}
						else
						{
							propertiesDependent += XML('<property ref="' + dependencyId + '"/>');
						}
						
						if(!beanRef.length > 0)
						{
							if(!newXMLSource)
							{
								newXMLSource = new XML();
								newXMLSource = XML('<newSource></newSource>');
							}
							newXMLSource.appendChild(object);
						}
					}
				}
				var propertiesRefs:XMLList = beanXML.child("property").(attribute("ref").toXMLString().length > 0);
				var constructorsRefs:XMLList = beanXML.child("constructor-arg").(attribute("ref").toXMLString().length >
					0);
				
				if(!isBeanRef)
				{
					
					//if not bean simply referencing another bean 
					//filtering by required "ref" attribute
					propertiesDependent += propertiesRefs;
					propertiesDependent += constructorsRefs;
				}
				else
				{
					if(propertiesRefs.length > 0 || constructorsRefs.length > 0)
					{
						throw new IllegalOperationError("Beans referencing other beans shouldn't have" + "constructor or properties arguments, because they are not processed anyway");
					}
				}
				
				//take care about optional attribute and remove optional refs from lists of refs
				propertiesDependent = filterAndValidateOptionalAttribute(propertiesDependent);
				
				//	checking for beans with dependencies
				// creating nodes
				if(hasDependencies(beanXML, propertiesDependent))
				{ //if already initialized, should be injected
					if(!hasId)
					{
						throw new IllegalOperationError("Bean containing reference has to have id: [" + beanXML + "]");
					}
					
					//parse skipped inner beans
					if(newXMLSource)
					{
						startParseBeans(newXMLSource, initBeans);
						
						// remove beans to parse from beans XMLList that was parsed already (passed in newXMLSource or before that point in the loop) 
						var newBeansString:String = '';
						var newBeans:XMLList = new XMLList;
						var newXMLSourceObjects:XMLList = newXMLSource.child('object');
						
						for(var j:int = i + 1; j < beans.length(); j++)
						{
							var nextBean:XML = beans[j];
							if(!newXMLSourceObjects.contains(nextBean))
							{
								newBeansString = newBeansString.concat(nextBean.toXMLString());
							}
						}
						
						i = -1;
						beans = new XMLList(newBeansString);
						trace(beans.length());
					}
					
					continue;
				}
				
				//if prototype don't initialize
				if(!isPrototype(idString) && (initBeans || creationPolicy == CREATION_POLICY_IMMEDIATE))
				{
					bean = initializeBean(beanXML, false);
				}
				
				if(hasId)
				{
					putObjectIntoNodeCache(bean, beanXML);
					if(bean)
					{
						putObjectIntoBeansMap(idString, bean);
					}
				}
				
			}
			if(isRoot)
			{
				resolveDependentBeans();
			}
			// for array parse case
			return bean;
		
		}
		
		private function prepareArraysDecorators(xml:XML):void
		{
			var arrays:XMLList = xml.descendants('array');
			for each(var array:XML in arrays)
			{
				createArrayDecorator(array);
				var parent:XML = (array.parent() as XML);
				trace(parent.toXMLString());
				array = null;
				trace(parent.toXMLString());
				
			}
		}
		
		private function createArrayDecorator(arrayXML:XML):void
		{
		
		}
		
		private function manageOptionalRef(parent:String, ref:String, propertyName:String):void
		{
			var parents:Array = optionalRefParentsMap[ref] as Array;
			if(parents)
			{
				parents.push([parent, propertyName]);
			}
			else
			{
				parents = [[parent, propertyName]];
				optionalRefParentsMap[ref] = parents;
			}
		}
		
		private function processBeanProperties(clazz:Class, bean:*, properties:XMLList, beanId:String, processDependencies:Boolean =
			false):void
		{
			var fieldDescriptionMap:Object = FieldDescription.getClassDescription(clazz);
			
			// call methods tagged [BeforeConfigure]
			var beforeConfigureMethodNames:Vector.<String> = FieldDescription.getBeforeConfigureMethodsName(clazz);
			if(beforeConfigureMethodNames)
			{
				for each(var methodName:String in beforeConfigureMethodNames)
				{
					bean[methodName]();
				}
			}
			
			//	initializing
			
			for each(var property:XML in properties)
			{
				
				//	FIXME: there should be some better way to check existence of attribute
				var refProp:String = property.attribute("ref").toXMLString();
				var propertyName:String = property.attribute("name").toXMLString();
				var constProp:String = property.attribute("const").toXMLString();
				
				if(refProp.length > 0)
				{
					var optional:String = property.attribute("optional").toXMLString();
					
					if(!(optional == "true") && processDependencies)
					{
						//	late initialization for ref property	
						bean[propertyName] = getObject(refProp, true);
						continue;
					}
					else if(optional == "true")
					{
						manageOptionalRef(beanId, refProp, propertyName);
						continue;
					}
				}
				
				if(constProp.length > 0)
				{
					bean[propertyName] = parseConstAttribute(constProp, property.parent().attribute("id"));
					continue;
				}
				
				//	checking for implicit null property value
				if(property.child("null").length() != 0)
				{
					bean[propertyName] = null;
					continue;
				}
				if(property.child("array").length() != 0)
				{
					bean[propertyName] = parseArray(property.child("array").child("entry") as XMLList);
					continue;
				}
				
				if(property.child("map").length() != 0)
				{
					bean[propertyName] = parseMap(property.child("map").child("entry") as XMLList);
					continue;
				}
				
				if(property.child("object").length() != 0)
				{
					bean[propertyName] = parseObject(property);
					continue;
				}
				
				/* 				if (property.child("vector").length()!=0){
									bean[propertyName] = parseVector(property.child("vector").child("entry") as XMLList);
									continue;
								}  */
				
				bean[propertyName] = parseProperty(fieldDescriptionMap[propertyName], property);
			}
			
			//if any required field not initialized throw an error
			var reqFields:Array = FieldDescription.getRequiredFields(clazz);
			if(reqFields)
			{
				for each(var fieldName:String in reqFields)
				{
					if(!bean[fieldName])
					{
						throw new ContainerError("Required bean [" + fieldName + "] not initialized", 0, ContainerError.
							ERROR_REQUIRED_METATAG_NOT_SATISFIED);
					}
				}
			}
			
			var contextPropertyName:String = FieldDescription.getPropertyNameForContextInjection(clazz);
			if(contextPropertyName)
			{
				bean[contextPropertyName] = this;
			}
			
			var fieldsToTranslate:Array = FieldDescription.getPropertiesToTranslate(clazz);
			if(fieldsToTranslate != null)
			{
				for each(fieldName in fieldsToTranslate)
				{
					bean[fieldName] = this.getTypedObject('toshiro.i18nProvider', II18NProvider).getString(bean, fieldName,
						beanId);
				}
				
			}
			
			var fieldsToInjectBeanId:Array = FieldDescription.getPropertiesToInjectBeansId(clazz);
			if(fieldsToInjectBeanId != null)
			{
				for each(fieldName in fieldsToInjectBeanId)
				{
					if(beanId == null || beanId.length == 0)
					{
						bean[fieldName] = null;
					}
					else
					{
						bean[fieldName] = beanId;
					}
					
				}
			}
			
			// call method tagged [AfterConfigure]
			var afterConfigureMethodNames:Vector.<String> = FieldDescription.getAfterConfigureMethodsName(clazz);
			if(afterConfigureMethodNames)
			{
				for each(methodName in afterConfigureMethodNames)
				{
					bean[methodName]();
				}
			}
			
			for each(var arr:Array in classesWithRegisteredPostprocessors)
			{
				if(bean is arr[0])
				{
					runPostprocessors(bean, arr[1] as Array);
					return
				}
				
			}
		}
		
		private function parseProperty(propertyType:uint, property:XML):*
		{
			var editor:IPropertyEditor = propertyEditorsMap[propertyType];
			
			if(editor == null)
			{
				throw new ContainerError("Property editor for property: [" + property.attribute("name") + "], type: [" +
					propertyType + "]");
			}
			return editor.parseProperty(propertyType, property);
		}
		
		/* 		private function parseVector(entries:XMLList):Vector<*>{
		
				} */
		
		private function parseMap(entries:XMLList):Object
		{
			
			var properties:XMLList;
			var property:XML;
			var object:Object = new Object();
			var key:String;
			var clazz:Class;
			for each(var entry:XML in entries)
			{
				properties = entry.child("property");
				switch(properties.length())
				{
					case (0):
					{
						throw new ArgumentError("Empty entry in:[" + entries + "]");
						break;
					}
					case (1):
					{
						property = properties[0];
						key = property.attribute("key").toXMLString();
						
						if(!key || key.length == 0)
						{
							throw new ArgumentError("Property:[" + property + "] in entry:[" + entry + "] has empty key")
						}
						object[key] = getClass(property.attribute("class").toXMLString());
						break;
					}
					default:
					{
						throw new ArgumentError("Too many arguments for a single map entry, allowed one. [" + entry + "]");
					}
				}
			}
			return object;
		}
		
		private function parseObject(objectXML:XML):*
		{
			var bean:*
			var id:String = objectXML.child('object').attribute('id').toXMLString();
			var ref:String = objectXML.child('object').attribute('ref').toXMLString();
			
			//if has id, check if initialized
			if(id || ref)
			{
				if(id != null && id.length > 0)
				{
					bean = getObject(id, true);
				}
				else
				{
					bean = getObject(ref, true);
				}
			}
			//if not, try to parse
			if(!bean)
			{
				bean = startParseBeans(objectXML, true);
			}
			return bean;
		}
		
		private function parseArray(entries:XMLList):Array
		{
			var typesArray:Array = FieldDescription.getArrayEntriesDescription(entries);
			var returnArray:Array = new Array();
			var entry:XML;
			var value:*;
			for(var i:int; i < entries.length(); i++)
			{
				entry = entries[i] as XML;
				value = (entry.children()[0] as XML).children()[0];
				
				switch(typesArray[i])
				{
					case FieldDescription.FIELD_TYPE_CUSTOM_OBJECT:
					{
						//entry = entries[i]; // pass the object to parse
						/*bean = null;
						var id:String = entry.child('object').attribute('id').toXMLString();
						var ref:String = entry.child('object').attribute('ref').toXMLString();
						
						//if has id, check if initialized
						if(id || ref){
							if(id != null && id.length>0){
								var bean:* = getObject(id, true);
							}else{
								bean = getObject(ref, true);
							}
						}
						//if not, try to parse
						if(!bean){
							bean = startParseBeans(entry, true);
						}
						*/
						returnArray.push(parseObject(entry)); //and add to array		
						continue;
					}
					// WARNING: when nested, no bean id
					case FieldDescription.FIELD_TYPE_CONST:
					{
						var property:XML = ((entries.parent() as XML).parent() as XML);
						returnArray.push(parseConstAttribute(value, (property.parent() as XML).attribute("id") + "." + property.
							attribute("name")));
						continue;
					}
					case FieldDescription.FIELD_TYPE_ARRAY:
					{
						returnArray.push(parseArray(entry.child("array").child("entry")));
						continue;
					}
					case FieldDescription.FIELD_TYPE_MAP:
					{
						returnArray.push(parseMap(entry.child("map").child("entry")));
						continue;
					}
					case FieldDescription.FIELD_TYPE_CLASS:
					{
						//add attribute class
						entry['@class'] = value;
						break;
					}
					case FieldDescription.FIELD_TYPE_DATE:
					{
						//add attribute date
						entry.@date = value;
						break;
					}
					default:
					{
						//add attribute value
						entry.@value = value;
					}
				}
				returnArray.push(parseProperty(typesArray[i], entry));
			}
			return returnArray;
		}
		
		public function runPostprocessorsOnContextLoaded():void
		{
			for each(var postprocessor:IClassPostprocessor in registeredPostprocessors)
			{
				postprocessor.onContextLoaded();
			}
		}
		
		private function runPostprocessors(bean:*, postprocessors:Array):void
		{
			var inputChange:Boolean;
			var returnedValue:*;
			for each(var postprocessor:IClassPostprocessor in postprocessors)
			{
				if(!inputChange)
				{
					returnedValue = postprocessor.postprocessObject(bean);
					inputChange = true;
					continue;
				}
				returnedValue = postprocessor.postprocessObject(returnedValue);
			}
		}
		
		public function removeFromNodeNamesClassesMapById(id:String):void
		{
			var resultVector:Vector.<Array> = new Vector.<Array>();
			for each(var arr:Array in nodeNamesClassesMap)
			{
				if(id == arr[0])
				{
					continue
				}
				resultVector.push(arr);
			}
			nodeNamesClassesMap = resultVector;
		}
		
		/**
		 * Returns all objects in context that are of a class given as parameter (or that inherits from)
		 * @param clazz
		 * @return
		 *
		 */
		public function getObjectsByClass(clazz:Class):Vector.<Object>
		{
			var objects:Vector.<Object> = new Vector.<Object>;
			var searchedClassType:String = getQualifiedClassName(clazz);
			for each(var arr:Array in nodeNamesClassesMap)
			{
				
				if(searchedClassType == 'Object')
				{
					if(clazz == (arr[1] as Class))
					{
						objects.push(getObject(arr[0]));
					}
				}
				else
				{
					var contextClassType:String = getQualifiedClassName(arr[1] as Class);
					while(contextClassType != "Object")
					{
						if(searchedClassType == contextClassType)
						{
							objects.push(getObject(arr[0]));
							break;
						}
						else
						{
							if(contextClassType != "null")
							{
								contextClassType = getQualifiedSuperclassName(getDefinitionByName(contextClassType) as Class)
							}
							else
							{
								break;
							}
						}
					}
				}
				
			}
			switch(objects.length)
			{
				case (0):
				{
					throw new ContainerError("Bean of the class: [" + clazz + "] not found", 0, ContainerError.ERROR_OBJECT_OF_THE_CLASS_NOT_FOUND);
					break;
				}
				default:
				{
					return objects;
				}
			}
		
		}
		
		/**
		 * @param id id from the xml
		 * @retval initialized bean
		 */
		public function getObject(id:String, ignoreBeanNotFound:Boolean = false):*
		{
			
			//	checking for prototype
			if(isPrototype(id))
			{
				
				/* we need to initialize bean from xml
				can not do cloning since in case of class
				with constructor arguments it is impossible
				to correctly construct / pass such arguments
				extracted from source class */
				
				var node:DINode = nodes[id];
				if(node)
				{
					return initializeBean(node.xml, true);
				}
				throw new ContainerError("Bean with id: [" + id + "] not found, make sure there is one in the XML");
			}
			
			var retval:* = beansMap[id];
			
			if(retval == null)
			{
				node = nodes[id];
				if(node)
				{
					var bean:* = initializeBean(node.xml, true);
					putObjectIntoBeansMap(id, bean);
					return bean;
				}
				else
				{
					if(ignoreBeanNotFound)
					{
						return null;
					}
					throw new ContainerError("Bean with id: [" + id + "] not found, make sure there is one in the XML");
				}
				
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
		private function isPrototype(idToBeChecked:String):Boolean
		{
			
			for each(var id:String in prototypesIDList)
			{
				
				if(id == idToBeChecked)
				{
					return true;
				}
			}
			return false;
		}
		
		private function getRegisteredPostprocessors(clazz:Class):Array
		{
			for each(var arr:Array in classesWithRegisteredPostprocessors)
			{
				if(clazz == arr[0])
				{
					return arr[1] as Array;
				}
			}
			return null;
		}
		
		public function registerClassPostprocessor(postprocessor:IClassPostprocessor):void
		{
			
			for each(var clazz:Class in postprocessor.listClassInterests())
			{
				var postprocessorsOfClass:Array = getRegisteredPostprocessors(clazz);
				//if not already registered
				if(!postprocessorsOfClass)
				{
					//create array of postprocessors for any given class 
					var map:Array = new Array();
					map[0] = clazz;
					map[1] = [postprocessor];
					classesWithRegisteredPostprocessors.push(map);
				}
				else
				{
					//add new postprocessor
					postprocessorsOfClass.push(postprocessor);
				}
				
			}
			//get all registered postprocessors to run onContextLoaded()
			if(!registeredPostprocessors)
			{
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
		public function registerPropertyEditor(editor:IPropertyEditor):void
		{
			var editorKeys:Array = editor.listPropertyInterests();
			
			for each(var propertyKind:String in editorKeys)
			{
				propertyEditorsMap[propertyKind] = editor;
			}
		}
		
		/**
		 * Checks, if context contains xml definition of a bean
		 * @param id Bean id to check, if exists
		 * @return true, if xml definition of specified bean id exists, false otherwise
		 *
		 */
		public function containsBean(id:String):Boolean
		{
			var retval:* = nodes[id];
			
			return (retval != null);
		}
		
		/**
		 * Checks, if context is able to initialize bean
		 * @param id Bean id to try to initialize
		 * @return true, if bean was successfully initialized, false otherwise
		 *
		 */
		public function ableToInitBean(id:String):Boolean
		{
			var retval:*;
			try
			{
				retval = getObject(id);
			}
			catch(e:Error)
			{
				
			}
			
			return (retval != null);
		}
		
		private function resolveDependentBeans():void
		{
			
			if(nodeNamesClassesMap.length < 2)
			{
				return;
			}
			
			var resolutionOrder:Vector.<DINode> = new Vector.<DINode>();
			var unresolved:Vector.<DINode> = new Vector.<DINode>();
			var bean:Object;
			
			for each(var arr:Array in nodeNamesClassesMap)
			{
				var name:String = arr[0];
				var node:DINode = nodes[name];
				node.resolve(resolutionOrder, unresolved);
			}
			
			for each(var di:DINode in resolutionOrder)
			{
				bean = null;
				//	initialize ONLY uninitialized objects
				if(di.object == null)
				{
					// if there is no definition in xml throw error, else initialize
					if(!di.xml)
					{
						throw new ContainerError("Bean [" + di.id + "] not found", 0, ContainerError.ERROR_OBJECT_NOT_FOUND);
					}
					//initialize, if not prototype
					var creationPolicy:String = (di.xml.attribute("creationPolicy").toXMLString());
					if(!isPrototype(di.id) && (di.isDependency || creationPolicy == CREATION_POLICY_IMMEDIATE))
					{
						bean = initializeBean(di.xml, true);
						//if in cache don't put - bean ref case
						putObjectIntoNodeCache(bean, di.xml);
					}
				}
			}
		}
		
		public function getTypedObject(id:String, clazz:Class):*
		{
			var bean:* = getObject(id);
			
			if(bean is clazz)
			{
				return bean;
			}
			
			throw new ContainerError("Bean with name: [" + id + "] is not of expected type: [" + clazz + "]", 0, ContainerError.
				ERROR_INVALID_OBJECT_TYPE);
		}
		
		public function getType(id:String):Class
		{
			var bean:* = getObject(id);
			return Class(getDefinitionByName(getQualifiedClassName(bean)));
		}
		
		public function isSingleton(id:String):Boolean
		{
			return !isPrototype(id);
		}
	
	}
}
