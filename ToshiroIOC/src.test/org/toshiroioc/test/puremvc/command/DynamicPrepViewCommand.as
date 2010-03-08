package org.toshiroioc.test.puremvc.command 
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class DynamicPrepViewCommand extends SimpleCommand implements ICommand
	{
		public static const RUN_COMMANDS:String = "runCommands"
		
		override public function execute( note:INotification ):void
		{
			sendNotification(RUN_COMMANDS);
		}
	}
}