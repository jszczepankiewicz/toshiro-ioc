package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class DynamicPrepModelCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute( note:INotification ):void
		{
			sendNotification("runDynTestCmd");
		}
		
		
		
	}
}