## Introduction ##

Below you can find all of the configuration features of the project
## Configuration and usage scenario ##

### Starting the container ###
Toshiro-IOC is xml driven. The main factory object is `org.toshiroioc.core.XMLBeanFactory` which implements `org.toshiroioc.core.IBeanFactory`. Below is typical usage of the factory:
```
var xml:XML = new XML(somexml);
var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
context.initialize();
			
var beanOne:SimpleBean = context.getObject("objectOne");
```

After successful initialization, an `Event.COMPLETE` is being dispatched.

The xml configuration looks like:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.SimpleBean">
		<property name="booleanItem" value="true"/>
		<property name="stringItem" value="some123String"/>
		<property name="intItem" value="-99999"/>
		<property name="uintItem" value="1111"/>
		<property name="numberItem" value="9999.00001"/>
	</object>
</objects>	
```

### Object retrieval ###

Container allows three ways for retrieving objects:
  * retrieve single object by id without type checking
  * retrieve single object by id with type checking
  * retrieve all objects of specified class

The method `getObject(id:String):*` returns initialized object without type check. Example:
```
var beanOne:SimpleBean = context.getObject("objectOne");
```

It is also possible to retrieve object with checking the type on the container site by using the method `getTypedObject(id:String, clazz:Class):*`. It is recommended way of retrieving. Example:
```
var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ParentOfSimpleDependencyObject"));
var object4:ParentOfSimpleDependencyObject = context.getTypedObject("object4", clazz4);		
```

if the object4 would be not expected type (i.e. `org.toshiroioc.test.beans.ParentOfSimpleDependencyObject`), then the ContainerError will be thrown.

The method `getObjectsByClass(clazz:Class):Vector.<Object>` returns all instances of objects of the given class or throws ContainerError, if none found.
```
var objectVector:Vector.<Object> = context.getObjectsByClass(getDefinitionByName("org.toshiroioc.plugins.puremvc.multicore.SetterMap")as Class);
```

### Injecting simple types ###
Example setter injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.SimpleBean">
		<property name="booleanItem" value="true"/>
		<property name="stringItem" value="some123String"/>
		<property name="intItem" value="-99999"/>
		<property name="uintItem" value="1111"/>
		<property name="numberItem" value="9999.00001"/>
		<property name="staticRefItem" const="org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT"/>
	</object>
</objects>
```

Example constructor injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.BeanWithConstructor">
		<constructor-arg value="-99999"/>
		<constructor-arg value="1111"/>		
		<constructor-arg value="some123String"/>
		<constructor-arg value="true"/>		
		<constructor-arg const="org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT"/>
		...
	</object>
</objects>	
```

**Constructor arguments order should be keeped as in the object constructor definition.**

### Injecting constans variables ###
In order to pass public static const as an argument, one has to use `const` attribute and fully qualified class name has to be provided. Example can be viewed above.

### Injecting date type ###
In case of date argument special format must be keep. Currently Toshiro-IOC support date formatted in JAXB style.
Example setter injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.BeanWithDate">		
		<property name="date"><date>2009-09-20T21:45:49.296+02:00</date></property>
	</object>	
	
</objects>
```

Example constructor date injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>

	<object id="objectOne" class="org.toshiroioc.test.beans.ObjectConstructorDate">
		<constructor-arg><date>2009-09-20T21:45:49.296+02:00</date></constructor-arg>
	</object>
	
</objects>
```
### Injecting null values ###

Example null in setter injection:

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.SimpleBean">	
		<property name="stringItem"><null/></property>		
	</object>
</objects>
```

### Injecting class objects ###
Toshiro-IOC can inject Class object from full domain class name representation.

Example setter injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>

	<object id="objectOne" class="org.toshiroioc.test.beans.SimpleBean">
		<property name="clazzItem" class="flash.display.Sprite"/>	
	</object>
	
</objects>
```

Example constructor injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.BeanWithConstructor">
		<constructor-arg value="-99999"/>
		<constructor-arg value="1111"/>		
		<constructor-arg value="some123String"/>
		<constructor-arg value="true"/>		
		<constructor-arg const="org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT"/>
		<constructor-arg class="org.toshiroioc.test.beans.SimpleBean"/>
		...		
	</object>
</objects>	
```

To pass Class object as an argument, one has to use `class` attribute.

