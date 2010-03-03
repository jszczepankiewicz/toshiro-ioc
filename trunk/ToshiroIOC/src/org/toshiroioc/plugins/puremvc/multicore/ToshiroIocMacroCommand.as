package org.toshiroioc.plugins.puremvc.multicore
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.INotifier;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.observer.Notifier;
	import org.toshiroioc.core.XMLBeanFactory;
	

	public class ToshiroIocMacroCommand extends Notifier implements ICommand, INotifier
	{
		private var subCommands:Array;
		
		public function ToshiroIocMacroCommand()
		{
			subCommands = new Array();
			initializeMacroCommand();			
		}

		protected function initializeMacroCommand():void
		{
		}
		
		protected function addSubCommand( commandClassRef:Class ): void
		{
			subCommands.push(commandClassRef);
		}
		
		public function execute(notification:INotification):void{
			var facade:ToshiroApplicationFacade = notification.getBody() as ToshiroApplicationFacade;
			var context:XMLBeanFactory = facade.getContext();
			while ( subCommands.length > 0) {
				var command : ICommand = context.getObjectByClass(subCommands.shift()as Class);
				command.initializeNotifier( multitonKey );
				var note:INotification = new Notification(null, facade.getMainApp());
				command.execute( note );
			}
	}
		
	}
}