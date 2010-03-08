package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.toshiroioc.test.puremvc.mediator.DynamicExampleViewMediator;
	import org.toshiroioc.test.puremvc.mediator.ExampleViewMediator;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy2;
	
	public class TestCommand extends SimpleCommand implements ICommand
	{
		public var executed:Number;
		public var testNoteFromCommand:Number = 0;
		public var noteFromMediator:Number=0;
		public var notRegisteredNoteCounter:Number=0;
		public var noteFromProxies : Number = 0;
		
		override public function execute(note:INotification):void
		{
			trace(note.getName());
			switch(note.getName()){
				case "test":
					executed=note.getBody() as Number;
					break;
				case PrepModelCommand.RUN_TEST_COMMAND:
					testNoteFromCommand++;
					break;	
				case DynamicPrepViewCommand.RUN_COMMANDS:
					testNoteFromCommand++;
					break;	
				case ExampleViewMediator.EX_VIEW_MEDIATOR_ON_REGISTER:
					noteFromMediator++
					break;
				case DynamicExampleViewMediator.DYNAMIC_MEDIATOR_ON_REGISTER:
					noteFromMediator++
					break;
				case DynamicExampleProxy2.DYNAMIC_PROXY_2_ON_REGISTER:
					noteFromProxies++;
					break;
				default:
					notRegisteredNoteCounter++
			}
			
			
		}

	}
}