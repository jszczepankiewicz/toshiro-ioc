package org.toshiroioc.plugins.puremvc.multicore
{
	import __AS3__.vec.Vector;
	
	public class SetterMap
	{
		private var mappingsField:Array = new Array();
		 
		/* public function getKey(tuple:Array):*{
			return tuple[0];
		}
		
		public function getValue(tuple:Array):*{
			return tuple[1];
		} */
		 
		 
		public function set mappings(value: Array):void{
			mappingsField = value;
		}
		
		public function get mappings():Array{
			return mappingsField;
		}  
	}
}