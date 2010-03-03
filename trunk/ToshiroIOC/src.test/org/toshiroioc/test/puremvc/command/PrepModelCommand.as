package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.toshiroioc.test.puremvc.model.ExampleProxy;

	public class PrepModelCommand extends SimpleCommand implements ICommand
	{
		private var exProxy:ExampleProxy;
		
		override public function execute( note:INotification ):void
		{
			// Instantiate :: proxies
			
			facade.registerProxy( exProxy );
		}
		
		
		
		[Required]
		public function set exampleProxy(proxy:ExampleProxy):void{
			this.exProxy = proxy;
		}
		public function get exampleProxy():ExampleProxy{
			return this.exProxy;
		}
	}
}