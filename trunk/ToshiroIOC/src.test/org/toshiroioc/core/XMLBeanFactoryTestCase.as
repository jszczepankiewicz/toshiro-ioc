package org.toshiroioc.core
{
	import flash.utils.getDefinitionByName;
	
	import flexunit.framework.Test;
	import flexunit.framework.TestSuite;
	
	import org.toshiroioc.ContainerError;
	import org.toshiroioc.test.BaseTestCase;
	import org.toshiroioc.test.beans.BeanWithConstructor;
	import org.toshiroioc.test.beans.BeanWithDate;
	import org.toshiroioc.test.beans.CyclicConstructor;
	import org.toshiroioc.test.beans.CyclicConstructorAndSetter;
	import org.toshiroioc.test.beans.CyclicSetter;
	import org.toshiroioc.test.beans.ObjectConstructorDate;
	import org.toshiroioc.test.beans.ObjectWithConstructorDependency;
	import org.toshiroioc.test.beans.ParentOfSimpleDependencyObject;
	import org.toshiroioc.test.beans.SimpleBean;
	import org.toshiroioc.test.beans.SimpleBeanWithMetatags;
	import org.toshiroioc.test.beans.SimpleBeanWithMetatagsExtended;
	import org.toshiroioc.test.beans.SimpleBeanWithoutMetatags;
	import org.toshiroioc.test.beans.SimpleDependencyObject;

	/*
	 * TODO:	replace * types with direct types, test bean dependency without ref
	 */
	public class XMLBeanFactoryTestCase extends BaseTestCase{
		
		[Embed(source="assets/simpleobjectsetter.xml", mimeType="application/octet-stream")]
		private var SimpleObjectSetterClass:Class;
		
		[Embed(source="assets/setterwithnull.xml", mimeType="application/octet-stream")]
		private var SetterWithNullXMLClass:Class;
		
		[Embed(source="assets/setterclass.xml", mimeType="application/octet-stream")]
		private var SetterWithClassXMLClass:Class;
		
		[Embed(source="assets/constructorsimpletype.xml", mimeType="application/octet-stream")]
		private var ConstructorSimpleTypeXMLClass:Class;
		
		[Embed(source="assets/setterdate.xml", mimeType="application/octet-stream")]
		private var SetterDateTypeXMLClass:Class;
		
		[Embed(source="assets/constructordate.xml", mimeType="application/octet-stream")]
		private var ConstructorDateXMLClass:Class;
		
		[Embed(source="assets/dependencysimplesetter.xml", mimeType="application/octet-stream")]
		private var DependencySimpleSetterXMLClass:Class;
		
		[Embed(source="assets/dependencysimpleconstructor.xml", mimeType="application/octet-stream")]
		private var DependencySimpleConstructorXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromsetters.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromSettersXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromconstructors.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromConstructorsXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromconstructortosetter.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromConstructorToSetterXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromsettertoconstructor.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromSetterToConstructorXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromsetterscomplex.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromSettersComplexXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromconstructorscomplex.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromConstructorsComplexXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromconstructortosettercomplex.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromConstructorToSetterComplexXMLClass:Class;
		
		[Embed(source="assets/cyclicdepeendencyfromsettertoconstructorcomplex.xml", mimeType="application/octet-stream")]
		private var CyclicDependencyFromSetterToConstructorComplexXMLClass:Class;
		
		[Embed(source="assets/lifecycle.xml", mimeType="application/octet-stream")]
		private var LifecycleXMLClass:Class;
		
		[Embed(source="assets/issingleton.xml", mimeType="application/octet-stream")]
		private var IsSingletonXMLClass:Class;
		
		[Embed(source="assets/constructorwithstaticref.xml", mimeType="application/octet-stream")]
		private var ConstructorWithStaticReferenceXMLClass:Class;
		
		[Embed(source="assets/setterclasswithstaticref.xml", mimeType="application/octet-stream")]
		private var SetterWithStaticReferenceXMLClass:Class;
		
		[Embed(source="assets/simplesettermetatags.xml", mimeType="application/octet-stream")]
		private var MetatagsXMLClass:Class;
		
		[Embed(source="assets/dependencynotexistingsimplesetter.xml", mimeType="application/octet-stream")]
		private var SetterWithoutDependencyXMLClass:Class;
		
		[Embed(source="assets/requiredmetatag.xml", mimeType="application/octet-stream")]
		private var RequiredMetatagXMLClass:Class;
		
		[Embed(source="assets/requiredmetatagsatisfied.xml", mimeType="application/octet-stream")]
		private var RequiredMetatag2XMLClass:Class;
		
		[Embed(source="assets/extendedmetatags.xml", mimeType="application/octet-stream")]
		private var ExtendingMetatagsXMLClass:Class;
		
		public function XMLBeanFactoryTestCase(methodName:String){
			super(methodName);
		}
		
		public function testBeforeAndAfterMetatags():void{
			var xml:XML = constructXMLFromEmbed(MetatagsXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithMetatags:SimpleBeanWithMetatags = context.getObject("objectWithTags") as SimpleBeanWithMetatags;
			assertNotNull(simpleBeanWithMetatags);
			assertEquals(simpleBeanWithMetatags.beforeConfigureMethodInvocation, true);
			assertEquals(simpleBeanWithMetatags.afterConfigureMethodInvocation, true);
			
			var simpleBeanWithoutMetatags:SimpleBeanWithoutMetatags = context.getObject("objectWithoutTags") as SimpleBeanWithoutMetatags;
			assertNotNull(simpleBeanWithoutMetatags);
			assertEquals(simpleBeanWithoutMetatags.beforeConfigureMethodInvocation, false);
			assertEquals(simpleBeanWithoutMetatags.afterConfigureMethodInvocation, false);  
			 
		}
		
	 	// checks if tags are extendable
	 	public function testBeforeAndAfterMetatagsExtended():void{
			var xml:XML = constructXMLFromEmbed(ExtendingMetatagsXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithMetatags:SimpleBeanWithMetatagsExtended = context.getObject("objectWithTags") as SimpleBeanWithMetatagsExtended;
			assertNotNull(simpleBeanWithMetatags);
			assertEquals(simpleBeanWithMetatags.beforeConfigureMethodInvocation, true);
			assertEquals(simpleBeanWithMetatags.afterConfigureMethodInvocation, true);
			
		}
	 	
		public function testRequiredMetatagNotSatisfied():void{

			var xml:XML = constructXMLFromEmbed(RequiredMetatagXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error: ContainerError;

			try{
				context.initialize();
			}
			catch(err: ContainerError){
				error = err; 
			} 
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_REQUIRED_METATAG_NOT_SATISFIED, error.errorCode);
			
		} 
		
		public function testRequiredMetatagSatisfied():void{

			var xml:XML = constructXMLFromEmbed(RequiredMetatag2XMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithRequired:SimpleBeanWithMetatags = context.getObject("objectWithRequired") as SimpleBeanWithMetatags;
			assertNotNull(simpleBeanWithRequired);
		} 
		
		public function testDependencyNotExistingInConfig():void{
			var xml:XML = constructXMLFromEmbed(SetterWithoutDependencyXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error: ContainerError;
			
			try{
				context.initialize();
			}
			catch(err: ContainerError){
				error = err; 
			} 
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_OBJECT_NOT_FOUND, error.errorCode);
		}
		
		public function testLifecycle():void{ 
			var xml:XML = constructXMLFromEmbed(LifecycleXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			
			var clazz:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.SimpleDependencyObject"))
			
			var object2:SimpleDependencyObject = context.getTypedObject("object2", clazz);
			assertNotNull(object2);
			assertTrue(object2 is SimpleDependencyObject);	
			assertNotNull(object2.someChild);
			assertTrue(object2.someChild is BeanWithConstructor);
			assertEquals("some123$#", object2.someString);
			
			var object3:SimpleDependencyObject = context.getTypedObject("object3", clazz);
			assertNotNull(object3);			
			assertNotNull(object3.someChild);
			assertTrue(object3.someChild is BeanWithConstructor);
						
			assertEquals (-99999, object3.someChild.someNumber);
			assertEquals (1111, object3.someChild.someInt);
			assertEquals ("some123String", object3.someChild.someString);
			assertEquals (true, object3.someChild.someBoolean);
			
			assertEquals (-99999, object2.someChild.someNumber);
			assertEquals (1111, object2.someChild.someInt);
			assertEquals ("some123String", object2.someChild.someString);
			assertEquals (true, object2.someChild.someBoolean);
			
			var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ParentOfSimpleDependencyObject"));
			var object4:ParentOfSimpleDependencyObject = context.getTypedObject("object4", clazz4);			
			assertNotNull(object4);
			
			var object5:ParentOfSimpleDependencyObject = context.getTypedObject("object5", clazz4);			
			assertNotNull(object5);
			
			//	both child classes should be equals (singletons)
			assertEquals(object4.nextChild, object5.nextChild);
			
			//	both child classes should be not equals (prototypes)
			if(object2.someChild == object3.someChild){
				fail("prototype objects should be different but are the same");
			}
			//assertNotEquals(object2.someChild, object3.someChild);
			
			
		}
		

		
		
		public function testInstantiateBeanByID():void{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			assertNotNull(beanOne);		
			assertTrue(beanOne is SimpleBean);
			
			var beanTwo:* = context.getObject("objectTwo");
			assertNotNull(beanTwo);
			assertTrue(beanTwo is SimpleBean);
		}
				
		public function testBeanNotFound():void{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var exceptionThrown:Boolean = false;
			try{
				var bean:* = context.getObject("nonExistentObject");
			}
			catch(err:ContainerError){
				exceptionThrown = true;
			}
			assertNull(bean);
			assertTrue(exceptionThrown);
		}
		
		
		
		public function testSetterNumber():void{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:SimpleBean = context.getObject("objectOne");
			assertNotNull(beanOne);		
			assertTrue(beanOne is SimpleBean);
			
			var beanTwo:SimpleBean = context.getObject("objectTwo");
			assertNotNull(beanTwo);
			assertTrue(beanTwo is SimpleBean);
			
			assertEquals(1111,beanOne.uintItem);
			assertEquals(-99999,beanOne.intItem);
			assertEquals(9999.00001,beanOne.numberItem);
			
			assertEquals(0,beanTwo.uintItem);
			assertEquals(999,beanTwo.intItem);
			assertEquals(-123456.99987,beanTwo.numberItem);
			
		}
		
		public function testConstructorDate():void{
			var xml:XML = constructXMLFromEmbed(ConstructorDateXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			assertNotNull(beanOne);		
			assertTrue(beanOne is ObjectConstructorDate);
			
			var dateConverted:Date = beanOne.date;
			assertNotNull(dateConverted);
			
			assertEquals(2009, dateConverted.fullYear);
			assertEquals(9, dateConverted.month);
			assertEquals(20, dateConverted.date);
			assertEquals(21, dateConverted.hours);
			assertEquals(45, dateConverted.minutes);
			assertEquals(49, dateConverted.seconds);
			assertEquals(296, dateConverted.milliseconds);
			
			
		}
		
		public function testSetterDate():void{
			var xml:XML = constructXMLFromEmbed(SetterDateTypeXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			assertNotNull(beanOne);		
			assertTrue(beanOne is BeanWithDate);
			
			var dateConverted:Date = beanOne.date;
			assertNotNull(dateConverted);
			
			assertEquals(2009, dateConverted.fullYear);
			assertEquals(9, dateConverted.month);
			assertEquals(20, dateConverted.date);
			assertEquals(21, dateConverted.hours);
			assertEquals(45, dateConverted.minutes);
			assertEquals(49, dateConverted.seconds);
			assertEquals(296, dateConverted.milliseconds);

		}
		
		public function testSetterString():void{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);	
			assertEquals("some123String", beanOne.stringItem);
		}
		
		
		public function testSetterWithClass():void{
			var xml:XML = constructXMLFromEmbed(SetterWithClassXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);
			assertNotNull(beanOne.clazzItem);	
			assertEquals(beanOne.clazzItem,Class(getDefinitionByName("flash.display.Sprite")));
			
		}
		
		
		
		public function testSetterWithBoolean():void{
			
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);	
			assertTrue(beanOne.booleanItem);
			
			var beanTwo:* = context.getObject("objectTwo");
			assertNotNull(beanTwo);
			assertTrue(beanTwo is SimpleBean);
			assertFalse(beanTwo.booleanItem);
		}
		
		public function testSetterWithImplicitNull():void{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);	
			assertNull(beanOne.stringItem);
			
			var beanTwo:* = context.getObject("objectTwo");
			assertNotNull(beanTwo);
			assertTrue(beanTwo is SimpleBean);
			assertEquals("", beanTwo.stringItem);
			
			var beanThree:* = context.getObject("objectThree");
			assertNotNull(beanThree);
			assertTrue(beanThree is SimpleBean);
			assertEquals("", beanThree.stringItem);
			
		}
		
		public function testInstantiateByConstructorSimpleType():void{
			
			var xml:XML = constructXMLFromEmbed(ConstructorSimpleTypeXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			
			assertNotNull(beanOne);
			assertTrue(beanOne is BeanWithConstructor);		
			
			//	checking values set by setters
			assertEquals ("false", beanOne.someAdditionalString);
			
			//	checking values set by constructor
			assertEquals (-99999, beanOne.someNumber);
			assertEquals (1111, beanOne.someInt);
			assertEquals ("some123String", beanOne.someString);
			assertEquals (true, beanOne.someBoolean);
			
			//	checking for nulled argument
			var beanTwo:* = context.getObject("objectTwo");
			
			assertNotNull(beanTwo);
			assertTrue(beanTwo is BeanWithConstructor);		
			
			//	checking values set by setters
			assertEquals ("enedueRikeFake", beanTwo.someAdditionalString);
			
			//	checking values set by constructor
			assertEquals (-99999.6, beanTwo.someNumber);
			assertEquals (1111, beanTwo.someInt);
			assertEquals (null, beanTwo.someString);			
			assertEquals (false, beanTwo.someBoolean);
			
		}
		
		/*
		public function testInstantiateByConstructorNewClass():void{
			fail("unimplemented");
		}
		
		public function testConstructorWithArray():void{
			fail("unimplemented");
		}

		public function testConstructorWithMap():void{
			fail("unimplemented");
		}	

		public function testSetterWithArray():void{
			fail("unimplemented");
		}

		public function testSetterWithMap():void{
			fail("unimplemented");
		}			
		
		public function testMultipartXml():void{
			fail("unimplemented");
		}
		*/
		public function testContainsBean():void{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			assertTrue(context.containsObject("objectOne"));
			assertFalse(context.containsObject("notExistingBeanName"));
			
		}
		
		public function testGetTypedBean():void{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var clazz:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean"))
			
			var beanOne:* = context.getTypedObject("objectOne", clazz);
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);	
			
			//	testing the exception throwing if not expected type
			
			var error:ContainerError = null;
			var invalidClazz:Class = Class(getDefinitionByName("flash.display.Sprite"));
			
			try{
				var bean:* = context.getTypedObject("objectOne", invalidClazz);
			}
			catch(err:ContainerError){
				error = err;
			}
			assertNull(bean);
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_INVALID_OBJECT_TYPE, error.errorCode);
			
		}
		
		public function testGetType():void{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var clazz:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean"));
			assertEquals(clazz, context.getType("objectOne"));
		}
		
		public function testIsSingleton():void{
			var xml:XML = constructXMLFromEmbed(IsSingletonXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			
			assertTrue	(context.isSingleton("object2"));			
			assertTrue	(context.isSingleton("object3"));
			assertTrue	(context.isSingleton("object4"));
			assertTrue	(context.isSingleton("object5"));
			assertFalse	(context.isSingleton("objectChild"));
			
			//	todo: throw exception if bean not found
		}
		
		public function testCyclicDependencyFromConstructorToSetter():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorToSetterXMLClass);
			
			var error:ContainerError = null;
			var typeToBeLinkedByFlash:CyclicConstructorAndSetter;
								
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromConstructorToSetterComplex():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorToSetterComplexXMLClass);
			
			var error:ContainerError = null;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSetterToConstructor():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSetterToConstructorXMLClass);
			
			var error:ContainerError = null;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSetterToConstructorComplex():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSetterToConstructorComplexXMLClass);
			
			var error:ContainerError = null;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSetters():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSettersXMLClass);
			
			var typeToBeLinkedByFlashCompiler:CyclicSetter;
			
			var error:ContainerError = null;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSettersComplex():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSettersComplexXMLClass);
			
			var error:ContainerError = null;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromConstructors():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorsXMLClass);
			
			var error:ContainerError = null;
			
			var typeToBeLinkedByFlashCompiler:CyclicConstructor;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromConstructorsComplex():void{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorsComplexXMLClass);
			
			var error:ContainerError = null;
						
			try{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testSimpleDependencySetter():void{
			
			var xml:XML = constructXMLFromEmbed(DependencySimpleSetterXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			
			var clazz:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.SimpleDependencyObject"))
			
			var beanOne:SimpleDependencyObject = context.getTypedObject("object2", clazz);
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleDependencyObject);	
			assertNotNull(beanOne.someChild);
			assertTrue(beanOne.someChild is BeanWithConstructor);
			assertEquals("some123$#", beanOne.someString);
			
			var beanTwo:* = context.getTypedObject("object3", clazz);
			assertNotNull(beanTwo);
			assertTrue(beanTwo is SimpleDependencyObject);
			assertNotNull(beanTwo.someChild);
			assertTrue(beanTwo.someChild is BeanWithConstructor);
			
			assertEquals(beanTwo.someChild, beanOne.someChild);
			
			assertEquals (-99999, beanTwo.someChild.someNumber);
			assertEquals (1111, beanTwo.someChild.someInt);
			assertEquals ("some123String", beanTwo.someChild.someString);
			assertEquals (true, beanTwo.someChild.someBoolean);
			
			var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ParentOfSimpleDependencyObject"));
			var bean4:* = context.getTypedObject("object4", clazz4);
			assertTrue(bean4 is ParentOfSimpleDependencyObject);
		}
		
		public function testSimpleDependencyConstructor():void{
			
			
			var xml:XML = constructXMLFromEmbed(DependencySimpleConstructorXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			//	class without dependencies
			var clazz5:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ParentOfSimpleDependencyObject"));
			var bean5:ParentOfSimpleDependencyObject = context.getTypedObject("object5", clazz5);
			assertNotNull(bean5);
			
			//	class that is child			
			var clazz1:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean"));
			var bean1:SimpleBean = context.getTypedObject("object1", clazz1);
			assertNotNull(bean1);
			
			assertEquals(1111,bean1.uintItem);
			assertEquals(-99999,bean1.intItem);
			assertEquals(9999.00001,bean1.numberItem);
			
			//	parent class
			var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ObjectWithConstructorDependency"));
			var bean4:ObjectWithConstructorDependency = context.getTypedObject("object4", clazz4);
			assertTrue(bean4 is ObjectWithConstructorDependency);
			
			assertNotNull(bean4.simpleChild);
			assertTrue(bean4.simpleChild is SimpleBean);
			assertEquals(bean1, bean4.simpleChild);
		}
		
		  public function testStaticReferenceInConstructor():void{
			var xml:XML = constructXMLFromEmbed(ConstructorWithStaticReferenceXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			var error:ContainerError;
			
			//	testing the exception thrown during initialization,
			//		if static variable of some bean doesn't exist
			
			try{
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
				trace(error);
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_INVALID_STATIC_REFERENCE, error.errorCode);
			
			// testing initialization and reference to static variable, if correct
			
			var beanWithCorrectStaticReference:BeanWithConstructor = context.getTypedObject("objectOne", org.toshiroioc.test.beans.BeanWithConstructor);
			assertNotNull(beanWithCorrectStaticReference);
			assertEquals(7, beanWithCorrectStaticReference.someStatic);
		}  
		
		 public function testStaticReferenceInSetter():void{
		 	
		 	var xml:XML = constructXMLFromEmbed(SetterWithStaticReferenceXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			
			try{
				context.initialize();
			}
			catch(err:ContainerError){
				error = err;
				trace(error);
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_INVALID_STATIC_REFERENCE, error.errorCode);
			
			var bean:SimpleBean = context.getTypedObject("objectOne", SimpleBean);
			assertNotNull(bean);
			assertEquals(7, bean.staticRefItem)
			
			
			
			
		}  
		
		public function testScopePrototype():void{
			fail("unimplemented");
		}
		
		
		public static function suite():TestSuite{
			
			var testTS:TestSuite = new TestSuite();
			var tests2:Vector.<Test> = getTestsArr();
			for each (var value:Test in tests2) {
				testTS.addTest(value);
			}			
						
			return testTS;	
		}
		
		public static function getTestsArr():Vector.<Test>{
			var retval:Vector.<Test> = new Vector.<Test>();		
			
 			
			retval.push(new XMLBeanFactoryTestCase("testBeforeAndAfterMetatags"));
			retval.push(new XMLBeanFactoryTestCase("testRequiredMetatagNotSatisfied"));
			retval.push(new XMLBeanFactoryTestCase("testRequiredMetatagSatisfied"));
			retval.push(new XMLBeanFactoryTestCase("testBeforeAndAfterMetatagsExtended"));
			retval.push(new XMLBeanFactoryTestCase("testDependencyNotExistingInConfig")); 
			retval.push(new XMLBeanFactoryTestCase("testInstantiateBeanByID"));			
			retval.push(new XMLBeanFactoryTestCase("testSetterNumber"));
			retval.push(new XMLBeanFactoryTestCase("testSetterString"));
			retval.push(new XMLBeanFactoryTestCase("testSetterDate"));			
			retval.push(new XMLBeanFactoryTestCase("testSetterWithBoolean"));
						
			retval.push(new XMLBeanFactoryTestCase("testSetterWithClass"));			
									
			retval.push(new XMLBeanFactoryTestCase("testSetterWithImplicitNull"));
			retval.push(new XMLBeanFactoryTestCase("testInstantiateByConstructorSimpleType"));
						
			retval.push(new XMLBeanFactoryTestCase("testConstructorDate"));
			
			retval.push(new XMLBeanFactoryTestCase("testSimpleDependencySetter"));
			
			retval.push(new XMLBeanFactoryTestCase("testSimpleDependencyConstructor"));
						
			retval.push(new XMLBeanFactoryTestCase("testBeanNotFound"));
			retval.push(new XMLBeanFactoryTestCase("testContainsBean"));
			retval.push(new XMLBeanFactoryTestCase("testGetType"));
			retval.push(new XMLBeanFactoryTestCase("testIsSingleton"));
			retval.push(new XMLBeanFactoryTestCase("testGetTypedBean"));
			
			retval.push(new XMLBeanFactoryTestCase("testLifecycle"));
			
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromSetters"));
			
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromConstructors"));
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromConstructorToSetter"));
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromSetterToConstructor"));
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromSettersComplex"));
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromConstructorsComplex"));
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromConstructorToSetterComplex"));
			retval.push(new XMLBeanFactoryTestCase("testCyclicDependencyFromSetterToConstructorComplex"));
			retval.push(new XMLBeanFactoryTestCase("testStaticReferenceInConstructor"));
			retval.push(new XMLBeanFactoryTestCase("testStaticReferenceInSetter")); 
			 
 			
			/*
			retval.push(new XMLBeanFactoryTestCase("testInstantiateByConstructorNewClass"));
			retval.push(new XMLBeanFactoryTestCase("testConstructorWithArray"));
			retval.push(new XMLBeanFactoryTestCase("testConstructorWithMap"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithArray"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithMap"));
			*/
			
			
			
			return retval;
		}
		
		
		
	}
}