package org.toshiroioc.test.puremvc.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class ToshiroApplicationFacadeTestMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ToshiroApplicationFacadeTestMediator';
		
		public function ToshiroApplicationFacadeTestMediator( viewComponent:Object = null )
		{
			super( NAME, viewComponent );
		}		
		
		override public function onRegister():void
		{
			//app.addEventListener( ToshiroApplicationFacadeTest.HELLO_CLICK, handleHelloClick );
		}
		
		public function handleHelloClick( e:Event ):void
		{
			sendNotification( ToshiroApplicationFacadeTest.BUTTON_CLICK, "You clicked the button" );
		}
		
		protected function get app():ToshiroApplicationFacadeTest
		{
			return viewComponent as ToshiroApplicationFacadeTest;
		}
	}
}