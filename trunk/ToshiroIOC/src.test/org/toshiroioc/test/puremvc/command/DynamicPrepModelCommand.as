package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class DynamicPrepModelCommand extends SimpleCommand implements ICommand
	{
		public static const RUN_DYNAMIC_TEST_COMMAND:String = "runDynamicTestCommand"
		
		override public function execute( note:INotification ):void
		{
			sendNotification(RUN_DYNAMIC_TEST_COMMAND);
		}
	}
}