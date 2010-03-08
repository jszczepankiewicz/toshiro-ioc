package org.toshiroioc.test.puremvc.mediator
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy;
	import org.toshiroioc.test.puremvc.model.ExampleProxy;
	import org.toshiroioc.test.puremvc.model.ExampleProxy2;
	import org.toshiroioc.test.puremvc.view.DynamicExampleView;

	public class DynamicExampleViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'DynamicExampleViewMediator';
		public static const DYNAMIC_MEDIATOR_ON_REGISTER:String = "dynamicMediatorOnRegister"
		public var runsCount:Number = 0;
		public var notesFromProxies : Number = 0;
		
		public function DynamicExampleViewMediator( viewComponent:DynamicExampleView)
		{
			super( NAME, viewComponent );
		}
		
		override public function onRegister():void
		
		{
			example_view.dynamic_view_lbl.text = "set";
			sendNotification(DYNAMIC_MEDIATOR_ON_REGISTER);
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
					"runDynMed",
						ExampleProxy2.EX_PROXY2_ON_REGISTER,
						ExampleProxy.EXAMPLE_PROXY_ON_REGISTER,
						"dynEx", DynamicExampleProxy.DYNAMIC_EXAMPLE_PROXY_ON_REGISTER
					];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case "runDynMed":
					runsCount++;
					break;
				case DynamicExampleProxy.DYNAMIC_EXAMPLE_PROXY_ON_REGISTER:
					notesFromProxies++;
				    break;
				case ExampleProxy2.EX_PROXY2_ON_REGISTER:
					notesFromProxies++;
					break;
				case ExampleProxy.EXAMPLE_PROXY_ON_REGISTER:
					notesFromProxies++;
					break;
				default: notesFromProxies++;
			}
		}
		
		public function get example_view():DynamicExampleView 
		{
			return viewComponent as DynamicExampleView;
		}
		
	}
}