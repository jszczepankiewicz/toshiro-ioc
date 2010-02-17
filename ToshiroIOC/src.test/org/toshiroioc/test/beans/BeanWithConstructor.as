package org.toshiroioc.test.beans
{
	public class BeanWithConstructor{
		
		private var someNumberField:Number;
		private var someIntField:int;
		private var someUIntField:uint;
		private var someBooleanField:Boolean;
		private var someStringField:String;
		private var someStaticField:uint;
		private var someAdditionalStringField:String;
		
		public function set someAdditionalString(field:String):void{
			this.someAdditionalStringField = field;
		}
		
		public function get someAdditionalString():String{
			return someAdditionalStringField;
		}
		
		public function BeanWithConstructor(
			someNumber:Number,
			someInt:int,
			someString:String,
			someBoolean:Boolean,
			someStatic:uint=0){
				
				
				someNumberField = someNumber;
				someIntField = someInt;
				someStringField = someString;
				someBooleanField = someBoolean;
				someStaticField = someStatic;
		}
		
		public function get someUInt():uint{
			return someUIntField;
		}
		
		public function get someBoolean():Boolean{
			return someBooleanField;
		}
		
		public function get someString():String{
			return someStringField;
		}
		
		public function get someNumber():Number{
			return someNumberField;
		}
		
		public function get someInt():int{
			return someIntField;
		}

		public function get someStatic():uint{
			return someStaticField;
		}

	}
}