package org.toshiroioc.plugins.puremvc.multicore
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.toshiroioc.core.XMLBeanFactory;


	public class ToshiroApplicationFacade extends Facade implements IFacade, IEventDispatcher
	{
		protected var dispatcher:EventDispatcher;	
		protected var context:XMLBeanFactory;
		protected var mainApp:DisplayObject;
		
		 public static function getInstance( key:String, app:DisplayObject=null) : ToshiroApplicationFacade 
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ] = new ToshiroApplicationFacade( key, app);
            return instanceMap[ key ] as ToshiroApplicationFacade;
        }
		
		public function ToshiroApplicationFacade(key:String, app:DisplayObject=null)
		{
			super(key);
			controller = null;
			dispatcher = new EventDispatcher(this);
			this.mainApp = app;
			
		}
        
        public function initializeContext(contextXML:XML):void{
			context = new XMLBeanFactory(contextXML);
			initializeIocFacade();
			context.registerObjectPostprocessor(new PureMVCClassPostprocessor(this));
			context.addEventListener(Event.COMPLETE, onContextLoad);
			context.initialize(); 
		}
		
		protected function onContextLoad(ev:Event):void {

			context.removeEventListener(Event.COMPLETE, onContextLoad);
			(controller as IToshiroIocController).executeStartupCommand(this);
			dispatchEvent(new Event(Event.COMPLETE));
	    }
	    
	    override protected function initializeFacade():void {

	    }     
	
	     protected function initializeIocFacade():void {
	     	initializeModel();
	     	initializeController();
	    	initializeView();
	    } 
	    
	    		
		 override protected function initializeController():void {
      		controller = ToshiroIocController.getInstance(multitonKey, context);
   		 }
   		 
   		 override public function registerCommand( notificationName:String, commandClassRef:Class ):void 
		{
			controller.registerCommand( notificationName, commandClassRef );
		}
		
		public function getContext():XMLBeanFactory{
			return context;
		}
		
		public function getMainApp():DisplayObject{
			return mainApp;
		}
	    
	    // IEventDispatcher implementation -- start
	     public function addEventListener(
	      p_type:String, p_listener:Function, p_useCapture:Boolean = false, p_priority:int = 0,
	      p_useWeakReference:Boolean = false):void
	    {
	      dispatcher.addEventListener(p_type, p_listener, p_useCapture, p_priority);
	    }
	
	    public function dispatchEvent(p_event:Event):Boolean{
	      return dispatcher.dispatchEvent(p_event);
	    }
	
	    public function hasEventListener(p_type:String):Boolean{
	      return dispatcher.hasEventListener(p_type);
	    }
	
	    public function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean = false):void {
	      dispatcher.removeEventListener(p_type, p_listener, p_useCapture);
	    }
	
	    public function willTrigger(p_type:String):Boolean {
	      return dispatcher.willTrigger(p_type);
	    }
	    
	}
}