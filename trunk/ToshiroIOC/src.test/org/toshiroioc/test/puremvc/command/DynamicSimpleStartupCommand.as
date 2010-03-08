package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class DynamicSimpleStartupCommand extends SimpleCommand implements ICommand
	{
		public static const SIMPLE_STARTUP_LOAD:String = 'simpleStartupLoad';
		
		override public function execute(note:INotification):void
        {
        	sendNotification(SIMPLE_STARTUP_LOAD, note.getBody());
        }
	}
}