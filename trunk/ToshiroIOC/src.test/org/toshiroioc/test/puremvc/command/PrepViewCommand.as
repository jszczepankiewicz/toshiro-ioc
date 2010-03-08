package org.toshiroioc.test.puremvc.command 
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class PrepViewCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note:INotification ):void
		{
			switch(note.getName()){
				case (DynamicPrepViewCommand.RUN_COMMANDS):
					sendNotification("runDynMed");
					break;
				default:
					sendNotification(ToshiroApplicationFacadeTest.ADD_MAIN_APP, note.getBody());
			}
			
		}
	}
}