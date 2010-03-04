package org.toshiroioc.test.puremvc.mediator
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.toshiroioc.test.puremvc.view.DynamicExampleView;

	public class DynamicExampleViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'DynamicExampleViewMediator';
		public var runsCount:Number = 0;
		
		public function DynamicExampleViewMediator( viewComponent:DynamicExampleView)
		{
			super( NAME, viewComponent );
		}
		
		override public function onRegister():void
		{
			sendNotification("dynMedOnReg");
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
					"runDynMed"
					];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case "runDynMed":
					runsCount++;
					break;
					
			}
		}
		
		protected function get example_view():DynamicExampleView 
		{
			return viewComponent as DynamicExampleView;
		}
		
	}
}