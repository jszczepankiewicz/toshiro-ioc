package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class TestCommand extends SimpleCommand implements ICommand
	{
		public var executed:Number;
		public var testNoteFromCommand:Number = 0;
		public var noteFromMediator:Number=0;
		public var notRegisteredNoteCounter:Number=0;
		
		override public function execute(note:INotification):void
		{
			trace(note.getName());
			switch(note.getName()){
				case "test":
					executed=note.getBody() as Number;
					break;
				case "test2":
					testNoteFromCommand++;
					break;	
				case "runCmds":
					testNoteFromCommand++;
					break;	
				case("ExViewMedOnReg"):
					noteFromMediator++
					break;
				default:
					notRegisteredNoteCounter++
			}
			
			
		}

	}
}