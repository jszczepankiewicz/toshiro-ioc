package org.toshiroioc.test.puremvc.command
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.toshiroioc.plugins.puremvc.multicore.ToshiroIocMacroCommand;

	public class DynamicMacroOnLoadCommand extends ToshiroIocMacroCommand
	{
		override protected function initializeMacroCommand():void
        {
        	addSubCommand( DynamicPrepModelCommand );
            addSubCommand( DynamicPrepViewCommand  );
        }
	}
}