package org.toshiroioc.plugins.puremvc.multicore
{
	import org.puremvc.as3.multicore.core.Controller;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.INotifier;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.toshiroioc.ContainerError;
	import org.toshiroioc.core.XMLBeanFactory;
	
	public class ToshiroIocController extends Controller implements IToshiroIocController
	{
		private var context:XMLBeanFactory;
		
		public static function getInstance( key:String, context:XMLBeanFactory ) : IToshiroIocController
		{
			if ( instanceMap[ key ] == null ) instanceMap[ key ] = new ToshiroIocController( key, context );
			return instanceMap[ key ];
		}
		
		public function ToshiroIocController(key:String, context:XMLBeanFactory)
		{
			super(key);
			this.context = context;
			 
		}
		
		
 		override public function executeCommand(note:INotification):void {
 			trace(note.getBody());
	      	var commandClassVector:Vector.<Class> = (context.getObjectByClass(SetterMap) as SetterMap)
	      		.getCommandsByNotification(note.getName());
			var command:ICommand;
			for each(var commandClass:Class in commandClassVector){
				command = context.getObjectByClass(commandClass) as ICommand;
		      	if (command) {
		      		command.initializeNotifier(multitonKey );
	    		    command.execute(note);
		    	}
		 	}
			
      	} 
      	
      	public function executeStartupCommand(facade:ToshiroApplicationFacade):void{
      		var command:ICommand = context.getObject("pureMVCStartupCommand") as ICommand;
      		var note:INotification;
      		if (command){
      			if (command is ToshiroIocMacroCommand || command is SimpleCommand){
      				if (command is ToshiroIocMacroCommand){
		      			note = new Notification(null, facade);
		      		}
		      		if (command is SimpleCommand){
		      			note = new Notification(null, facade.getMainApp());
		      		}
	      			command.initializeNotifier( multitonKey );
	      			command.execute(note); //if user registers startup command to his own note, startupCommand.execute() will be called at least twice
	      			return;
	      		}else{
	      			throw new ContainerError("Startup command has to be ToshiroIocMacroCommand or SimpleCommand type",0, ContainerError.ERROR_INVALID_OBJECT_TYPE);
	      		}
      		}
      		throw new ContainerError("PureMVC startup command not provided", 0 , ContainerError.ERROR_OBJECT_NOT_FOUND);
      	}
		
		
	}
}