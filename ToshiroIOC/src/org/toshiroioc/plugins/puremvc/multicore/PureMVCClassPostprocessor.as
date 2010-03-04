package org.toshiroioc.plugins.puremvc.multicore
{
	import __AS3__.vec.Vector;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.toshiroioc.core.IClassPostprocessor;
	

	public class PureMVCClassPostprocessor implements IClassPostprocessor
	{
		private var classVector: Vector.<Class>;
		private var facade:ToshiroApplicationFacade;
		private var mediators:Vector.<IMediator> = new Vector.<IMediator>();
		private var proxies:Vector.<IProxy> = new Vector.<IProxy>();
		
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
			if(object is SetterMap){			
					var mappings:Array = (object as SetterMap).mappings;
					for each (var commandMap:CommandMap in mappings){
						facade.registerCommand(commandMap.notification, commandMap.command)
					}
			}
			else if (object is IProxy){	
					proxies.push(object as IProxy);
			}
			else if (object is IMediator){
					mediators.push(object as IMediator);				
			}
		}
	
		public function onContextLoaded():void{
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