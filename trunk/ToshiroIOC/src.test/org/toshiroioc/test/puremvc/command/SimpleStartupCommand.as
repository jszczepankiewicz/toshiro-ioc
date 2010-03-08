package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class SimpleStartupCommand extends SimpleCommand implements ICommand
	{
		public static const SIMPLE_STARTUP:String = 'simple_startup';
		
		override public function execute(note:INotification):void
        {
        	sendNotification(SIMPLE_STARTUP, note.getBody());
        }
	}
}