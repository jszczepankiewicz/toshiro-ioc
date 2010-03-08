package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.toshiroioc.test.puremvc.mediator.DynamicExampleViewMediator;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy2;
	
	public class DynamicTestCommand extends SimpleCommand implements ICommand
	{
		public var noteFromCmd : Number = 0;
		public var noteFromMediator : Number = 0;
		public var noteFromProxies : Number = 0;

		override public function execute(note:INotification):void
		{
			switch(note.getName()){
				case DynamicPrepModelCommand.RUN_DYNAMIC_TEST_COMMAND:
					noteFromCmd++;
					break;
				case DynamicPrepViewCommand.RUN_COMMANDS:
					noteFromCmd++;
					break;
				case DynamicExampleViewMediator.DYNAMIC_MEDIATOR_ON_REGISTER:
					noteFromMediator++;
					break;
				case DynamicExampleProxy2.DYNAMIC_PROXY_2_ON_REGISTER:
					noteFromProxies++;
					break;
				default:
					noteFromProxies++;

			}
			
		}

	}
}