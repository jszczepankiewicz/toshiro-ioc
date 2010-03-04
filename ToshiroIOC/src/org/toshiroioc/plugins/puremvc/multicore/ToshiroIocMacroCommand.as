package org.toshiroioc.plugins.puremvc.multicore
{
	import __AS3__.vec.Vector;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.INotifier;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.observer.Notifier;
	import org.toshiroioc.core.XMLBeanFactory;
	

	public class ToshiroIocMacroCommand extends Notifier implements ICommand, INotifier
	{
		
		private var subCommands:Array;
		
		private var contextField:XMLBeanFactory;
		
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
			var subCommand:Class;
			var commands:Vector.<Object>;
			while ( subCommand = subCommands.shift()) {
				commands = context.getObjectsByClass(subCommand);
				if(commands.length==1){
				
					var command : ICommand = commands[0] as ICommand;
					command.initializeNotifier( multitonKey );
					command.execute( notification );
				}
				else if(commands.length==0){
					throw new ArgumentError("Command of a type:["+subCommand+"] not defined in xml");
				}
				else {
					throw new ArgumentError("Multiple commands of a type:["+subCommand+"]");
				}
			}
			
	}
	
		[ToshiroIOCFactory]
		public function set context(value:XMLBeanFactory):void{
			contextField = value;
		}
		
		public function get context():XMLBeanFactory{
			return contextField;
		}
		
	}
}