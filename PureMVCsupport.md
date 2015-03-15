### Introduction ###

With Toshiro-IOC it is possible to configure and start pureMVC framework basing solely on xml configuration and dependency injection. PureMVC multicore version is supported. All pureMVC specific Toshiro-IOC classes are kept in `org.toshiroioc.plugins.puremvc.multicore` package.

### Configuration ###
Example configuration xml:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<objects>
	
	<!-- Commands	-->
	<object id="pureMVCStartupCommand" class="org.toshiroioc.test.puremvc.command.MacroStartupCommand" lifecycle="prototype"/>
	<object id="prepModelCommand" class="org.toshiroioc.test.puremvc.command.PrepModelCommand" lifecycle="prototype"/>
	<object id="testCommand" class="org.toshiroioc.test.puremvc.command.TestCommand" />
	<object id="prepViewCommand" class="org.toshiroioc.test.puremvc.command.PrepViewCommand" lifecycle="prototype"/>
	
	<!-- Commands - notifications mappings -->	
	<object id="beanWithSetterMap" class="org.toshiroioc.plugins.puremvc.multicore.SetterMap">
		<property name="mappings">
			<array>
				<entry>
					<object class="org.toshiroioc.plugins.puremvc.multicore.CommandMap">
						<property name="notification" value="model"/>
						<property name="command" class="org.toshiroioc.test.puremvc.command.PrepModelCommand"/>
					</object>
				</entry>
				<entry>
					<object class="org.toshiroioc.plugins.puremvc.multicore.CommandMap">
						<property name="notification" value="view"/>
						<property name="command" class="org.toshiroioc.test.puremvc.command.PrepViewCommand"/>
					</object>
				</entry>
				<entry>
					<object class="org.toshiroioc.plugins.puremvc.multicore.CommandMap">
						<property name="notification" value="test"/>
						<property name="command" class="org.toshiroioc.test.puremvc.command.TestCommand"/>
					</object>
				</entry>
				<entry>
					<object class="org.toshiroioc.plugins.puremvc.multicore.CommandMap">
						<property name="notification" const="org.toshiroioc.test.puremvc.command.PrepModelCommand.RUN_TEST_COMMAND"/>
						<property name="command" class="org.toshiroioc.test.puremvc.command.TestCommand"/>
					</object>
				</entry>
				<entry>
					<object class="org.toshiroioc.plugins.puremvc.multicore.CommandMap">
						<property name="notification" const="org.toshiroioc.test.puremvc.mediator.ExampleViewMediator.EX_VIEW_MEDIATOR_ON_REGISTER"/>
						<property name="command" class="org.toshiroioc.test.puremvc.command.TestCommand"/>
					</object>
				</entry>
			</array>		
		</property>
	</object>

	<!-- Proxies -->
	<object id="exampleProxy" class="org.toshiroioc.test.puremvc.model.ExampleProxy"/>
	<object id="exampleProxy2" class="org.toshiroioc.test.puremvc.model.ExampleProxy2"/>
	
	<!-- Views -->
	
	<object id="exampleView" class="org.toshiroioc.test.puremvc.view.ExampleView"/>
	
	<!-- Mediators-->
	
	<object id="toshiroApplicationFacadeTestMediator" class="org.toshiroioc.test.puremvc.mediator.ToshiroApplicationFacadeTestMediator"/>
	<object id="exampleViewMediator" class="org.toshiroioc.test.puremvc.mediator.ExampleViewMediator">
		<constructor-arg ref="exampleView"/>
	</object>
</objects>
```
Let's start from the beginning:
  * The "pureMVCStartupCommand" bean has to be provided, with exactly such a name. It is the only bean name reserved for Toshiro-IOC. It is a startup command, which is going to be called by the Toshiro-IOC framework after context initialization. It has to be of a `SimpleCommand` or `ToshiroIocMacroCommand` type.
  * "pureMVCStartupCommand" 's `execute(note:INotification):void` method, called at framework startup, receives reference to main application view in note's body. So, if you wish to register mediator for main application, which is outside of the container, then you have to respond to notification sent from startup command with passed reference to main application view in note's body.
  * If you opt for commands to be instantiated every time when reffered to, as in standard use case of pureMVC, add `lifecycle="prototype"` to the command bean definition.
  * The "beanWithSetterMap" is kind of container, where mappings between notifications and commands are kept. It has to be of `SetterMap` type. Mappings are specified by array of `CommandMap` objects and kept in mappings property of the SetterMap. Each CommandMap corresponds to a single mapping and specifies two properties. One of them is "notification" with a notification name provided directly by string value or by reference to public static const by a `const` attribute. Second property is "command" with fully qualified class name provided by a `class` attribute.
  * Then rest of the pureMVC players is being specified, with references between them as needed.
  * Views has to be written in ActionScript, in order to be managed by the container.

### Main application view ###
Example application view:
```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute"
	creationComplete="onCreationComplete()">
	
	<mx:Script>
		<![CDATA[

			[Embed(source="applicationContext.xml", mimeType="application/octet-stream")]
			private var contextXMLClass:Class;
			
			import mx.core.ByteArrayAsset;
			import org.toshiroioc.plugins.puremvc.multicore.ToshiroApplicationFacade;
			
			public static const NAME:String = "ToshiroApplicationFacadeTestUserInterface"
			
			public static const ADD_MAIN_APP:String = 'add_main_app';
			
			private var facade:ToshiroApplicationFacade;
			private var contextXML:XML;
			
			public function onCreationComplete():void{
				contextXML = constructXMLFromEmbed(contextXMLClass);
				facade = ToshiroApplicationFacade.getInstance(NAME, this);
				facade.addEventListener(Event.COMPLETE, startupApp);
				facade.initializeContext(contextXML);
			}
			
			private function startupApp(ev:Event):void {
        		facade.removeEventListener(Event.COMPLETE, startupApp);
        		//startup logic here
   			}
      		
      		public function constructXMLFromEmbed(clazz:Class):XML{		
				var byteArrayAsset:ByteArrayAsset = ByteArrayAsset(new clazz());			
				return new XML(byteArrayAsset.toString());
			}
		]]>
	</mx:Script>
</mx:Application>>
```
  * In `onCreationComplete` method:
    1. an XML object is created from embedded `applicationContext.xml` file
    1. an ToshiroApplicationFacade instance is received, if not yet created, that's the moment, when pureMVC framework starts
    1. registration for an `Event.COMPLETE`, which is going to be dispatched after context initialization
    1. call initializeContext on facade with xml configuration file as an argument
  * In `startupApp` method:
    1. Unregister from `Event.COMPLETE`, unless you wish to call the method every time additional configuration file is dynamically loaded
    1. Add startup logic, if there exists any beyond startup command