package org.toshiroioc.plugins.puremvc.multicore
{
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
		
		 public static function getInstance( key:String) : ToshiroApplicationFacade 
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ] = new ToshiroApplicationFacade( key);
            return instanceMap[ key ] as ToshiroApplicationFacade;
        }
		
		public function ToshiroApplicationFacade(key:String)
		{
			super(key);
			
			dispatcher = new EventDispatcher(this);
			//initializeIocFacade();
		}
        
        public function initializeContext(contextXML:XML):void{
			context = new XMLBeanFactory(contextXML);
			context.registerObjectPostprocessor(new PureMVCObjectPostprocessor(this));
			context.addEventListener(Event.COMPLETE, onContextLoad);
			context.initialize(); //gdy napotka zarejestrowany obiekt, inicjalizuje go i przekazuje postprocessorowi
		}
		
		protected function onContextLoad(ev:Event):void {
			//initializeIocFacade();
			context.removeEventListener(Event.COMPLETE, onContextLoad);
			
			dispatchEvent(new Event(Event.COMPLETE));
	    }
	    
	     /* override public function sendNotification(notificationName:String, body:Object=null, type:String=null ):void{
	    	super.sendNotification(notificationName, body, type);
	    }  */
	    

	      /* override protected function initializeFacade():void {

	    }     */
	
	     protected function initializeIocFacade():void {
	     	initializeModel();
	     	initializeController();
	    	initializeView();
	    } 
	    
	    		
		 override protected function initializeController():void {
      		controller = ToshiroIocController.getInstance(multitonKey, context);
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