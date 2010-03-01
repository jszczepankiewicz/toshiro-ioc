package org.toshiroioc.test.puremvc.mediator
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.toshiroioc.test.puremvc.model.ExampleProxy;
	import org.toshiroioc.test.puremvc.view.ExampleView;

	public class ExampleViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ExampleViewMediator';
		
		public var examplePrx:ExampleProxy; //private na public
		
		public function ExampleViewMediator( viewComponent:Object = null)
		{
			super( NAME, viewComponent );
		}
		
		override public function onRegister():void
		{
			examplePrx = facade.retrieveProxy( ExampleProxy.NAME ) as ExampleProxy;
			
			//example_view.view_grid.dataProvider = examplePrx.my_arr;
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
						ToshiroApplicationFacadeTest.BUTTON_CLICK
					];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ToshiroApplicationFacadeTest.BUTTON_CLICK:
					example_view.view_lbl.text = String( note.getBody() ).toUpperCase();
				    break;
			}
		}
		
		public function get example_view():ExampleView //protected na public
		{
			return viewComponent as ExampleView;
		}
	}
}