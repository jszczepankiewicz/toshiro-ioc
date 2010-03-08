package org.toshiroioc.plugins.puremvc.multicore
{
	import __AS3__.vec.Vector;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.toshiroioc.core.IClassPostprocessor;
	

	public class PureMVCClassPostprocessor implements IClassPostprocessor
	{
		private var classVector: Vector.<Class>;
		private var facade:ToshiroApplicationFacade;
		private var mediators:Vector.<IMediator> = new Vector.<IMediator>();
		private var proxies:Vector.<IProxy> = new Vector.<IProxy>();
		private var mappings:Array = new Array();
		
		public function PureMVCClassPostprocessor(facade:ToshiroApplicationFacade):void{
			classVector = new Vector.<Class>();
			classVector.push(SetterMap, IProxy, IMediator);
			this.facade = facade;
		}
		public function listClassInterests():Vector.<Class>
		{
			return classVector;
			
		}
		
		public function postprocessObject(object:*):*
		{
			/* if(object is SetterMap){			
					var mappings:Array = (object as SetterMap).mappings;
					for each (var commandMap:CommandMap in mappings){
						facade.registerCommand(commandMap.notification, commandMap.command)
					}
			} */
			
			//take copy of SetterMap mappings to register commands and clear it, 
			//	to not duplicate registration in case of dynamic load another SetterMap,
			//	and to not clear SetterMap mappings used in ToshiroIocController
			if (object is SetterMap){
				mappings = (object as SetterMap).mappings.concat();
			}
			else if (object is IProxy){	
					proxies.push(object as IProxy);
			}
			else if (object is IMediator){
					mediators.push(object as IMediator);				
			}
		}
	
		public function onContextLoaded():void{
			
			var commandMap : CommandMap;
			while(commandMap = mappings.shift()){
				facade.registerCommand(commandMap.notification, commandMap.command);
			}
			
			var mediator : IMediator;
			while(mediator = mediators.shift()){
				facade.registerMediator(mediator);
			}
			
			var proxy : IProxy;
			while(proxy = proxies.shift()){
				facade.registerProxy(proxy);
			}
			

		}
		
	}
}