### Injecting array objects ###
Toshiro-IOC is capable of injecting nested array objects. Number of nested levels is unlimited.
Example setter injection:
```
<object id="setterWithArray" class="org.toshiroioc.test.beans.SetterWithArrays">
	<property name="booleanItem" value="true"/>
	<property name="simpleArrayItem">
		<array>
			<entry>
				<object class="org.toshiroioc.test.beans.SimpleBean">
					<property name="numberItem" value="2"/>
				</object>
			</entry>
			<entry>
				<const>
					org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT
				</const>
			</entry>
			<entry>
				<array>
					<entry>
						<number>
							12
						</number>
					</entry>
					<entry>
						<object class="org.toshiroioc.test.beans.SetterWithArrays">
							<property name="simpleArrayItem">
								<array>
									<entry>
										<number>
											13
										</number>
									</entry>
									<entry>
										<string>
											innerArrayOfInnerObjectOfInnerArray
										</string>
									</entry>
									<entry>
										<object class="org.toshiroioc.test.beans.SimpleBean">
											<property name="stringItem" value="deepEnough"/>
										</object>
									</entry>
								</array>
							</property>
						</object>
					</entry>
				</array>
			</entry>
		</array>
	</property>	
	<property name="objectsArrayItem">
		<array>
			<entry>
				<number>
					2
				</number>
			</entry>
		</array>
	</property>
</object>

```
Example constructor injection:
```
<object id="objectOne" class="org.toshiroioc.test.beans.ConstructorWithArrays">
	<constructor-arg value="-99999"/>
	<constructor-arg>
		<array>
			<entry>
				<class>
					org.toshiroioc.test.beans.SimpleBean
				</class>
			</entry>
			<entry>
				<array>
					<entry>
						<number>
							12
						</number>
					</entry>
					<entry>
						<const>
							org.toshiroioc.core.FieldDescription.FIELD_TYPE_CONST
						</const>
					</entry>
					<entry>
						<object class="org.toshiroioc.test.beans.SimpleBean">
							<property name="stringItem" value="innerObjectOfInnerArray"/>
						</object>
					</entry>
				</array>
			</entry>
		</array>
	</constructor-arg>
	<constructor-arg>
		<array>
			<entry>
				<object class="org.toshiroioc.test.beans.SimpleBean">
					<property name="numberItem" value="1"/>
				</object>
			</entry>
			<entry>
				<number>
					2
				</number>
			</entry>
			<entry>
				<object class="org.toshiroioc.test.beans.SimpleBean">
					<property name="numberItem" value="3"/>
				</object>
			</entry>
		</array>
	</constructor-arg>
	<property name="someAdditionalString" value="objectsOne"/>	
</object>	
```
Supported tags: number, int, uint, string, boolean, date, class, array, object, const.
Each element of an array has to be embraced with 'entry' tag.
When 'entry' tag is empty or with multiple children error is thrown.
**References from inner beans are not supported (yet).**

### Injecting objects ###
The primary purpose of every DI engine is injection of objects.

Example setter injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	
	<!-- object without dependency -->
	<object id="object5" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">		
		
	</object>
	
	<object id="object4" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">		
		<property name="nextChild" ref="object3"/>		
	</object>
		
	<object id="object2" class="org.toshiroioc.test.beans.SimpleDependencyObject">		
		<property name="someChild" ref="objectChild"/>		
		<property name="someString" value="some123$#"/>
	</object>
	
	<object id="objectChild" class="org.toshiroioc.test.beans.BeanWithConstructor">
		<constructor-arg value="-99999"/>
		<constructor-arg value="1111"/>		
		<constructor-arg value="some123String"/>
		<constructor-arg value="true"/>		
		
		<property name="someAdditionalString" value="false"/>		
	</object>	
	
	<object id="object3" class="org.toshiroioc.test.beans.SimpleDependencyObject">	
		<property name="someChild" ref="objectChild"/>				
	</object>		
		
</objects>
```

Example constructor injection:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>

	<!-- object without dependency -->
	<object id="object5"
		class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">

	</object>

	<object id="object4"
		class="org.toshiroioc.test.beans.ObjectWithConstructorDependency">
		<constructor-arg ref="object1" />
	</object>

	<object id="object1" class="org.toshiroioc.test.beans.SimpleBean">
		<property name="booleanItem" value="true"/>
		<property name="stringItem"  value="some123String"/>
		<property name="intItem" value="-99999"/>
		<property name="uintItem" value="1111"/>
		<property name="numberItem" value="9999.00001"/>
	</object>

</objects>
```

