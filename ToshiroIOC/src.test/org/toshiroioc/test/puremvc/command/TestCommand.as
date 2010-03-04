package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class TestCommand extends SimpleCommand implements ICommand
	{
		public var executed:Number;
		public var testNoteFromOtherCommand:Boolean;
		
		override public function execute(note:INotification):void
		{
			trace(note.getName());
			switch(note.getName()){
				case("test"):
					executed=note.getBody() as Number;
					break;
				case("test2"):
					testNoteFromOtherCommand=true;
					break;	
			}
			
			
		}

	}
}