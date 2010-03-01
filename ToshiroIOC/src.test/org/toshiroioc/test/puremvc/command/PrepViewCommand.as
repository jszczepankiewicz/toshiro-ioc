package org.toshiroioc.test.puremvc.command 
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.toshiroioc.test.puremvc.mediator.ExampleViewMediator;
	import org.toshiroioc.test.puremvc.mediator.ToshiroApplicationFacadeTestMediator;

	public class PrepViewCommand extends SimpleCommand implements ICommand
	{
		private var appMediator:ToshiroApplicationFacadeTestMediator;
		private var exViewMediator:ExampleViewMediator;
		
		override public function execute( note:INotification ):void
		{
			// Instantiate :: mediators
			var app:ToshiroApplicationFacadeTest = note.getBody() as ToshiroApplicationFacadeTest;
			
			appMediator.setViewComponent(app);
			app.addEventListener(ToshiroApplicationFacadeTest.HELLO_CLICK, appMediator.handleHelloClick);
			
			exViewMediator.setViewComponent(app.exampleView);
			exViewMediator.example_view.view_grid.dataProvider = exViewMediator.examplePrx.my_arr;
			
			facade.registerMediator( appMediator );
			facade.registerMediator( exViewMediator);
		}
		public function set toshiroApplicationFacadeTestMediator(appMediator:ToshiroApplicationFacadeTestMediator):void{
			this.appMediator = appMediator;
		}
		
		public function get toshiroApplicationFacadeTestMediator():ToshiroApplicationFacadeTestMediator{
			return this.appMediator;
		}
		
		public function set exampleViewMediator(exViewMediator:ExampleViewMediator):void{
			this.exViewMediator = exViewMediator;
		}
		
		public function get exampleViewMediator():ExampleViewMediator{
			return this.exViewMediator;
		}
	}
}