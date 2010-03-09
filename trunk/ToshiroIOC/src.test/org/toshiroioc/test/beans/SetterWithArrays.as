package org.toshiroioc.test.beans{
	
	public class SetterWithArrays{
		private var booleanField:Boolean;
		private var simpleArrayField:Array;
		private var objectsArrayField:Array;

		public function set booleanItem(value:Boolean):void{
			booleanField = value;	
		}
		
		public function get booleanItem():Boolean{
			return booleanField;
		}
		
		public function set simpleArrayItem(value:Array):void{
			simpleArrayField = value;
		}
		
		public function get simpleArrayItem():Array{
			return simpleArrayField;
		}
		
		public function set objectsArrayItem(value:Array):void{
			objectsArrayField = value;
		}
		
		public function get objectsArrayItem():Array{
			return objectsArrayField;
		}
	}
}