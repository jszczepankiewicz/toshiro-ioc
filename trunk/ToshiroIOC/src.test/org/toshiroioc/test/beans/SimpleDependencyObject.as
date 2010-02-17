package org.toshiroioc.test.beans{
	
	public class SimpleDependencyObject{
		
		private var childField:BeanWithConstructor;
		
		private var someStringField:String;
		
		public function set someChild(childBean:BeanWithConstructor):void{
			childField = childBean;
		}
		
		public function get someChild():BeanWithConstructor{
			return childField;
		}
		
		public function get someString():String{
			return someStringField;
		}
		
		public function set someString(value:String):void{
			someStringField = value;			
		}
	}
}