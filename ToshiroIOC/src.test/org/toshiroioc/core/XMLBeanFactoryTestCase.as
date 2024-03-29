package org.toshiroioc.core
{
	import __AS3__.vec.Vector;
	
	import flash.utils.getDefinitionByName;
	
	import flexunit.framework.Test;
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;
	
	import org.DynamicModule;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.toshiroioc.ContainerError;
	import org.toshiroioc.plugins.puremvc.multicore.CommandMap;
	import org.toshiroioc.plugins.puremvc.multicore.SetterMap;
	import org.toshiroioc.test.BaseTestCase;
	import org.toshiroioc.test.beans.BeanIdMetatag;
	import org.toshiroioc.test.beans.BeanWithConstructor;
	import org.toshiroioc.test.beans.BeanWithConstructorAndMetatags;
	import org.toshiroioc.test.beans.BeanWithConstructorAndMetatagsWithoutProperties;
	import org.toshiroioc.test.beans.BeanWithDate;
	import org.toshiroioc.test.beans.ConstructorWithArrays;
	import org.toshiroioc.test.beans.CyclicConstructor;
	import org.toshiroioc.test.beans.CyclicConstructorAndSetter;
	import org.toshiroioc.test.beans.CyclicSetter;
	import org.toshiroioc.test.beans.I18NBean;
	import org.toshiroioc.test.beans.ObjectConstructorDate;
	import org.toshiroioc.test.beans.ObjectWithConstructorDependency;
	import org.toshiroioc.test.beans.ParentOfSimpleDependencyChildrenSetter;
	import org.toshiroioc.test.beans.ParentOfSimpleDependencyObject;
	import org.toshiroioc.test.beans.SetterWithArrays;
	import org.toshiroioc.test.beans.SimpleBean;
	import org.toshiroioc.test.beans.SimpleBeanWithContextInjection;
	import org.toshiroioc.test.beans.SimpleBeanWithMetatags;
	import org.toshiroioc.test.beans.SimpleBeanWithMetatagsExtended;
	import org.toshiroioc.test.beans.SimpleBeanWithObjectField;
	import org.toshiroioc.test.beans.SimpleBeanWithPostprocessor;
	import org.toshiroioc.test.beans.SimpleBeanWithoutMetatags;
	import org.toshiroioc.test.beans.SimpleDependencyChildrenSetter;
	import org.toshiroioc.test.beans.SimpleDependencyObject;
	import org.toshiroioc.test.i18n.SampleI18NProvider;
	import org.toshiroioc.test.postprocessors.TestClassPostprocessor;
	import org.toshiroioc.test.postprocessors.TestClassPostprocessor2;
	import org.toshiroioc.test.puremvc.command.DynamicTestCommand;
	import org.toshiroioc.test.puremvc.command.TestCommand;
	import org.toshiroioc.test.puremvc.mediator.DynamicExampleViewMediator;
	import org.toshiroioc.test.puremvc.mediator.ExampleViewMediator;
	import org.toshiroioc.test.puremvc.mediator.ToshiroApplicationFacadeTestMediator;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy2;
	import org.toshiroioc.test.puremvc.model.ExampleProxy;
	import org.toshiroioc.test.puremvc.model.ExampleProxy2;
	import org.toshiroioc.test.puremvc.view.DynamicExampleView;
	
	/*
	 * TODO:	replace * types with direct types, test bean dependency without ref
	 */
	public class XMLBeanFactoryTestCase extends BaseTestCase
	{
		
		private var testLinkageEnforcer:TestLinkageEnforcer;
		
		[Embed(source = "assets/simpleobjectsetter.xml", mimeType = "application/octet-stream")]
		private var SimpleObjectSetterClass:Class;
		
		[Embed(source = "assets/setterwithnull.xml", mimeType = "application/octet-stream")]
		private var SetterWithNullXMLClass:Class;
		
		[Embed(source = "assets/setterclass.xml", mimeType = "application/octet-stream")]
		private var SetterWithClassXMLClass:Class;
		
		[Embed(source = "assets/constructorsimpletype.xml", mimeType = "application/octet-stream")]
		private var ConstructorSimpleTypeXMLClass:Class;
		
		[Embed(source = "assets/setterdate.xml", mimeType = "application/octet-stream")]
		private var SetterDateTypeXMLClass:Class;
		
		[Embed(source = "assets/constructordate.xml", mimeType = "application/octet-stream")]
		private var ConstructorDateXMLClass:Class;
		
		[Embed(source = "assets/dependencysimplesetter.xml", mimeType = "application/octet-stream")]
		private var DependencySimpleSetterXMLClass:Class;
		
		[Embed(source = "assets/dependencysimpleconstructor.xml", mimeType = "application/octet-stream")]
		private var DependencySimpleConstructorXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromsetters.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromSettersXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromconstructors.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromConstructorsXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromconstructortosetter.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromConstructorToSetterXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromsettertoconstructor.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromSetterToConstructorXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromsetterscomplex.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromSettersComplexXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromconstructorscomplex.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromConstructorsComplexXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromconstructortosettercomplex.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromConstructorToSetterComplexXMLClass:Class;
		
		[Embed(source = "assets/cyclicdepeendencyfromsettertoconstructorcomplex.xml", mimeType = "application/octet-stream")]
		private var CyclicDependencyFromSetterToConstructorComplexXMLClass:Class;
		
		[Embed(source = "assets/lifecycle.xml", mimeType = "application/octet-stream")]
		private var LifecycleXMLClass:Class;
		
		[Embed(source = "assets/issingleton.xml", mimeType = "application/octet-stream")]
		private var IsSingletonXMLClass:Class;
		
		[Embed(source = "assets/constructorwithstaticref.xml", mimeType = "application/octet-stream")]
		private var ConstructorWithStaticReferenceXMLClass:Class;
		
		[Embed(source = "assets/setterclasswithstaticref.xml", mimeType = "application/octet-stream")]
		private var SetterWithStaticReferenceXMLClass:Class;
		
		[Embed(source = "assets/simplesettermetatags.xml", mimeType = "application/octet-stream")]
		private var MetatagsSetterXMLClass:Class;
		
		[Embed(source = "assets/constructorwithmetatagswithoutproperties.xml", mimeType = "application/octet-stream")]
		private var MetatagsConstructorWithoutPropertiesXMLClass:Class;
		
		[Embed(source = "assets/constructorwithmetatags.xml", mimeType = "application/octet-stream")]
		private var MetatagsConstructorXMLClass:Class;
		
		[Embed(source = "assets/dependencynotexistingsimplesetter.xml", mimeType = "application/octet-stream")]
		private var SetterWithoutDependencyXMLClass:Class;
		
		[Embed(source = "assets/dependencynotexistingconstructor.xml", mimeType = "application/octet-stream")]
		private var ConstructorWithoutDependencyXMLClass:Class;
		
		[Embed(source = "assets/requiredmetatag.xml", mimeType = "application/octet-stream")]
		private var RequiredMetatagXMLClass:Class;
		
		[Embed(source = "assets/requiredmetatagpublicprop.xml", mimeType = "application/octet-stream")]
		private var RequiredMetatagPublicPropXMLClass:Class;
		
		[Embed(source = "assets/requiredmetatagsatisfied.xml", mimeType = "application/octet-stream")]
		private var RequiredMetatag2XMLClass:Class;
		
		[Embed(source = "assets/extendedmetatags.xml", mimeType = "application/octet-stream")]
		private var ExtendingMetatagsXMLClass:Class;
		
		[Embed(source = "assets/maps.xml", mimeType = "application/octet-stream")]
		private var MapsXMLClass:Class;
		
		[Embed(source = "assets/setterandconstructorbeanwithpostprocessor.xml", mimeType = "application/octet-stream")]
		private var BeanWithPostprocessorXMLClass:Class;
		
		[Embed(source = "assets/getbyclass.xml", mimeType = "application/octet-stream")]
		private var GetByClassXMLClass:Class;
		
		[Embed(source = "assets/puremvc1.xml", mimeType = "application/octet-stream")]
		private var PureMVCXMLClass1:Class;
		
		[Embed(source = "assets/puremvc2.xml", mimeType = "application/octet-stream")]
		private var PureMVCXMLClass2:Class;
		
		[Embed(source = "assets/puremvcdynamicload.xml", mimeType = "application/octet-stream")]
		private var PureMVCDynamicLoadXMLClass:Class;
		
		[Embed(source = "assets/puremvcdynamicloadsimplestartupcmd.xml", mimeType = "application/octet-stream")]
		private var PureMVCDynamicSimpleStartupXMLClass:Class;
		
		[Embed(source = "assets/simpledependencyxmlmissing.xml", mimeType = "application/octet-stream")]
		private var XMLMissingXMLClass:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype1.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype1:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype2.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype2:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype3.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype3:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype4.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype4:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype5.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype5:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype6.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype6:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype7.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype7:Class;
		
		[Embed(source = "assets/notinstantiateprototype/notinstantiateprototype8.xml", mimeType = "application/octet-stream")]
		private var NotInstantiatePrototype8:Class;
		
		[Embed(source = "assets/dynamicconfig/simpledynamicconfig1.xml", mimeType = "application/octet-stream")]
		private var SimpleDynamicConfigXMLClass1:Class;
		
		[Embed(source = "assets/dynamicconfig/simpledynamicconfig2.xml", mimeType = "application/octet-stream")]
		private var SimpleDynamicConfigXMLClass2:Class;
		
		[Embed(source = "assets/dynamicconfig/reftobeanfrom2ndconfig.xml", mimeType = "application/octet-stream")]
		private var RefToBeanFrom2ndConfigXMLClass:Class;
		
		[Embed(source = "assets/dynamicconfig/reftobeanfrom1stconfig.xml", mimeType = "application/octet-stream")]
		private var RefToBeanFrom1stConfigXMLClass:Class;
		
		[Embed(source = "assets/dynamicconfig/config.xml", mimeType = "application/octet-stream")]
		private var DynamicConfigXMLClass:Class;
		
		[Embed(source = "assets/dynamicconfig/wrongreftobeanfrom1stconfig.xml", mimeType = "application/octet-stream")]
		private var WrongRefToBeanFrom1stConfigXMLClass:Class;
		
		[Embed(source = "assets/sameid.xml", mimeType = "application/octet-stream")]
		private var SameIDXMLClass:Class;
		
		[Embed(source = "assets/contextinjection.xml", mimeType = "application/octet-stream")]
		private var ContextInjectionXMLClass:Class;
		
		[Embed(source = "assets/refoptionallazyloaded.xml", mimeType = "application/octet-stream")]
		private var OptionalRefLazyLoadedXMLClass:Class;
		
		[Embed(source = "assets/refoptionaldynamicload.xml", mimeType = "application/octet-stream")]
		private var OptionalRefDynamicLoadXMLClass:Class;
		
		[Embed(source = "assets/refoptionalwrongargument.xml", mimeType = "application/octet-stream")]
		private var OptionalRefWrongArgumentXMLClass:Class;
		
		[Embed(source = "assets/setterwitharray.xml", mimeType = "application/octet-stream")]
		private var SetterWithArrayXMLClass:Class;
		
		[Embed(source = "assets/setterwitharrayemptyentry.xml", mimeType = "application/octet-stream")]
		private var SetterWithArrayEmptyEntryXMLClass:Class;
		
		[Embed(source = "assets/setterwitharraytoomuchargsinentry.xml", mimeType = "application/octet-stream")]
		private var SetterWithArrayTooMuchArgsInEntryXMLClass:Class;
		
		[Embed(source = "assets/constructorwitharray.xml", mimeType = "application/octet-stream")]
		private var ConstructorWithArrayXMLClass:Class;
		
		[Embed(source = "assets/reffromarrayinnerbean.xml", mimeType = "application/octet-stream")]
		private var RefArrayInnerBean:Class;
		
		[Embed(source = "assets/reffromarrayinnerbeancircular.xml", mimeType = "application/octet-stream")]
		private var RefArrayInnerBeanCircular:Class;
		
		[Embed(source = "assets/setterwithvector.xml", mimeType = "application/octet-stream")]
		private var SetterWithVectorXMLClass:Class;
		
		[Embed(source = "assets/map.xml", mimeType = "application/octet-stream")]
		private var MapXMLClass:Class;
		
		[Embed(source = "assets/setterwithmapemptyentry.xml", mimeType = "application/octet-stream")]
		private var SetterWithMapEmptyEntryXMLClass:Class;
		
		[Embed(source = "assets/setterwithmaptoomuchargsinentry.xml", mimeType = "application/octet-stream")]
		private var SetterWithMapTooMuchArgsInEntryXMLClass:Class;
		
		[Embed(source = "assets/reffrominnerbean.xml", mimeType = "application/octet-stream")]
		private var RefFromInnerBean:Class;
		
		[Embed(source = "assets/refbean.xml", mimeType = "application/octet-stream")]
		private var RefBean:Class;
		
		[Embed(source = "assets/refbeancircular.xml", mimeType = "application/octet-stream")]
		private var RefBeanCircular:Class;
		
		[Embed(source = "assets/refbeancircular2.xml", mimeType = "application/octet-stream")]
		private var RefBeanCircular2:Class
		
		[Embed(source = "assets/refbeannonexistent.xml", mimeType = "application/octet-stream")]
		private var RefBeanNonExistent:Class
		
		[Embed(source = "assets/refbeanoptionallazyloaded.xml", mimeType = "application/octet-stream")]
		private var OptionalRefBeanLazyLoadedXMLClass:Class;
		
		[Embed(source = "assets/refbeanoptionaldynamicload.xml", mimeType = "application/octet-stream")]
		private var OptionalRefBeanDynamicLoadXMLClass:Class;
		
		[Embed(source = "assets/i18nsetter.xml", mimeType = "application/octet-stream")]
		private var I18NXMLClass:Class;
		
		[Embed(source = "assets/restrictedbeanid.xml", mimeType = "application/octet-stream")]
		private var RestrictedBeanIdXMLClass:Class;
		
		[Embed(source = "assets/beanidinjection.xml", mimeType = "application/octet-stream")]
		private var BeanIdInjectionXMLClass:Class;
		
		[Embed(source = "assets/i18nwrongtype.xml", mimeType = "application/octet-stream")]
		private var I18nWrongTypeXMLClass:Class;
		
		[Embed(source = "assets/registrationaware.xml", mimeType = "application/octet-stream")]
		private var RegistrationAwareXMLClass:Class;
		
		[Embed(source = "assets/dynamicconfig/multipleconfigs.xml", mimeType = "application/octet-stream")]
		private var MultipleConfigsXMLClass:Class;
		
		[Embed(source = "assets/recursivearray.xml", mimeType = "application/octet-stream")]
		private var RecursiveArrayXMLClass:Class;
		
		[Embed(source = "assets/simplebeanwithobjectsetter.xml", mimeType = "application/octet-stream")]
		private var SimpleBeanWithObjectSetterClass:Class;
		
		[Embed(source = "assets/simplebeanwithobjectsetter2.xml", mimeType = "application/octet-stream")]
		private var SimpleBeanWithObjectSetterClass2:Class;
		
		[Embed(source = "assets/wrongproperties.xml", mimeType = "application/octet-stream")]
		private var WrongPropertiesClass:Class;
		
		[Embed(source = "assets/wrongattributenames.xml", mimeType = "application/octet-stream")]
		private var WrongAttributeNamesClass:Class;
		
		public function XMLBeanFactoryTestCase(methodName:String)
		{
			super(methodName);
		
		}
		
		public function testWrongAttributeNames():void
		{
			var xml:XML = constructXMLFromEmbed(WrongAttributeNamesClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var err:ContainerError;
			context.initialize();
			try
			{
				context.getObject('objectOne');
			}
			catch(e:ContainerError)
			{
				err = e;
			}
			
			assertEquals(ContainerError.ERROR_KEYWORD_NOT_RECOGNIZED, err.errorCode);
			assertTrue((err.message as String).indexOf('lifecycek,names,values,sth') > -1);
			try
			{
				context.getObject('objectWithoutTags');
			}
			catch(e:ContainerError)
			{
				err = e;
			}
			assertEquals(ContainerError.ERROR_KEYWORD_NOT_RECOGNIZED, err.errorCode);
			assertTrue((err.message as String).indexOf('refek') > -1);
		}
		
		public function testWrongProperties():void
		{
			var xml:XML = constructXMLFromEmbed(WrongPropertiesClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var err:ContainerError;
			context.initialize();
			try
			{
				context.getObject('objectWithoutTags');
			}
			catch(e:ContainerError)
			{
				err = e;
			}
			assertEquals(ContainerError.ERROR_KEYWORD_NOT_RECOGNIZED, err.errorCode);
			
			try
			{
				context.getObject('object4');
			}
			catch(e:ContainerError)
			{
				err = e;
			}
			assertEquals(ContainerError.ERROR_KEYWORD_NOT_RECOGNIZED, err.errorCode);
		
		}
		
		public function testDynamicObjectSetter():void
		{
			var xml:XML = constructXMLFromEmbed(SimpleBeanWithObjectSetterClass2);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var objOne:SimpleBeanWithObjectField = context.getObject('objectOne') as SimpleBeanWithObjectField;
			assertEquals(objOne.objectField.intItem, 999);
			assertEquals(objOne.objectField.stringItem, "999");
		}
		
		public function testObjectSetter():void
		{
			var xml:XML = constructXMLFromEmbed(SimpleBeanWithObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var objectOne:SimpleBeanWithObjectField = context.getObject('objectOne') as SimpleBeanWithObjectField;
			assertTrue(objectOne.simpleBean is SimpleBean);
			assertTrue(objectOne.objectField is SimpleBean);
			assertEquals(objectOne.simpleBean.intItem, 1000);
			assertEquals(objectOne.objectField.intItem, 999);
		
		}
		
		public function testRecursiveArrays():void
		{
			var xml:XML = constructXMLFromEmbed(RecursiveArrayXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var objOne:ConstructorWithArrays = context.getObject('objectOne');
			var innerObject:ConstructorWithArrays = context.getObject('innerObject');
			var uniqueBean:SimpleBean = context.getObject('uniqueId');
			
			assertEquals(innerObject, objOne.simpleArrayItem[0]);
			assertEquals(uniqueBean, innerObject.simpleArrayItem[0]);
			
			var objTwo:SetterWithArrays = context.getObject('objectTwo');
			var innerSetterArrayObject:SetterWithArrays = context.getObject("innerSetterArrayObject");
			var innerInnerConstructorArrayObject:ConstructorWithArrays = context.getObject("innerInnerConstructorArrayObject");
			var uniqueId8:SimpleBean = context.getObject('uniqueId8');
			
			assertEquals(innerSetterArrayObject.simpleArrayItem[0], uniqueId8);
			assertEquals(innerSetterArrayObject.simpleArrayItem[1], innerInnerConstructorArrayObject);
			assertEquals(objTwo.simpleArrayItem[0], innerSetterArrayObject);
			assertEquals(objTwo.simpleArrayItem[1], context.getObject('next'));
		}
		
		public function testPureMVCRegistrationAwareMediator():void
		{
			
			var mainApp:ToshiroApplicationFacadeTest = new ToshiroApplicationFacadeTest();
			var xml:XML;
			xml = constructXMLFromEmbed(RegistrationAwareXMLClass);
			mainApp.onCreationComplete("registrationAware", xml);
			
			assertTrue(mainApp.facade.hasMediator('mediator1'));
			assertFalse(mainApp.facade.hasMediator('mediator2'));
			assertFalse(mainApp.facade.hasMediator('mediator3'));
			assertTrue(mainApp.facade.hasMediator('mediator4'));
		
		}
		
		public function testI18NMetatagWrongSetterType():void
		{
			var xml:XML = constructXMLFromEmbed(I18nWrongTypeXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var err:ArgumentError;
			context.initialize();
			try
			{
				context.getObject('objectOne');
			}
			catch(e:ArgumentError)
			{
				err = e;
			}
			assertEquals('Accessor tagged with [i18n] has to be of String type', err.message);
		}
		
		public function testBeanIdMetatag():void
		{
			var xml:XML = constructXMLFromEmbed(BeanIdInjectionXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var objectOne:BeanIdMetatag = context.getObject('objectOne') as BeanIdMetatag;
			var objectTwo:BeanIdMetatag = context.getObject('objectTwo') as BeanIdMetatag;
			var arrayObject:SetterWithArrays = context.getObject('arrayObject') as SetterWithArrays;
			var innerBeanWithIdMetatag:BeanIdMetatag = arrayObject.simpleArrayItem[0];
			assertNotNull(innerBeanWithIdMetatag);
			assertNull(innerBeanWithIdMetatag.beanIdItem);
			assertNull(innerBeanWithIdMetatag.beanId2Item);
			
			assertEquals(objectOne.numberItem, 9999);
			assertEquals(objectOne.stringItem, 'some123String');
			assertEquals(objectOne.beanIdItem, 'objectOne');
			assertEquals(objectOne.beanId2Item, 'objectOne');
			
			assertEquals(objectTwo.numberItem, -1);
			assertEquals(objectTwo.stringItem, 'some1234String');
			assertEquals(objectTwo.beanIdItem, 'objectTwo');
			assertEquals(objectTwo.beanId2Item, 'objectTwo');
		}
		
		public function testRestrictedBeansId():void
		{
			var xml:XML = constructXMLFromEmbed(RestrictedBeanIdXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var err:ContainerError
			try
			{
				context.initialize();
			}
			catch(e:ContainerError)
			{
				err = e;
			}
			assertEquals(err.errorCode, ContainerError.ERROR_BEAN_ID_RESERVED);
		
		}
		
		public function testI18NMetatag():void
		{
			var xml:XML = constructXMLFromEmbed(I18NXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var objectOne:I18NBean = context.getObject('objectOne') as I18NBean;
			var objectTwo:I18NBean = context.getObject('objectTwo') as I18NBean;
			//linkage
			var i18nProvider:SampleI18NProvider = context.getTypedObject('toshiro.i18nProvider', SampleI18NProvider) as SampleI18NProvider;
			var arrCol:ArrayCollection = new ArrayCollection(i18nProvider.objects);
			assertTrue(arrCol.contains(objectOne));
			assertTrue(arrCol.contains(objectTwo));
			arrCol = new ArrayCollection(i18nProvider.beanIds);
			assertTrue(arrCol.contains('objectOne'));
			assertTrue(arrCol.contains('objectTwo'));
			var simpleBean:SimpleBean = context.getObject('simpleBean') as SimpleBean;
			assertEquals(objectOne.translatedField, 'translatedFieldtranslation');
			assertEquals(objectOne.translatedField2, 'translatedField2translation');
			assertEquals(objectOne.notTranslatedField, 'notTranslated');
			assertEquals(objectOne.simpleBean, simpleBean);
			
			assertEquals(objectTwo.translatedField, 'translatedFieldtranslation');
			assertEquals(objectTwo.translatedField2, 'translatedField2translation');
			assertEquals(objectTwo.notTranslatedField, 'notTranslated2');
			assertEquals(objectTwo.simpleBean, simpleBean);
		}
		
		/* public function testRefBeanOptional():void{
			var xml:XML = constructXMLFromEmbed(OptionalRefBeanLazyLoadedXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var object1:SetterWithArrays = context.getObject("object1") as SetterWithArrays;
			var object2:SetterWithArrays = context.getObject("object2") as SetterWithArrays;
			var obj1arr:Array = object1.simpleArrayItem;
			var obj2arr:Array = object2.simpleArrayItem;
		
			assertNotNull(object1);
			assertNull(obj1arr[0]);
			assertNotNull(obj1arr[1]);
			assertNotNull(obj1arr[1].someChild);
			assertNotNull(object2);
			assertNull(obj2arr[0]);
			assertNotNull(obj2arr[1]);
			assertNotNull(obj2arr[1].someChild);
			assertFalse(context.containsObject("objectChild"));
		
			xml = constructXMLFromEmbed(OptionalRefBeanDynamicLoadXMLClass);
			context.loadDynamicConfig(xml);
		
			assertNotNull(obj1arr[0]);
			assertNotNull(obj1arr[1]);
			assertNotNull(obj2arr[0]);
			assertNotNull(obj2arr[1]);
			assertTrue(context.containsObject("objectChild"));
		} */
		
		public function testRefBeanNonExistent():void
		{
			var xml:XML = constructXMLFromEmbed(RefBeanNonExistent);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			try
			{
				context.initialize();
			}
			catch(e:ContainerError)
			{
				error = e;
			}
			assertNotNull(error);
			assertEquals(error.errorCode, ContainerError.ERROR_OBJECT_NOT_FOUND);
		}
		
		public function testRefBeanCircular():void
		{
			var xml:XML = constructXMLFromEmbed(RefBeanCircular);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			try
			{
				context.initialize();
			}
			catch(e:ContainerError)
			{
				error = e;
			}
			assertNotNull(error);
			assertEquals(error.errorCode, ContainerError.ERROR_CYCLIC_DEPENDENCY);
			
			xml = constructXMLFromEmbed(RefBeanCircular2);
			context = new XMLBeanFactory(xml);
			
			try
			{
				context.initialize();
			}
			catch(e:ContainerError)
			{
				error = e;
			}
			assertNotNull(error);
			assertEquals(error.errorCode, ContainerError.ERROR_CYCLIC_DEPENDENCY);
		}
		
		public function testRefBean():void
		{
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
		
		public function testRefFromInnerBean():void
		{
			var xml:XML = constructXMLFromEmbed(RefFromInnerBean);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var objectOne:ParentOfSimpleDependencyChildrenSetter;
			var outerBean:SimpleDependencyObject;
			var objectTwo:ParentOfSimpleDependencyObject;
			
			//first object
			objectOne = context.getObject("objectOne") as ParentOfSimpleDependencyChildrenSetter;
			outerBean = context.getObject("outerBean") as SimpleDependencyObject;
			
			var outerBean2:ParentOfSimpleDependencyObject = context.getObject("outerBean2") as ParentOfSimpleDependencyObject;
			var innerObject:SimpleDependencyObject = context.getObject("innerObject") as SimpleDependencyObject;
			assertTrue(outerBean2.nextChild == innerObject);
			assertTrue(SetterWithArrays(context.getObject('arraySetter')).simpleArrayItem[1] == innerObject);
			
			objectTwo = context.getObject("objectTwo");
			assertNotNull(objectOne);
			assertNotNull(outerBean);
			assertNotNull(objectTwo);
			assertEquals(objectOne.someChild.nextChild, outerBean);
			assertEquals(objectOne.someChild, objectTwo);
			assertTrue(SetterWithArrays(context.getObject('arraySetter')).simpleArrayItem[0] == objectOne);
		}
		
		public function testRefArrayInnerBeanCircular():void
		{
			var xml:XML = constructXMLFromEmbed(RefArrayInnerBeanCircular);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			try
			{
				context.initialize();
			}
			catch(e:ContainerError)
			{
				error = e;
			}
			assertNotNull(error);
			assertEquals(error.errorCode, ContainerError.ERROR_CYCLIC_DEPENDENCY);
		}
		
		public function testRefFromArrayInnerBean():void
		{
			var xml:XML = constructXMLFromEmbed(RefArrayInnerBean);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var constructorWithArray:ConstructorWithArrays;
			var innerParentBean:ParentOfSimpleDependencyObject;
			var innerParentBean2:ParentOfSimpleDependencyObject;
			var outerBean:SimpleDependencyObject;
			var outerBean2:ParentOfSimpleDependencyObject;
			context.initialize();
			
			//first object
			constructorWithArray = context.getObject("objectOne") as ConstructorWithArrays;
			innerParentBean = context.getObject("innerParentBean") as ParentOfSimpleDependencyObject;
			outerBean = context.getObject("outerBean") as SimpleDependencyObject;
			innerParentBean2 = context.getObject("innerParentBean2") as ParentOfSimpleDependencyObject;
			outerBean2 = context.getObject("outerBean2") as ParentOfSimpleDependencyObject;
			var innerArray:Array = constructorWithArray.simpleArrayItem[2];
			
			assertEquals(3, constructorWithArray.simpleArrayItem.length);
			assertNotNull(innerParentBean);
			assertNotNull(innerParentBean2);
			assertNotNull(outerBean);
			assertNotNull(outerBean2);
			assertEquals(innerParentBean.nextChild, outerBean);
			assertEquals(innerParentBean2.nextChild, outerBean);
			assertEquals(outerBean, constructorWithArray.simpleArrayItem[1].nextChild);
			assertEquals(outerBean, (constructorWithArray.simpleArrayItem[2])[0].nextChild);
			assertEquals(outerBean, outerBean2.nextChild);
			assertTrue(innerArray[1] == outerBean2);
		}
		
		public function testErrorsInMap():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithMapEmptyEntryXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ArgumentError;
			context.initialize();
			try
			{
				context.getObject('setterWithArray');
			}
			catch(err:ArgumentError)
			{
				error = err;
			}
			assertNotNull(error);
			assertTrue(error.message.indexOf("Empty entry") != -1);
			
			xml = constructXMLFromEmbed(SetterWithMapTooMuchArgsInEntryXMLClass);
			context = new XMLBeanFactory(xml);
			error = null;
			context.initialize();
			try
			{
				context.getObject('setterWithArray');
			}
			catch(err:ArgumentError)
			{
				error = err;
			}
			assertNotNull(error);
			assertTrue(error.message.indexOf("Too many arguments for a single map entry") != -1);
		}
		
		public function testMap():void
		{
			var xml:XML = constructXMLFromEmbed(MapXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var setterWithArray:SetterWithArrays;
			var setterWithArray2:SetterWithArrays;
			var map:Object;
			context.initialize();
			setterWithArray = context.getObject("setterWithArrays") as SetterWithArrays;
			setterWithArray2 = context.getObject("setterWithArrays2") as SetterWithArrays;
			assertTrue(setterWithArray.booleanItem);
			assertEquals(1, setterWithArray.simpleArrayItem.length);
			assertEquals(2, (setterWithArray.simpleArrayItem[0] as Array).length);
			assertEquals("first", (setterWithArray.simpleArrayItem[0] as Array)[0]);
			map = (setterWithArray.simpleArrayItem[0] as Array)[1];
			assertTrue(map["someSimpleBean"] as Class == getDefinitionByName("org.toshiroioc.test.beans.SimpleBean") as Class);
			assertTrue(map["someSetterWithArrays"] as Class == getDefinitionByName("org.toshiroioc.test.beans.SetterWithArrays") as
				Class);
			assertEquals("second", (setterWithArray.objectsArrayItem[0] as Array)[0]);
			map = (setterWithArray.objectsArrayItem[0] as Array)[1];
			assertTrue(map["someSimpleBean2"] as Class == getDefinitionByName("org.toshiroioc.test.beans.SimpleBean") as
				Class);
			assertTrue(map["someSetterWithArrays2"] as Class == getDefinitionByName("org.toshiroioc.test.beans.SetterWithArrays") as
				Class);
			
			assertTrue(setterWithArray2.booleanItem);
			assertEquals(1, setterWithArray2.simpleArrayItem.length);
			assertEquals(2, (setterWithArray2.simpleArrayItem[0] as Array).length);
			assertEquals("third", (setterWithArray2.simpleArrayItem[0] as Array)[0]);
			map = (setterWithArray2.simpleArrayItem[0] as Array)[1];
			assertTrue(map["someSimpleBean"] as Class == getDefinitionByName("org.toshiroioc.test.beans.SimpleBean") as Class);
			assertTrue(map["someSetterWithArrays"] as Class == getDefinitionByName("org.toshiroioc.test.beans.SetterWithArrays") as
				Class);
			
			assertNotNull(setterWithArray2.objectsArrayItem[0]);
		
		}
		
		public function testConstructorArrayInjection():void
		{
			var xml:XML = constructXMLFromEmbed(ConstructorWithArrayXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var constructorWithArray:ConstructorWithArrays;
			context.initialize();
			//first object
			constructorWithArray = context.getObject("objectOne") as ConstructorWithArrays;
			assertEquals(-99999, constructorWithArray.someNumber);
			assertEquals("objectsOne", constructorWithArray.someAdditionalString);
			var array:Array = constructorWithArray.simpleArrayItem;
			assertTrue(array.length > 0);
			assertEquals(3, array[0]);
			assertEquals(true, array[1]);
			assertEquals(1, array[2]);
			assertNotNull(array[3]); //date
			assertEquals(5, array[4]);
			assertEquals(7, array[5]);
			assertEquals(SimpleBean, array[6]);
			assertEquals(2, (array[7] as SimpleBean).numberItem);
			assertEquals(org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT, array[8]);
			var innerArray:Array = array[9];
			assertEquals(12, innerArray[0]);
			assertEquals(FieldDescription.FIELD_TYPE_CONST, innerArray[1]);
			assertEquals("innerObjectOfInnerArray", (innerArray[2] as SimpleBean).stringItem);
			var deepObjectWithArray:ConstructorWithArrays = innerArray[3] as ConstructorWithArrays;
			var innerArrayOfInnerArray:Array = deepObjectWithArray.simpleArrayItem;
			assertEquals(13, innerArrayOfInnerArray[0]);
			assertEquals("innerArrayOfInnerObjectOfInnerArray", innerArrayOfInnerArray[1]);
			assertTrue(innerArrayOfInnerArray[2] is SimpleBean);
			assertEquals("deepEnough", (innerArrayOfInnerArray[2] as SimpleBean).stringItem);
			array = constructorWithArray.objectsArrayItem;
			assertEquals(1, (array[0] as SimpleBean).numberItem);
			assertEquals(2, array[1]);
			assertEquals(3, (array[2] as SimpleBean).numberItem);
			
			//second object
			constructorWithArray = context.getObject("objectTwo") as ConstructorWithArrays;
			assertEquals(-99999.6, constructorWithArray.someNumber);
			assertEquals("enedueRikeFake", constructorWithArray.someAdditionalString);
			array = constructorWithArray.simpleArrayItem;
			assertTrue(array.length > 0);
			assertEquals(3, array[0]);
			assertEquals(true, array[1]);
			assertEquals(1, array[2]);
			assertNotNull(array[3]); //date
			assertEquals(5, array[4]);
			assertEquals(7, array[5]);
			assertEquals(SimpleBean, array[6]);
			assertEquals(2, (array[7] as SimpleBean).numberItem);
			assertEquals(org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT, array[8]);
			innerArray = array[9];
			assertEquals(12, innerArray[0]);
			assertEquals(FieldDescription.FIELD_TYPE_CONST, innerArray[1]);
			assertEquals("innerObjectOfInnerArray", (innerArray[2] as SimpleBean).stringItem);
			deepObjectWithArray = innerArray[3] as ConstructorWithArrays;
			innerArrayOfInnerArray = deepObjectWithArray.simpleArrayItem;
			assertEquals(13, innerArrayOfInnerArray[0]);
			assertEquals("innerArrayOfInnerObjectOfInnerArray", innerArrayOfInnerArray[1]);
			assertTrue(innerArrayOfInnerArray[2] is SimpleBean);
			assertEquals("deepEnough", (innerArrayOfInnerArray[2] as SimpleBean).stringItem);
			array = constructorWithArray.objectsArrayItem;
			assertEquals(1, (array[0] as SimpleBean).numberItem);
			assertEquals(2, array[1]);
			assertEquals(3, (array[2] as SimpleBean).numberItem);
			//third object with empty arrays
			constructorWithArray = context.getObject("objectWithEmptyArray") as ConstructorWithArrays;
			assertNotNull(constructorWithArray.simpleArrayItem);
			assertNotNull(constructorWithArray.objectsArrayItem);
			assertEquals(2, constructorWithArray.simpleArrayItem[1]);
		
		}
		
		public function testErrorsInArray():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithArrayEmptyEntryXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ArgumentError;
			context.initialize();
			try
			{
				context.getObject('setterWithArray');
			}
			catch(err:ArgumentError)
			{
				error = err;
			}
			assertNotNull(error);
			assertTrue(error.message.indexOf("Empty entry") != -1);
			
			xml = constructXMLFromEmbed(SetterWithArrayTooMuchArgsInEntryXMLClass);
			context = new XMLBeanFactory(xml);
			error = null;
			context.initialize();
			try
			{
				context.getObject('setterWithArray');
			}
			catch(err:ArgumentError)
			{
				error = err;
			}
			assertNotNull(error);
			assertTrue(error.message.indexOf("Too many arguments for a single array entry") != -1);
		}
		
		public function testSetterArrayInjection():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithArrayXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var setterWithArray:SetterWithArrays;
			context.initialize();
			//first object
			setterWithArray = context.getObject("setterWithArray") as SetterWithArrays;
			assertTrue(setterWithArray.booleanItem);
			var array:Array = setterWithArray.simpleArrayItem;
			assertTrue(array.length > 0);
			assertEquals(3, array[0]);
			assertEquals(true, array[1]);
			assertEquals(1, array[2]);
			assertNotNull(array[3]); //date
			assertEquals(5, array[4]);
			assertEquals(7, array[5]);
			assertEquals(SimpleBean, array[6]);
			assertEquals(2, (array[7] as SimpleBean).numberItem);
			assertEquals(org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT, array[8]);
			var innerArray:Array = array[9];
			assertEquals(12, innerArray[0]);
			assertEquals(FieldDescription.FIELD_TYPE_CONST, innerArray[1]);
			assertEquals("innerObjectOfInnerArray", (innerArray[2] as SimpleBean).stringItem);
			var deepObjectWithArray:SetterWithArrays = innerArray[3] as SetterWithArrays;
			var innerArrayOfInnerArray:Array = deepObjectWithArray.simpleArrayItem;
			assertEquals(13, innerArrayOfInnerArray[0]);
			assertEquals("innerArrayOfInnerObjectOfInnerArray", innerArrayOfInnerArray[1]);
			assertTrue(innerArrayOfInnerArray[2] is SimpleBean);
			assertEquals("deepEnough", (innerArrayOfInnerArray[2] as SimpleBean).stringItem);
			array = setterWithArray.objectsArrayItem;
			assertEquals(1, (array[0] as SimpleBean).numberItem);
			assertEquals(2, array[1]);
			assertEquals(3, (array[2] as SimpleBean).numberItem);
			
			//second object
			setterWithArray = context.getObject("secondSetterWithArray") as SetterWithArrays;
			assertTrue(setterWithArray.booleanItem);
			array = setterWithArray.simpleArrayItem;
			assertTrue(array.length > 0);
			assertEquals(3, array[0]);
			assertEquals(true, array[1]);
			assertEquals(1, array[2]);
			assertNotNull(array[3]); //date
			assertEquals(5, array[4]);
			assertEquals(7, array[5]);
			assertEquals(SimpleBean, array[6]);
			assertEquals(2, (array[7] as SimpleBean).numberItem);
			assertEquals(org.toshiroioc.core.FieldDescription.FIELD_TYPE_UINT, array[8]);
			innerArray = array[9];
			assertEquals(12, innerArray[0]);
			assertEquals(FieldDescription.FIELD_TYPE_CONST, innerArray[1]);
			assertEquals("innerObjectOfInnerArray", (innerArray[2] as SimpleBean).stringItem);
			deepObjectWithArray = innerArray[3] as SetterWithArrays;
			innerArrayOfInnerArray = deepObjectWithArray.simpleArrayItem;
			assertEquals(13, innerArrayOfInnerArray[0]);
			assertEquals("innerArrayOfInnerObjectOfInnerArray", innerArrayOfInnerArray[1]);
			assertTrue(innerArrayOfInnerArray[2] is SimpleBean);
			assertEquals("deepEnough", (innerArrayOfInnerArray[2] as SimpleBean).stringItem);
			array = setterWithArray.objectsArrayItem;
			assertEquals(1, (array[0] as SimpleBean).numberItem);
			assertEquals(2, array[1]);
			assertEquals(3, (array[2] as SimpleBean).numberItem);
			
			//third object with empty arrays
			setterWithArray = context.getObject("objectWithEmptyArray") as SetterWithArrays;
			assertNotNull(setterWithArray.simpleArrayItem);
			assertNotNull(setterWithArray.objectsArrayItem);
			assertEquals(3, setterWithArray.simpleArrayItem[0]);
		}
		
		public function testRefOptionalWrongArgument():void
		{
			var xml:XML = constructXMLFromEmbed(OptionalRefWrongArgumentXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ArgumentError;
			try
			{
				context.initialize();
			}
			catch(err:ArgumentError)
			{
				error = err;
			}
			assertNotNull(error);
			assertTrue(error.message.indexOf("Wrong [optional] attribute") != -1);
		}
		
		public function testRefOptional():void
		{
			var xml:XML = constructXMLFromEmbed(OptionalRefLazyLoadedXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			var object1:SimpleDependencyChildrenSetter = context.getObject("object1") as SimpleDependencyChildrenSetter;
			var object2:SimpleDependencyChildrenSetter = context.getObject("object2") as SimpleDependencyChildrenSetter;
			
			assertNotNull(object1);
			assertNull(object1.someChild);
			assertNotNull(object1.someChild2);
			assertNotNull(object1.someChild2.someChild);
			assertNotNull(object2);
			assertNull(object2.someChild2);
			assertNotNull(object2.someChild);
			assertNotNull(object2.someChild.someChild);
			assertFalse(context.containsBean("objectChild"));
			
			xml = constructXMLFromEmbed(OptionalRefDynamicLoadXMLClass);
			context.loadDynamicConfig(xml);
			
			assertNotNull(object1.someChild);
			assertNotNull(object2.someChild2);
			assertNotNull(object1.someChild.someChild);
			assertNotNull(object2.someChild2.someChild);
			assertTrue(context.containsBean("objectChild"));
		}
		
		public function testIDNotUnique():void
		{
			var xml:XML = constructXMLFromEmbed(SameIDXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			try
			{
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_MULTIPLE_BEANS_WITH_THE_SAME_ID, error.errorCode);
		
		}
		
		//simple context addition
		public function testDynamicContextSimpleLoad():void
		{
			var xml:XML = constructXMLFromEmbed(SimpleDynamicConfigXMLClass1);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			xml = constructXMLFromEmbed(SimpleDynamicConfigXMLClass2);
			
			context.loadDynamicConfig(xml);
			assertNotNull(context.getObject("objectOne"));
			assertNotNull(context.getObject("objectTwo"));
			assertNotNull(context.getObject("objectThree"));
			assertNotNull(context.getObject("objectFour"));
		}
		
		//ref to bean from second config		
		public function testDynamicContextRefToBeanFrom2ndConfig():void
		{
			var xml:XML = constructXMLFromEmbed(RefToBeanFrom2ndConfigXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			try
			{
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_OBJECT_NOT_FOUND, error.errorCode);
		}
		
		public function testDynamicContextRefToBeanFrom1stConfig():void
		{
			var xml:XML = constructXMLFromEmbed(DynamicConfigXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			xml = constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass);
			context.loadDynamicConfig(xml);
			var objWithRefTo1stConfig:SimpleDependencyObject = context.getObject("objectWithRefToFirstConfig") as SimpleDependencyObject;
			assertNotNull(objWithRefTo1stConfig);
			assertNotNull(objWithRefTo1stConfig.someChild)
			assertTrue(objWithRefTo1stConfig.someChild is BeanWithConstructor);
		}
		
		public function testDynamicContextLoadFailed():void
		{
			var xml:XML = constructXMLFromEmbed(DynamicConfigXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			context.initialize();
			xml = constructXMLFromEmbed(WrongRefToBeanFrom1stConfigXMLClass);
			try
			{
				context.loadDynamicConfig(xml);
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_OBJECT_NOT_FOUND, error.errorCode);
			//assert that first config is correct
			assertNotNull(context.getObject("objectOne"));
			assertNotNull(context.getObject("object2"));
			assertNotNull(context.getObject("objectChild"));
			//assert that nothing remained from second (wrong) config
			assertFalse(context.containsBean("objectTwo"));
			assertFalse(context.containsBean("objectWithRefToFirstConfig"));
		}
		
		public function testMultipleConfigs():void
		{
			var xml:XML = constructXMLFromEmbed(MultipleConfigsXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var configs:Array = [constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass).toXMLString(), constructXMLFromEmbed(SimpleDynamicConfigXMLClass2).
				toXMLString()];
			context.addConfigsToDynamicLoadAtStartup(configs);
			context.initialize();
			//xml = constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass);
			var objWithRefTo1stConfig:SimpleDependencyObject = context.getObject("objectWithRefToFirstConfig") as SimpleDependencyObject;
			assertNotNull(objWithRefTo1stConfig);
			assertNotNull(objWithRefTo1stConfig.someChild)
			assertTrue(objWithRefTo1stConfig.someChild is BeanWithConstructor);
			assertNotNull(context.getObject("objectThree"));
			assertNotNull(context.getObject("objectFour"));
		}
		
		public function testConcatConfigs():void
		{
			var xml:XML = constructXMLFromEmbed(MultipleConfigsXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var configs:Array = [constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass).toXMLString(), constructXMLFromEmbed(SimpleDynamicConfigXMLClass2).
				toXMLString()];
			context.concatConfigsWithMainXML(configs);
			context.initialize();
			//xml = constructXMLFromEmbed(RefToBeanFrom1stConfigXMLClass);
			var objWithRefTo1stConfig:SimpleDependencyObject = context.getObject("objectWithRefToFirstConfig") as SimpleDependencyObject;
			assertNotNull(objWithRefTo1stConfig);
			assertNotNull(objWithRefTo1stConfig.someChild)
			assertTrue(objWithRefTo1stConfig.someChild is BeanWithConstructor);
			assertNotNull(context.getObject("objectThree"));
			assertNotNull(context.getObject("objectFour"));
		}
		
		public function testClassPostprocessor():void
		{
			var xml:XML = constructXMLFromEmbed(BeanWithPostprocessorXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var beanWithPostprocessor:SimpleBeanWithPostprocessor;
			var beanConstructorWithPostprocessor:SimpleBeanWithPostprocessor;
			
			context.registerClassPostprocessor(new TestClassPostprocessor());
			context.registerClassPostprocessor(new TestClassPostprocessor2());
			context.initialize();
			
			beanWithPostprocessor = context.getObject("objectSetter") as SimpleBeanWithPostprocessor;
			assertNotNull(beanWithPostprocessor);
			assertEquals(5, beanWithPostprocessor.property);
			assertTrue(beanWithPostprocessor.testField);
			assertTrue(beanWithPostprocessor.testField2);
			assertEquals(2, beanWithPostprocessor.commonField);
			
			beanConstructorWithPostprocessor = context.getObject("objectConstructor") as SimpleBeanWithPostprocessor;
			assertNotNull(beanConstructorWithPostprocessor);
			assertEquals(5, beanWithPostprocessor.property);
			assertTrue(beanConstructorWithPostprocessor.testField);
			assertTrue(beanConstructorWithPostprocessor.testField2);
			assertTrue(2, beanConstructorWithPostprocessor.commonField);
		}
		
		//TODO: check malformed xml and throw errors
		public function testSetterInjectionOfArray():void
		{
			var xml:XML = constructXMLFromEmbed(MapsXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var setterMap:SetterMap;
			var commandMap:CommandMap;
			//var constructorMap:ConstructorMap;
			//var testDependencyObject:TESTDependencyObject;
			context.initialize();
			
			setterMap = context.getObject("beanWithSetterMap") as SetterMap;
			//constructorMap = context.getObject("beanWithConstructorMap") as ConstructorMap;
			
			var mappings:Array = setterMap.mappings;
			
			assertEquals(2, mappings.length);
			
			var mapping1:CommandMap = mappings[0] as CommandMap;
			var mapping2:CommandMap = mappings[1] as CommandMap;
			//var mapping3:Array = map[2]; 
			
			//test string key and string value
			//assertEquals("model", mapping1.notification);
			//assertEquals("org.toshiroioc.test.puremvc.command.StartupCommand", setterMap.getValue(mapping1));
			
			//test const and value class
			assertEquals(FieldDescription.METATAG_REQUIRED, mapping1.notification);
			assertEquals(getDefinitionByName("org.toshiroioc.test.puremvc.command.TestCommand"), mapping1.command);
			//test key and value class
			assertEquals("model", mapping2.notification);
			assertEquals(getDefinitionByName("org.toshiroioc.test.puremvc.command.TestCommand"), mapping2.command);
			//assertEquals(getDefinitionByName(context.getObject("testCommand")), mapping2.command);
		
		}
		
		//such context couldn't initialize
		public function testXMLMissing():void
		{
			var xml:XML = constructXMLFromEmbed(XMLMissingXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
		}
		
		public function testGetObjectsByClass():void
		{
			var xml:XML = constructXMLFromEmbed(GetByClassXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			context.initialize();
			//test existing bean of a class
			var setterMap:SetterMap;
			var objectVector:Vector.<Object> = context.getObjectsByClass(getDefinitionByName("org.toshiroioc.plugins.puremvc.multicore.SetterMap") as
				Class);
			assertNotNull(objectVector);
			assertTrue(objectVector.length > 0);
			objectVector = null;
			objectVector = context.getObjectsByClass(getDefinitionByName("org.puremvc.as3.multicore.patterns.proxy.Proxy") as
				Class);
			assertNotNull(objectVector);
			assertTrue(objectVector.length == 2);
			//test not existing bean of a class
			try
			{
				context.getObjectsByClass(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean") as Class);
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_OBJECT_OF_THE_CLASS_NOT_FOUND, error.errorCode);
		}
		
		public function testNotInitializePrototypeBeans():void
		{
			
			var xml:XML = constructXMLFromEmbed(NotInstantiatePrototype1);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype2);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype3);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype4);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype5);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype6);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype7);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
			
			xml = constructXMLFromEmbed(NotInstantiatePrototype8);
			context = new XMLBeanFactory(xml);
			context.initialize();
			
			assertNotNull(context.getObject("objectChild"));
			assertNotNull(context.getObject("object2"));
		}
		
		public function testPureMVCMacroCommandStartup():void
		{
			var mainApp:ToshiroApplicationFacadeTest = new ToshiroApplicationFacadeTest();
			var xml:XML;
			xml = constructXMLFromEmbed(PureMVCXMLClass1);
			mainApp.onCreationComplete("macroCommand", xml)
			
			var testCommand:TestCommand = mainApp.facade.getContext().getObject("testCommand") as TestCommand;
			
			var toshiroApplicationFacadeTestMediator:ToshiroApplicationFacadeTestMediator = mainApp.facade.getContext().
				getObject("toshiroApplicationFacadeTestMediator") as ToshiroApplicationFacadeTestMediator;
			var exampleViewMediator:ExampleViewMediator = mainApp.facade.getContext().getObject("exampleViewMediator") as
				ExampleViewMediator;
			//test macro startup command
			
			//test if postprocessor registers commands
			assertTrue(mainApp.facade.hasCommand("model"));
			assertTrue(mainApp.facade.hasCommand("view"));
			assertTrue(mainApp.facade.hasCommand("test"));
			//test if postprocessor registers proxies
			assertTrue(mainApp.facade.hasProxy(ExampleProxy.NAME));
			assertTrue(mainApp.facade.hasProxy(ExampleProxy2.NAME));
			//test if postprocessor registers mediators
			assertTrue(mainApp.facade.hasMediator(ToshiroApplicationFacadeTestMediator.NAME));
			assertTrue(mainApp.facade.hasMediator(ExampleViewMediator.NAME));
			//tests sending notification
			mainApp.facade.sendNotification("test", 5);
			assertEquals(5, testCommand.executed);
			//tests if commands from startup macro command has been executed
			assertEquals(1, testCommand.testNoteFromCommand);
			// tests onRegister on proxy1 and note proxy --> mediator
			assertNotNull(mainApp.exampleView.view_grid.dataProvider);
			//tests if note has been sent between mediators
			assertEquals(mainApp.exampleView.view_lbl.text, "YOU CLICKED THE BUTTON");
			// tests onRegister on proxy2 and note proxy --> mediator
			assertEquals(mainApp.exampleView.view_lbl2.text, "5");
			//test if main app has been set by notification from PrepViewCommand
			assertNotNull(toshiroApplicationFacadeTestMediator.app);
			//test if notification from proxy has been sent
			assertTrue(toshiroApplicationFacadeTestMediator.exProxyOnRegister);
			// receive note from mediator on register
			assertEquals(0, testCommand.notRegisteredNoteCounter);
			assertEquals(1, testCommand.noteFromMediator);
			
			//test dynamically loaded config
			xml = constructXMLFromEmbed(PureMVCDynamicLoadXMLClass);
			mainApp.facade.getContext().loadDynamicConfig(xml);
			
			var dynamicTestCommand:DynamicTestCommand = mainApp.facade.getContext().getObject("dynamicTestCommand") as DynamicTestCommand;
			var dynamicExampleViewMediator:DynamicExampleViewMediator = mainApp.facade.getContext().getObject("dynamicExampleViewMediator") as
				DynamicExampleViewMediator;
			
			mainApp.dynamicModule = mainApp.facade.getContext().getObject("dynamicModule") as DynamicModule;
			assertNotNull(mainApp.dynamicModule); //todo optional and lazy injection
			mainApp.facade.sendNotification("custom_startup");
			//tests notes from command to new and old commands
			assertEquals(2, dynamicTestCommand.noteFromCmd);
			assertEquals(2, testCommand.testNoteFromCommand);
			//tests note new cmd -> old cmd prototype -> new mediator
			assertEquals(1, dynamicExampleViewMediator.runsCount);
			//tests dynamic mediator on register
			assertEquals("set", dynamicExampleViewMediator.example_view.dynamic_view_lbl.text);
			//tests notes between dynamic and old mediators
			assertEquals(1, toshiroApplicationFacadeTestMediator.noteFromDynMed);
			assertEquals(1, exampleViewMediator.noteFromDynMed);
			//notes dynamic mediator -> new and old command
			assertEquals(2, testCommand.noteFromMediator);
			assertEquals(1, dynamicTestCommand.noteFromMediator);
			// notes proxies -> mediators
			assertEquals(3, exampleViewMediator.notesFromProxies);
			assertEquals(1, dynamicExampleViewMediator.notesFromProxies);
			//notes proxies -> commands
			assertEquals(0, testCommand.notRegisteredNoteCounter);
			assertEquals(1, testCommand.noteFromProxies);
			assertEquals(1, dynamicTestCommand.noteFromProxies);
			//tests if not overrided
			assertTrue(mainApp.facade.hasCommand("model"));
			assertTrue(mainApp.facade.hasCommand("view"));
			assertTrue(mainApp.facade.hasCommand("test"));
			//test if postprocessor registers proxies
			assertTrue(mainApp.facade.hasProxy(ExampleProxy.NAME));
			assertTrue(mainApp.facade.hasProxy(ExampleProxy2.NAME));
			//test if postprocessor registers mediators
			assertTrue(mainApp.facade.hasMediator(ToshiroApplicationFacadeTestMediator.NAME));
			assertTrue(mainApp.facade.hasMediator(ExampleViewMediator.NAME));
			assertTrue(mainApp.facade.hasCommand("dynamic_model"));
			assertTrue(mainApp.facade.hasCommand("dynamic_view"));
			assertTrue(mainApp.facade.hasProxy(DynamicExampleProxy.NAME));
			assertTrue(mainApp.facade.hasProxy(DynamicExampleProxy2.NAME));
			assertTrue(mainApp.facade.hasMediator(DynamicExampleViewMediator.NAME));
			//test injection ref to main config
			assertNotNull((mainApp.facade.getContext().getObject("dynamicExampleView") as DynamicExampleView).exampleView);
		}
		
		public function testPureMVCSimpleCommandStartup():void
		{
			
			//test simple startup command
			var mainApp:ToshiroApplicationFacadeTest = new ToshiroApplicationFacadeTest();
			var xml:XML;
			xml = constructXMLFromEmbed(PureMVCXMLClass2);
			mainApp.onCreationComplete("simpleCommand", xml)
			var testCommand:TestCommand = mainApp.facade.getContext().getObject("testCommand") as TestCommand;
			var toshiroApplicationFacadeTestMediator:ToshiroApplicationFacadeTestMediator = mainApp.facade.getContext().
				getObject("toshiroApplicationFacadeTestMediator") as ToshiroApplicationFacadeTestMediator;
			var exampleViewMediator:ExampleViewMediator = mainApp.facade.getContext().getObject("exampleViewMediator") as
				ExampleViewMediator;
			//test macro startup command
			
			//test if postprocessor registers commands
			assertTrue(mainApp.facade.hasCommand("model"));
			assertTrue(mainApp.facade.hasCommand("view"));
			assertTrue(mainApp.facade.hasCommand("test"));
			//test if postprocessor registers proxies
			assertTrue(mainApp.facade.hasProxy(ExampleProxy.NAME));
			assertTrue(mainApp.facade.hasProxy(ExampleProxy2.NAME));
			//test if postprocessor registers mediators
			assertTrue(mainApp.facade.hasMediator(ToshiroApplicationFacadeTestMediator.NAME));
			assertTrue(mainApp.facade.hasMediator(ExampleViewMediator.NAME));
			//tests sending notification
			mainApp.facade.sendNotification("test", 5);
			assertEquals(5, testCommand.executed);
			//tests if commands from startup macro command has been executed
			assertEquals(1, testCommand.testNoteFromCommand);
			// tests onRegister on proxy1 and note proxy --> mediator
			//			assertNotNull(mainApp.exampleView.view_grid.dataProvider);
			//tests if note has been sent between mediators
			assertEquals(mainApp.exampleView.view_lbl.text, "YOU CLICKED THE BUTTON");
			// tests onRegister on proxy2 and note proxy --> mediator
			//			assertEquals(mainApp.exampleView.view_lbl2.text, "5");
			//test if main app has been set by notification from PrepViewCommand
			assertNotNull(toshiroApplicationFacadeTestMediator.app);
			//test if notification from proxy has been sent
			//			assertTrue(toshiroApplicationFacadeTestMediator.exProxyOnRegister);
			// receive note from mediator on register
			assertEquals(0, testCommand.notRegisteredNoteCounter);
			assertEquals(1, testCommand.noteFromMediator);
			
			//test dynamically loaded config
			xml = constructXMLFromEmbed(PureMVCDynamicSimpleStartupXMLClass);
			mainApp.facade.getContext().loadDynamicConfig(xml);
			
			var dynamicTestCommand:DynamicTestCommand = mainApp.facade.getContext().getObject("dynamicTestCommand") as DynamicTestCommand;
			var dynamicExampleViewMediator:DynamicExampleViewMediator = mainApp.facade.getContext().getObject("dynamicExampleViewMediator") as
				DynamicExampleViewMediator;
			
			mainApp.dynamicModule = mainApp.facade.getContext().getObject("dynamicModule") as DynamicModule;
			assertNotNull(mainApp.dynamicModule); //todo optional and lazy injection
			mainApp.facade.sendNotification("custom_startup");
			//tests notes from command to new and old commands
			assertEquals(2, dynamicTestCommand.noteFromCmd);
			assertEquals(2, testCommand.testNoteFromCommand);
			//tests note new cmd -> old cmd prototype -> new mediator
			assertEquals(1, dynamicExampleViewMediator.runsCount);
			//tests dynamic mediator on register
			assertEquals("set", dynamicExampleViewMediator.example_view.dynamic_view_lbl.text);
			//tests notes between dynamic and old mediators
			assertEquals(1, toshiroApplicationFacadeTestMediator.noteFromDynMed);
			assertEquals(1, exampleViewMediator.noteFromDynMed);
			//notes dynamic mediator -> new and old command
			assertEquals(2, testCommand.noteFromMediator);
			assertEquals(1, dynamicTestCommand.noteFromMediator);
			// notes proxies -> mediators
			//			assertEquals(3, exampleViewMediator.notesFromProxies);
			//			assertEquals(1, dynamicExampleViewMediator.notesFromProxies);
			//notes proxies -> commands
			assertEquals(0, testCommand.notRegisteredNoteCounter);
			assertEquals(1, testCommand.noteFromProxies);
			assertEquals(1, dynamicTestCommand.noteFromProxies);
			
			//tests if not overrided
			assertTrue(mainApp.facade.hasCommand("model"));
			assertTrue(mainApp.facade.hasCommand("view"));
			assertTrue(mainApp.facade.hasCommand("test"));
			//test if postprocessor registers proxies
			assertTrue(mainApp.facade.hasProxy(ExampleProxy.NAME));
			assertTrue(mainApp.facade.hasProxy(ExampleProxy2.NAME));
			//test if postprocessor registers mediators
			assertTrue(mainApp.facade.hasMediator(ToshiroApplicationFacadeTestMediator.NAME));
			assertTrue(mainApp.facade.hasMediator(ExampleViewMediator.NAME));
			assertTrue(mainApp.facade.hasCommand("dynamic_model"));
			assertTrue(mainApp.facade.hasCommand("dynamic_view"));
			assertTrue(mainApp.facade.hasProxy(DynamicExampleProxy.NAME));
			assertTrue(mainApp.facade.hasProxy(DynamicExampleProxy2.NAME));
			assertTrue(mainApp.facade.hasMediator(DynamicExampleViewMediator.NAME));
			//test injection ref to main config
			assertNotNull((mainApp.facade.getContext().getObject("dynamicExampleView") as DynamicExampleView).exampleView);
		}
		
		public function testMetatagContextInjection():void
		{
			var xml:XML = constructXMLFromEmbed(ContextInjectionXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithMetatags:SimpleBeanWithContextInjection = context.getObject("objectOne") as SimpleBeanWithContextInjection;
			assertNotNull(simpleBeanWithMetatags);
			assertEquals(simpleBeanWithMetatags.beforeConfigureMethodInvocation, true);
			assertEquals(simpleBeanWithMetatags.afterConfigureMethodInvocation, true);
			assertNotNull(simpleBeanWithMetatags.dependencyItem);
			assertNotNull(simpleBeanWithMetatags.dependencyItem2);
			assertEquals(context, simpleBeanWithMetatags.context);
			
			var simpleBeanWithMetatags2:SimpleBeanWithContextInjection = context.getObject("objectTwo") as SimpleBeanWithContextInjection;
			assertNotNull(simpleBeanWithMetatags2);
			assertEquals(simpleBeanWithMetatags2.beforeConfigureMethodInvocation, true);
			assertEquals(simpleBeanWithMetatags2.afterConfigureMethodInvocation, true);
			assertNotNull(simpleBeanWithMetatags2.dependencyItem);
			assertNotNull(simpleBeanWithMetatags2.dependencyItem2);
			assertEquals(context, simpleBeanWithMetatags2.context);
		}
		
		public function testMetatagsBeforeAndAfterSetter():void
		{
			var xml:XML = constructXMLFromEmbed(MetatagsSetterXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithMetatags:SimpleBeanWithMetatags = context.getObject("objectWithTags") as SimpleBeanWithMetatags;
			assertNotNull(simpleBeanWithMetatags);
			assertTrue(simpleBeanWithMetatags.beforeConfigureMethodInvocation);
			assertTrue(simpleBeanWithMetatags.afterConfigureMethodInvocation);
			assertTrue(simpleBeanWithMetatags.secondAfterMethod);
			assertTrue(simpleBeanWithMetatags.secondBeforeMethod);
			
			var simpleBeanWithoutMetatags:SimpleBeanWithoutMetatags = context.getObject("objectWithoutTags") as SimpleBeanWithoutMetatags;
			assertNotNull(simpleBeanWithoutMetatags);
			assertFalse(simpleBeanWithoutMetatags.beforeConfigureMethodInvocation);
			assertFalse(simpleBeanWithoutMetatags.afterConfigureMethodInvocation);
		
		}
		
		public function testMetatagsBeforeAndAfterConstructor():void
		{
			var xml:XML = constructXMLFromEmbed(MetatagsConstructorXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var constructorWithMetatags:BeanWithConstructorAndMetatags = context.getObject("objectOne") as BeanWithConstructorAndMetatags;
			assertNotNull(constructorWithMetatags);
			assertTrue(constructorWithMetatags.beforeConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.afterConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.secondAfterMethod);
			assertTrue(constructorWithMetatags.secondBeforeMethod);
			
			constructorWithMetatags = context.getObject("objectTwo") as BeanWithConstructorAndMetatags;
			assertNotNull(constructorWithMetatags);
			assertTrue(constructorWithMetatags.beforeConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.afterConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.secondAfterMethod);
			assertTrue(constructorWithMetatags.secondBeforeMethod);
		
		}
		
		public function testMetatagsBeforeAndAfterConstructorWithoutProperties():void
		{
			var xml:XML = constructXMLFromEmbed(MetatagsConstructorWithoutPropertiesXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var constructorWithMetatags:BeanWithConstructorAndMetatagsWithoutProperties = context.getObject("objectOne") as
				BeanWithConstructorAndMetatagsWithoutProperties;
			assertNotNull(constructorWithMetatags);
			assertTrue(constructorWithMetatags.beforeConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.afterConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.secondAfterMethod);
			assertTrue(constructorWithMetatags.secondBeforeMethod);
			
			constructorWithMetatags = context.getObject("objectTwo") as BeanWithConstructorAndMetatagsWithoutProperties;
			assertNotNull(constructorWithMetatags);
			assertTrue(constructorWithMetatags.beforeConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.afterConfigureMethodInvocation);
			assertTrue(constructorWithMetatags.secondAfterMethod);
			assertTrue(constructorWithMetatags.secondBeforeMethod);
		
		}
		
		// checks if tags are extendable
		public function testBeforeAndAfterMetatagsExtended():void
		{
			var xml:XML = constructXMLFromEmbed(ExtendingMetatagsXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithMetatags:SimpleBeanWithMetatagsExtended = context.getObject("objectWithTags") as SimpleBeanWithMetatagsExtended;
			assertNotNull(simpleBeanWithMetatags);
			assertEquals(simpleBeanWithMetatags.beforeConfigureMethodInvocation, true);
			assertEquals(simpleBeanWithMetatags.afterConfigureMethodInvocation, true);
			assertEquals(simpleBeanWithMetatags.secondBeforeMethod, true);
			assertEquals(simpleBeanWithMetatags.secondAfterMethod, true);
		
		}
		
		public function testMetatagRequiredNotSatisfied():void
		{
			
			var xml:XML = constructXMLFromEmbed(RequiredMetatagXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			context.initialize();
			try
			{
				context.getObject('objectWithoutRequired');
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_REQUIRED_METATAG_NOT_SATISFIED, error.errorCode);
		
		}
		
		public function testMetatagRequiredOnPublicPropNotSatisfied():void
		{
			
			var xml:XML = constructXMLFromEmbed(RequiredMetatagPublicPropXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			
			try
			{
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_REQUIRED_METATAG_NOT_SATISFIED, error.errorCode);
		
		}
		
		public function testMetatagRequiredSatisfied():void
		{
			
			var xml:XML = constructXMLFromEmbed(RequiredMetatag2XMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var simpleBeanWithRequired:SimpleBeanWithMetatags = context.getObject("objectWithRequired") as SimpleBeanWithMetatags;
			assertNotNull(simpleBeanWithRequired);
			assertNotNull(simpleBeanWithRequired.dependencyItem);
			assertNotNull(simpleBeanWithRequired.dependencyItem2);
			//assertNotNull(simpleBeanWithRequired.dependencyField3);
			//assertEquals(simpleBeanWithRequired.dependencyField3, context.getObject('object4'));
			//assertEquals(simpleBeanWithRequired.simpleReqProp, 'testSimpleReqProp');
		}
		
		public function testDependencyNotExistingSetter():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithoutDependencyXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			
			try
			{
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_OBJECT_NOT_FOUND, error.errorCode);
		}
		
		public function testDependencyNotExistingContructor():void
		{
			var xml:XML = constructXMLFromEmbed(ConstructorWithoutDependencyXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			
			try
			{
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_OBJECT_NOT_FOUND, error.errorCode);
		}
		
		public function testLifecycle():void
		{
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
			
			assertEquals(-99999, object3.someChild.someNumber);
			assertEquals(1111, object3.someChild.someInt);
			assertEquals("some123String", object3.someChild.someString);
			assertEquals(true, object3.someChild.someBoolean);
			
			assertEquals(-99999, object2.someChild.someNumber);
			assertEquals(1111, object2.someChild.someInt);
			assertEquals("some123String", object2.someChild.someString);
			assertEquals(true, object2.someChild.someBoolean);
			
			var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ParentOfSimpleDependencyObject"));
			var object4:ParentOfSimpleDependencyObject = context.getTypedObject("object4", clazz4);
			assertNotNull(object4);
			
			var object5:ParentOfSimpleDependencyObject = context.getTypedObject("object5", clazz4);
			assertNotNull(object5);
			
			//	both child classes should be equals (singletons)
			assertEquals(object4.nextChild, object5.nextChild);
			
			//	both child classes should be not equals (prototypes)
			if(object2.someChild == object3.someChild)
			{
				fail("prototype objects should be different but are the same");
			}
			//assertNotEquals(object2.someChild, object3.someChild);
		}
		
		public function testInstantiateBeanByID():void
		{
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
		
		public function testBeanNotFound():void
		{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var exceptionThrown:Boolean = false;
			try
			{
				var bean:* = context.getObject("nonExistentObject");
			}
			catch(err:ContainerError)
			{
				exceptionThrown = true;
			}
			assertNull(bean);
			assertTrue(exceptionThrown);
		}
		
		public function testSetterNumber():void
		{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:SimpleBean = context.getObject("objectOne");
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);
			
			var beanTwo:SimpleBean = context.getObject("objectTwo");
			assertNotNull(beanTwo);
			assertTrue(beanTwo is SimpleBean);
			
			assertEquals(1111, beanOne.uintItem);
			assertEquals(-99999, beanOne.intItem);
			assertEquals(9999.00001, beanOne.numberItem);
			
			assertEquals(0, beanTwo.uintItem);
			assertEquals(999, beanTwo.intItem);
			assertEquals(-123456.99987, beanTwo.numberItem);
		
		}
		
		public function testConstructorDate():void
		{
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
		
		public function testSetterDate():void
		{
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
		
		public function testSetterString():void
		{
			var xml:XML = constructXMLFromEmbed(SimpleObjectSetterClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);
			assertEquals("some123String", beanOne.stringItem);
		}
		
		public function testSetterWithClass():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithClassXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			
			assertNotNull(beanOne);
			assertTrue(beanOne is SimpleBean);
			assertNotNull(beanOne.clazzItem);
			assertEquals(beanOne.clazzItem, Class(getDefinitionByName("flash.display.Sprite")));
		
		}
		
		public function testSetterWithBoolean():void
		{
			
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
		
		public function testSetterWithImplicitNull():void
		{
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
		
		public function testInstantiateByConstructorSimpleType():void
		{
			
			var xml:XML = constructXMLFromEmbed(ConstructorSimpleTypeXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var beanOne:* = context.getObject("objectOne");
			
			assertNotNull(beanOne);
			assertTrue(beanOne is BeanWithConstructor);
			
			//	checking values set by setters
			assertEquals("false", beanOne.someAdditionalString);
			
			//	checking values set by constructor
			assertEquals(-99999, beanOne.someNumber);
			assertEquals(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean"), beanOne.someClass);
			assertEquals(1111, beanOne.someInt);
			assertEquals("some123String", beanOne.someString);
			assertEquals(true, beanOne.someBoolean);
			assertEquals(7, beanOne.someStatic);
			
			//	checking for nulled argument
			var beanTwo:* = context.getObject("objectTwo");
			
			assertNotNull(beanTwo);
			assertTrue(beanTwo is BeanWithConstructor);
			
			//	checking values set by setters
			assertEquals("enedueRikeFake", beanTwo.someAdditionalString);
			
			//	checking values set by constructor
			assertEquals(-99999.6, beanTwo.someNumber);
			assertEquals(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean"), beanTwo.someClass);
			assertEquals(1111, beanTwo.someInt);
			assertEquals(null, beanTwo.someString);
			assertEquals(false, beanTwo.someBoolean);
			assertEquals(7, beanTwo.someStatic);
		
		}
		
		/*
		
		
		public function testResolvingInnerObjectsReferences():void{
			fail("unimplemented");
		}
		
		public function testInstantiateByConstructorNewClass():void{
			fail("unimplemented");
		}
		
		public function testConstructorWithMap():void{
			fail("unimplemented");
		}
		
		public function testSetterWithMap():void{
			fail("unimplemented");
		}
		
		public function testMultipartXml():void{
			fail("unimplemented");
		}
		
		public function testScopePrototype():void{
			fail("unimplemented");
		}
		*/
		public function testContainsBean():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			assertTrue(context.containsBean("objectOne"));
			assertFalse(context.containsBean("notExistingBeanName"));
		
		}
		
		public function testContainsInitializedBean():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			assertTrue(context.ableToInitBean("objectOne"));
			assertFalse(context.ableToInitBean("notExistingBeanName"));
		
		}
		
		public function testGetTypedBean():void
		{
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
			
			try
			{
				var bean:* = context.getTypedObject("objectOne", invalidClazz);
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNull(bean);
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_INVALID_OBJECT_TYPE, error.errorCode);
		
		}
		
		public function testGetType():void
		{
			var xml:XML = constructXMLFromEmbed(SetterWithNullXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			context.initialize();
			
			var clazz:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.SimpleBean"));
			assertEquals(clazz, context.getType("objectOne"));
		}
		
		public function testIsSingleton():void
		{
			var xml:XML = constructXMLFromEmbed(IsSingletonXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			context.initialize();
			
			assertTrue(context.isSingleton("object2"));
			assertTrue(context.isSingleton("object3"));
			assertTrue(context.isSingleton("object4"));
			assertTrue(context.isSingleton("object5"));
			assertFalse(context.isSingleton("objectChild"));
		
			//	todo: throw exception if bean not found
		}
		
		public function testCyclicDependencyFromConstructorToSetter():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorToSetterXMLClass);
			
			var error:ContainerError = null;
			var typeToBeLinkedByFlash:CyclicConstructorAndSetter;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromConstructorToSetterComplex():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorToSetterComplexXMLClass);
			
			var error:ContainerError = null;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSetterToConstructor():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSetterToConstructorXMLClass);
			
			var error:ContainerError = null;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSetterToConstructorComplex():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSetterToConstructorComplexXMLClass);
			
			var error:ContainerError = null;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSetters():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSettersXMLClass);
			
			var typeToBeLinkedByFlashCompiler:CyclicSetter;
			
			var error:ContainerError = null;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromSettersComplex():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromSettersComplexXMLClass);
			
			var error:ContainerError = null;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromConstructors():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorsXMLClass);
			
			var error:ContainerError = null;
			
			var typeToBeLinkedByFlashCompiler:CyclicConstructor;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testCyclicDependencyFromConstructorsComplex():void
		{
			var xml:XML = constructXMLFromEmbed(CyclicDependencyFromConstructorsComplexXMLClass);
			
			var error:ContainerError = null;
			
			try
			{
				var context:XMLBeanFactory = new XMLBeanFactory(xml);
				context.initialize();
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_CYCLIC_DEPENDENCY, error.errorCode);
		}
		
		public function testSimpleDependencySetter():void
		{
			
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
			
			assertEquals(-99999, beanTwo.someChild.someNumber);
			assertEquals(1111, beanTwo.someChild.someInt);
			assertEquals("some123String", beanTwo.someChild.someString);
			assertEquals(true, beanTwo.someChild.someBoolean);
			
			var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ParentOfSimpleDependencyObject"));
			var bean4:* = context.getTypedObject("object4", clazz4);
			assertTrue(bean4 is ParentOfSimpleDependencyObject);
		}
		
		public function testSimpleDependencyConstructor():void
		{
			
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
			
			assertEquals(1111, bean1.uintItem);
			assertEquals(-99999, bean1.intItem);
			assertEquals(9999.00001, bean1.numberItem);
			
			//	parent class
			var clazz4:Class = Class(getDefinitionByName("org.toshiroioc.test.beans.ObjectWithConstructorDependency"));
			var bean4:ObjectWithConstructorDependency = context.getTypedObject("object4", clazz4);
			assertTrue(bean4 is ObjectWithConstructorDependency);
			
			assertNotNull(bean4.simpleChild);
			assertTrue(bean4.simpleChild is SimpleBean);
			assertEquals(bean1, bean4.simpleChild);
		}
		
		public function testStaticReferenceInConstructor():void
		{
			var xml:XML = constructXMLFromEmbed(ConstructorWithStaticReferenceXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			
			var error:ContainerError;
			
			//	testing the exception thrown during initialization,
			//		if static variable of some bean doesn't exist
			context.initialize();
			try
			{
				context.getObject('objectTwo');
			}
			catch(err:ContainerError)
			{
				error = err;
				trace(error);
			}
			
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_INVALID_STATIC_REFERENCE, error.errorCode);
			
			// testing initialization and reference to static variable, if correct
			
			var beanWithCorrectStaticReference:BeanWithConstructor = context.getTypedObject("objectOne", org.toshiroioc.
				test.beans.BeanWithConstructor);
			assertNotNull(beanWithCorrectStaticReference);
			assertEquals(7, beanWithCorrectStaticReference.someStatic);
		}
		
		public function testStaticReferenceInSetter():void
		{
			
			var xml:XML = constructXMLFromEmbed(SetterWithStaticReferenceXMLClass);
			var context:XMLBeanFactory = new XMLBeanFactory(xml);
			var error:ContainerError;
			context.initialize();
			try
			{
				context.getObject('objectTwo');
			}
			catch(err:ContainerError)
			{
				error = err;
			}
			assertNotNull(error);
			assertEquals(ContainerError.ERROR_INVALID_STATIC_REFERENCE, error.errorCode);
			
			var bean:SimpleBean = context.getTypedObject("objectOne", SimpleBean);
			assertNotNull(bean);
			assertEquals(7, bean.staticRefItem)
		}
		
		public static function suite():TestSuite
		{
			
			var testTS:TestSuite = new TestSuite();
			var tests2:Vector.<Test> = getTestsArr();
			for each(var value:Test in tests2)
			{
				testTS.addTest(value);
			}
			
			return testTS;
		}
		
		public static function getTestsArr():Vector.<Test>
		{
			var retval:Vector.<Test> = new Vector.<Test>();
			
			//retval.push(new XMLBeanFactoryTestCase("testDynamicObjectSetter"));
			
			retval.push(new XMLBeanFactoryTestCase("testWrongAttributeNames"));
			retval.push(new XMLBeanFactoryTestCase("testWrongProperties"));
			retval.push(new XMLBeanFactoryTestCase("testObjectSetter"));
			retval.push(new XMLBeanFactoryTestCase("testRecursiveArrays"));
			retval.push(new XMLBeanFactoryTestCase("testConcatConfigs"));
			retval.push(new XMLBeanFactoryTestCase("testMultipleConfigs"));
			retval.push(new XMLBeanFactoryTestCase('testPureMVCRegistrationAwareMediator'));
			retval.push(new XMLBeanFactoryTestCase('testI18NMetatagWrongSetterType'));
			retval.push(new XMLBeanFactoryTestCase("testBeanIdMetatag"));
			retval.push(new XMLBeanFactoryTestCase('testRestrictedBeansId'));
			retval.push(new XMLBeanFactoryTestCase('testI18NMetatag'));
			retval.push(new XMLBeanFactoryTestCase("testRefBeanNonExistent"));
			retval.push(new XMLBeanFactoryTestCase("testRefBeanCircular"));
			retval.push(new XMLBeanFactoryTestCase("testRefBean"));
			retval.push(new XMLBeanFactoryTestCase("testRefFromArrayInnerBean"));
			retval.push(new XMLBeanFactoryTestCase("testRefFromInnerBean"));
			retval.push(new XMLBeanFactoryTestCase("testRefArrayInnerBeanCircular"));
			retval.push(new XMLBeanFactoryTestCase("testErrorsInMap"));
			retval.push(new XMLBeanFactoryTestCase("testMap"));
			retval.push(new XMLBeanFactoryTestCase("testMetatagsBeforeAndAfterConstructorWithoutProperties"));
			retval.push(new XMLBeanFactoryTestCase("testConstructorArrayInjection"));
			retval.push(new XMLBeanFactoryTestCase("testErrorsInArray"));
			retval.push(new XMLBeanFactoryTestCase("testSetterArrayInjection"));
			retval.push(new XMLBeanFactoryTestCase("testRefOptional"));
			retval.push(new XMLBeanFactoryTestCase("testRefOptionalWrongArgument"));
			retval.push(new XMLBeanFactoryTestCase("testMetatagContextInjection"));
			retval.push(new XMLBeanFactoryTestCase("testIDNotUnique"));
			//retval.push(new XMLBeanFactoryTestCase("testPureMVCMacroCommandStartup"));
			retval.push(new XMLBeanFactoryTestCase("testPureMVCSimpleCommandStartup"));
			retval.push(new XMLBeanFactoryTestCase("testDynamicContextLoadFailed"));
			retval.push(new XMLBeanFactoryTestCase("testDynamicContextSimpleLoad"));
			retval.push(new XMLBeanFactoryTestCase("testDynamicContextRefToBeanFrom2ndConfig"));
			retval.push(new XMLBeanFactoryTestCase("testDynamicContextRefToBeanFrom1stConfig"));
			retval.push(new XMLBeanFactoryTestCase("testNotInitializePrototypeBeans"));
			retval.push(new XMLBeanFactoryTestCase("testGetObjectsByClass"));
			retval.push(new XMLBeanFactoryTestCase("testClassPostprocessor"));
			retval.push(new XMLBeanFactoryTestCase("testMetatagsBeforeAndAfterSetter"));
			retval.push(new XMLBeanFactoryTestCase("testMetatagsBeforeAndAfterConstructor"));
			retval.push(new XMLBeanFactoryTestCase("testMetatagRequiredNotSatisfied"));
			retval.push(new XMLBeanFactoryTestCase("testMetatagRequiredSatisfied"));
			retval.push(new XMLBeanFactoryTestCase("testBeforeAndAfterMetatagsExtended"));
			retval.push(new XMLBeanFactoryTestCase("testDependencyNotExistingSetter"));
			retval.push(new XMLBeanFactoryTestCase("testDependencyNotExistingContructor"));
			retval.push(new XMLBeanFactoryTestCase("testInstantiateBeanByID"));
			retval.push(new XMLBeanFactoryTestCase("testSetterNumber"));
			retval.push(new XMLBeanFactoryTestCase("testSetterString"));
			retval.push(new XMLBeanFactoryTestCase("testSetterDate"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithBoolean"));
			retval.push(new XMLBeanFactoryTestCase("testXMLMissing"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithClass"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithImplicitNull"));
			retval.push(new XMLBeanFactoryTestCase("testInstantiateByConstructorSimpleType"));
			retval.push(new XMLBeanFactoryTestCase("testConstructorDate"));
			retval.push(new XMLBeanFactoryTestCase("testSimpleDependencySetter"));
			retval.push(new XMLBeanFactoryTestCase("testSimpleDependencyConstructor"));
			retval.push(new XMLBeanFactoryTestCase("testBeanNotFound"));
			retval.push(new XMLBeanFactoryTestCase("testContainsBean"));
			retval.push(new XMLBeanFactoryTestCase("testContainsInitializedBean"));
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
			retval.push(new XMLBeanFactoryTestCase("testRefBeanOptional"));
			retval.push(new XMLBeanFactoryTestCase("testInstantiateByConstructorNewClass"));
			retval.push(new XMLBeanFactoryTestCase("testConstructorWithArray"));
			retval.push(new XMLBeanFactoryTestCase("testConstructorWithMap"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithArray"));
			retval.push(new XMLBeanFactoryTestCase("testSetterWithMap"));
			retval.push(new XMLBeanFactoryTestCase("testScopePrototype"));
			retval.push(new XMLBeanFactoryTestCase("testResolvingInnerObjectsReferences"));
			*/
			
			return retval;
		}
	
	}
}
