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
		
		private var examplePrx:ExampleProxy; 
		
		public function ExampleViewMediator( viewComponent:Object = null)
		{
			super( NAME, viewComponent );
		}
		
		override public function onRegister():void
		{
			example_view.view_grid.dataProvider = exampleProxy.my_arr;
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
		
		protected function get example_view():ExampleView 
		{
			return viewComponent as ExampleView;
		}
		
		public function get exampleProxy():ExampleProxy 
		{
			return examplePrx as ExampleProxy;
		}
		
		public function set exampleProxy(value:ExampleProxy):void 
		{
			examplePrx = value;
		}
	}
}