### Dynamic context load ###
Toshiro-IOC provides you with a possibility to load configuration xml files at a runtime.
After context has been initialized, just call `loadDynamicConfig(xml:XML):void` method with configuration xml as an argument, whenever you wish to add beans' definitions to the context. They can reference beans loaded in previous configs as normal. Example:
```
var xml:XML = constructXMLFromEmbed(SimpleDynamicConfigXMLClass1);
var context:XMLBeanFactory = new XMLBeanFactory(xml);
context.initialize();
xml = constructXMLFromEmbed(SimpleDynamicConfigXMLClass2);
context.loadDynamicConfig(xml);
```
After successful load of dynamic config, an `Event.COMPLETE` is being dispatched, otherwise an Error, which was the reason of unsuccessful load is being thrown and context is being restored to previous state, without beans from unsuccessfully loaded configuration file.
You can use the feature to load multiple configs at startup, just pass array of xml strings to context and then call initialize():
```
var context:XMLBeanFactory = new XMLBeanFactory(xml);
var configs:Array = [constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass).toXMLString(), constructXMLFromEmbed(SimpleDynamicConfigXMLClass2).toXMLString()];
			context.addConfigsToDynamicLoadAtStartup(configs);
			context.initialize();
```

### Multiple config files ###
Besides the feature described above, there exist one other way to split bean definitions into multiple config files. That feature is meant to be used to separate beans' definitions into logical parts to facilitate navigation between them. It's easier to find what you are looking for in smaller files than in one huge file with definitions of beans. XML strings with beans are passed to context, before initializing, they are concatenated and then parsed, so the normal rules of references between beans apply (in contrast to dynamic configs, where it is possible to reference beans loaded before, but not the other way). Example:
```
var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var configs:Array = [constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass).toXMLString(), constructXMLFromEmbed(SimpleDynamicConfigXMLClass2).toXMLString()];
			context.concatConfigsWithMainXML(configs);
			context.initialize();
```

### Optional bean reference ###
It is possible to configure beans in a way, that reference to a bean is being satisfied after dynamic context load. If you wish Toshiro-IOC to inject a bean to a property, when it becomes available in a context, after dynamically loaded configuration file, you have to mark parent's property with defined reference with `optional` attribute set to true.
Main config bean example:
```
<object id="object1" class="org.toshiroioc.test.beans.ComplexDependencyObject">	
	<property name="someChild" ref="objectChild" optional="true"/>
	<property name="someChild2" ref="objectChildNotOptional" />
	<property name="someString" value="someString" />
</object>	 
```
Dynamically loaded config bean example:
```
<object id="objectChild" class="org.toshiroioc.test.beans.SimpleDependencyObject">
	<property name="someString" value="false"/>			
</object>	
```

### Class postprocessors ###
With Toshiro-IOC you are able to register class postprocessors implementing IClassPostprocessor with `registerClassPostprocessor(postprocessor:IClassPostprocessor):void` and therefore gain possibility to call some additional configuration  logic just after object configuration (and after `[AfterConfigure]` methods) and at the end of context initialization or load. Such a postprocessor is called every time, when object of a class listed in `listClassInterests` has been configured. There is a possibility of registering multiple postprocessors for a single class, which in the case are called in register order and with output of previous postprocessor piped to input of next one in a queue.
Example registration:
```
context.registerClassPostprocessor(new PureMVCClassPostprocessor(this));
```
and IClassPostprocessor:
```
public interface IClassPostprocessor
	{
		function listClassInterests():Vector.<Class>;
		function postprocessObject(object:*):*;
		function onContextLoaded():void;	
	}
```

### Object lifecycle ###
Toshiro-IOC supports both singleton and prototype mode. Singleton mode is default. In order to make the bean to behave like prototype the bean should be marked with attribute `lifecycle="prototype"`.

Full example:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	
	<!-- object without dependency -->
	<object id="object5" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">		
		<property name="nextChild" ref="object3"/>
	</object>
	
	<object id="object4" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">		
		<property name="nextChild" ref="object3"/>		
	</object>
		
	<object id="object2" class="org.toshiroioc.test.beans.SimpleDependencyObject">		
		<property name="someChild" ref="objectChild"/>		
		<property name="someString" value="some123$#"/>
	</object>
	
	<object id="objectChild" lifecycle="prototype" class="org.toshiroioc.test.beans.BeanWithConstructor">
		<constructor-arg value="-99999"/>
		<constructor-arg value="1111"/>		
		<constructor-arg value="some123String"/>
		<constructor-arg value="true"/>		
		
		<property name="someAdditionalString" value="false"/>		
	</object>	
	
	<object id="object3" class="org.toshiroioc.test.beans.SimpleDependencyObject">	
		<property name="someChild" ref="objectChild"/>				
	</object>		
		
