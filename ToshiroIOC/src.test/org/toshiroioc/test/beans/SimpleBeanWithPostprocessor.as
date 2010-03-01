package org.toshiroioc.test.beans{
	

	
	public class SimpleBeanWithPostprocessor{
		public var testField:Boolean;
		public  var testField2:Boolean;
		private var propertyToSet:Number;
		public var commonField:Number=0;
		
		public function SimpleBeanWithPostprocessor(value:Number=0):void{
			this.propertyToSet = value;
		}
		
		public function set property(value:Number):void{
			this.propertyToSet = value
		}
		
		public function get property():Number{
			return this.propertyToSet;
		}
	}
}