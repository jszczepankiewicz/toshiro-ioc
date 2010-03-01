package org.toshiroioc.plugins.puremvc.multicore
{
	import __AS3__.vec.Vector;
	
	public class SetterMap
	{
		private var mappingsField:Array = new Array();
		private var classes:Vector.<Class> = new Vector.<Class>;
		private var notificationNames:Vector.<String> = new Vector.<String>; 
		 
		/* public function getKey(tuple:Array):*{
			return tuple[0];
		}
		
		public function getValue(tuple:Array):*{
			return tuple[1];
		} */
		 
		 
		public function set mappings(value: Array):void{
			mappingsField = value;
			getClasses();
			getNotificationNames();
		}
		
		public function get mappings():Array{
			return mappingsField;
		}  
		
		private function getClasses():void{
			for each(var commandMap:CommandMap in mappingsField){
				classes.push(commandMap.command);
			}
		}
		
		private function getNames():void{
			for each(var commandMap:CommandMap in mappingsField){
				notificationNames.push(commandMap.notification);
			}
		}
		
		public function getCommandClasses():Vector.<Class>{
			return classes;
		}
		
		public function getNotificationNames():Vector.<String>{
			return notificationNames;
		}
		
	}
}