</objects>
```
### Toshiro special beans ###
Some beans' names are restricted and beans with these names are treated by toshiro as special. Usually they have to implement some interface provided by toshiro. These beans have to be defined at the top of root xml. Restricted names are:
  * `toshiro.i18nProvider` - has to implement `II18nProvider` in order to provide localization capabilities - injecting localized strings by toshiro into setters with `[`i18n`] tag.
### AS3 metatags ###
Toshiro-IOC already supports following tags, which can be used directly in your code to provide you with special configuration options. Metatags are extended from parent class and work only for public methods/accessors.
  * [`BeforeConfigure`] - lifecycle metatag, methods labelled with it will be called after object instantiation, but before it is configured. The sequence of the calls is undefined.
  * [`AfterConfigure`] - lifecycle metatag, methods labelled with it will be called after object instantiation and configuration. The sequence of the calls is undefined.
  * [`Required`] - if accessor labelled with it is not called by container (property is not set) a ContainerError will be thrown.
  * [`ToshiroIOCFactory`] - setter with IBeanFactory as an argument labelled with it will be called with current XMLBeanFactory (injection of current context).
  * [`BeanId`] - setter tagged with the tag gets bean's id as an argument.
  * [`i18n`] - setter tagged with the tag gets localized string as an argument returned by  toshiro.i18nProvider bean's getString method. If accessor type is not String, `ArgumentError` will be thrown.

### Recursive processing of beans, inner beans' id support ###
Toshiro is now enabled to process beans' definitions in a recursive way, meaning user is able to define a bean inline within an array for example, give it an id, and to reference that bean from anywhere. There is ability for beans to reference each other regardless of level they are nested.
```
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<objects>

	<object id="arraySetter" class="org.toshiroioc.test.beans.SetterWithArrays">
		<property name="simpleArrayItem">
			<array>
				<entry>
					<object id="objectOne" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyChildrenSetter">
						<property name="someChild" ref="objectTwo"/>
					</object>
				</entry>
				<entry>
					<object id="innerObject" class="org.toshiroioc.test.beans.SimpleDependencyObject"/>
				</entry>
			</array>
		</property>
	</object>

	<object id="outerBean" class="org.toshiroioc.test.beans.SimpleDependencyObject">
		<property name="someString" value="exampleString"/>
	</object>
	
	<object id="objectTwo" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">
		<property name="nextChild" ref="outerBean"/>
	</object> 
	
	<object id="outerBean2" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">
		<property name="nextChild" ref="innerObject"/>
	</object>
	
</objects>
```

### Referencing beans from array entries ###
It's possible for developer to reference from array entry any bean with id, what results in sharing single object instance between beans.
```
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<objects>
	<object id="objectOne" class="org.toshiroioc.test.beans.ConstructorWithArrays">
		<constructor-arg>
			<number>2</number>
		</constructor-arg>
		<constructor-arg>
			<array>
				<entry>
					<object ref="outerBean"/>
				</entry>
				<entry>
					<object id="innerBean" class="org.toshiroioc.test.beans.SimpleDependencyObject">
						<property name="someString" value="exampleString"/>
					</object>
				</entry>
				<entry>
					<object ref="innerBean"/>
				</entry>
			</array>
		</constructor-arg>
	</object>
	
	<object id="outerBean" class="org.toshiroioc.test.beans.ParentOfSimpleDependencyObject">
		<property name="nextChild" ref="sampleId"/>
	</object>
	
	<object id="innerRefObject" class="org.toshiroioc.test.beans.ConstructorWithArrays">
		<constructor-arg>
			<number>2</number>
		</constructor-arg>
		<constructor-arg>
			<array>
				<entry>
					<object ref="sampleId"/>
				</entry>
				<entry>
					<object id="sampleId" class="org.toshiroioc.test.beans.SimpleDependencyObject"/>
				</entry>
			</array>
		</constructor-arg>
	</object>
	
</objects>
```
Test for this feature:
```
	public function testRefBean():void{
			var xml:XML = constructXMLFromEmbed(RefBean);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var constructorWithArray:ConstructorWithArrays = context.getObject('objectOne');
			var outerBean:ParentOfSimpleDependencyObject = context.getObject('outerBean');
			var array:Array = constructorWithArray.simpleArrayItem;
			var refBean:* = array[0];
			var innerRefObject:ConstructorWithArrays = context.getObject('outerRefObject');
			assertTrue(refBean == outerBean);
			assertEquals(array.length, 3)
			assertEquals(array[1], context.getObject("innerBean"))
			var array2:Array = innerRefObject.simpleArrayItem;
			assertTrue(array2[1] == array2[0]);
			assertNotNull(array2[1]);
		}
```