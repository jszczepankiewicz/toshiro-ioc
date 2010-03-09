package org.toshiroioc.test.beans{
	
	public class ConstructorWithArrays{
		private var someAdditionalStringField:String;
		private var simpleArrayField:Array;
		private var objectsArrayField:Array;
		private var someNumberField:Number;

		public function ConstructorWithArrays(someNumber:Number, array1:Array, array2:Array){
				
				simpleArrayField = array1;
				objectsArrayField = array2;
				someNumberField = someNumber;
		}
		public function get simpleArrayItem():Array{
			return simpleArrayField;
		}
		
		public function get objectsArrayItem():Array{
			return objectsArrayField;
		}
		
		public function get someNumber():Number{
			return someNumberField;
		}
		
		public function set someAdditionalString(field:String):void{
			this.someAdditionalStringField = field;
		}
		
		public function get someAdditionalString():String{
			return someAdditionalStringField;
		}
	}
}