package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class DynamicTestCommand extends SimpleCommand implements ICommand
	{
		public var noteFromCmd : Number = 0;

		override public function execute(note:INotification):void
		{
			switch(note.getName()){
				case "runDynTestCmd":
					noteFromCmd++;
					break;
				case "runCmds":
					noteFromCmd++;
					break;
			}
			
		}

	}
}