package org.toshiroioc.test.beans{
	
	public class SimpleBean{
		private var booleanField:Boolean;
		private var stringField:String;
		private var numberField:Number;
		private var uintField:uint;
		private var intField:int;
		private var dateField:Date;
		private var clazzField:Class;
		private var staticRefField:uint;		
		
		
		public function set booleanItem(value:Boolean):void{
			booleanField = value;	
		}
		
		public function get booleanItem():Boolean{
			return booleanField;
		}
		
		public function set stringItem(value:String):void{
			stringField = value;
		}
		
		public function get stringItem():String{
			return stringField;
		}
		
		public function set numberItem(value:Number):void{
			numberField = value;
		}
		
		public function get numberItem():Number{
			return numberField;
		}
				
		public function set uintItem(value:uint):void{
			uintField = value;
		}
		
		public function get uintItem():uint{
			return uintField;
		}
		
		public function set intItem(value:int):void{
			intField = value;
		}
		
		public function get intItem():int{
			return intField;
		}
		
		public function set dateItem(value:Date):void{
			dateField = value;
		}	
		
		public function get dateItem():Date{
			return dateField;
		}
		
		public function set clazzItem(value:Class):void{
			clazzField = value;	
		}
		
		public function get clazzItem():Class{
			return clazzField;
		}	
		
		public function set staticRefItem(value:uint):void{
			staticRefField = value;	
		}
		
		public function get staticRefItem():uint{
			return staticRefField;
		}
	}
}