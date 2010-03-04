package org.toshiroioc.test.puremvc.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class ToshiroApplicationFacadeTestMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ToshiroApplicationFacadeTestMediator';
		
		public var test:Boolean;
		public var exProxyOnRegister:Boolean;
		
		public function ToshiroApplicationFacadeTestMediator( viewComponent:ToshiroApplicationFacadeTest=null)
		{
			super( NAME, viewComponent );
		}		
		
		override public function onRegister():void
		{
			
		}
		
		public function get app():ToshiroApplicationFacadeTest
		{
			return viewComponent as ToshiroApplicationFacadeTest;
		}
		
		public function set app(value:ToshiroApplicationFacadeTest):void
		{
			viewComponent = value;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ToshiroApplicationFacadeTest.EX_PROXY_ON_REGISTER,
						ToshiroApplicationFacadeTest.ADD_MAIN_APP
					];
		}
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ToshiroApplicationFacadeTest.EX_PROXY_ON_REGISTER:
					exProxyOnRegister = true;
				    break;
				case ToshiroApplicationFacadeTest.ADD_MAIN_APP:
					this.app = note.getBody() as ToshiroApplicationFacadeTest;
					sendNotification( ToshiroApplicationFacadeTest.BUTTON_CLICK, "You clicked the button" );
				    break;
			}
		}
	}
}