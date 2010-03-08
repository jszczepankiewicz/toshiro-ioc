package org.toshiroioc.test.puremvc.mediator
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy;
	import org.toshiroioc.test.puremvc.model.ExampleProxy;
	import org.toshiroioc.test.puremvc.model.ExampleProxy2;
	import org.toshiroioc.test.puremvc.view.ExampleView;


	public class ExampleViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ExampleViewMediator';
		
		private var examplePrx:ExampleProxy; 
		public var noteFromDynMed : Number =0;
		public var notesFromProxies : Number = 0;
		public static const EX_VIEW_MEDIATOR_ON_REGISTER:String = "exViewMediatorOnRegister";
		
		public function ExampleViewMediator( viewComponent:ExampleView)
		{
			super( NAME, viewComponent );
		}
		
		override public function onRegister():void
		{
			sendNotification(EX_VIEW_MEDIATOR_ON_REGISTER, true);
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
						ToshiroApplicationFacadeTest.BUTTON_CLICK,
						ExampleProxy2.EX_PROXY2_ON_REGISTER,
						ExampleProxy.EXAMPLE_PROXY_ON_REGISTER,
						DynamicExampleViewMediator.DYNAMIC_MEDIATOR_ON_REGISTER, 
						DynamicExampleProxy.DYNAMIC_EXAMPLE_PROXY_ON_REGISTER
					];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ToshiroApplicationFacadeTest.BUTTON_CLICK:
					example_view.view_lbl.text = String( note.getBody() ).toUpperCase();
				    break;
				case ExampleProxy2.EX_PROXY2_ON_REGISTER:
					example_view.view_lbl2.text = String( note.getBody() ).toUpperCase();
					notesFromProxies++;
				    break;
				case ExampleProxy.EXAMPLE_PROXY_ON_REGISTER:
					example_view.view_grid.dataProvider = note.getBody() as ArrayCollection;
					notesFromProxies++;
				    break;
				case DynamicExampleProxy.DYNAMIC_EXAMPLE_PROXY_ON_REGISTER:
					notesFromProxies++;
				    break;
				default:
					noteFromDynMed++;
				    break;
			}
		}
		
		protected function get example_view():ExampleView 
		{
			return viewComponent as ExampleView;
		}
	}
}