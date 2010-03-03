package org.toshiroioc.plugins.puremvc.multicore
{
	import org.toshiroioc.core.IClassPostprocessor;
	import org.toshiroioc.plugins.puremvc.multicore.SetterMap;
	

	public class PureMVCClassPostprocessor implements IClassPostprocessor
	{
		private var classVector: Vector.<Class>;
		private var facade:ToshiroApplicationFacade;
		
		public function PureMVCClassPostprocessor(facade:ToshiroApplicationFacade):void{
			classVector = new Vector.<Class>();
			classVector.push(SetterMap);
			this.facade = facade;
		}
		public function listClassInterests():Vector.<Class>
		{
			return classVector;
			
		}
		
		public function postprocessObject(object:*):*
		{
			var mappings:Array = (object as SetterMap).mappings;
			for each (var commandMap:CommandMap in mappings){
				facade.registerCommand(commandMap.notification, commandMap.command)
			}
		}
		
	}
}