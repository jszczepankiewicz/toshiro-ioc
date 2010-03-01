package org.toshiroioc.plugins.puremvc.multicore
{
	import org.puremvc.as3.multicore.core.Controller;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.IController;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.toshiroioc.core.XMLBeanFactory;
	
	public class ToshiroIocController extends Controller
	{
		private var context:XMLBeanFactory;
		
		public static function getInstance( key:String, context:XMLBeanFactory ) : IController
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
 			trace(note.getName());
	      	var commandClassRef:Class = context.getObject(note.getName());
	
	      	if (commandClassRef != null) {
	        	var commandInstance:ICommand = new commandClassRef();
	    	    commandInstance.execute(note);
	        	return;
		    }

      	} 
		
		
	}
}