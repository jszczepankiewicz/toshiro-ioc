package org.toshiroioc.test.beans
{
	import __AS3__.vec.Vector;
	
	public class ConstructorMap
	{
		private var vectorField:Vector.<Array>;
		 
		public function ConstructorMap(value:Vector.<Array>):void{
			vectorField = vector;
		}
		
		public function get vector():Vector.<Array>{
			return vectorField;
		}  
	}
}