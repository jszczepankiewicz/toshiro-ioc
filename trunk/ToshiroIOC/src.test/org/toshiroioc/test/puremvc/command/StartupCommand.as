package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class StartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
        {
            addSubCommand( PrepModelCommand );
            addSubCommand( PrepViewCommand  );
        }
	}
}