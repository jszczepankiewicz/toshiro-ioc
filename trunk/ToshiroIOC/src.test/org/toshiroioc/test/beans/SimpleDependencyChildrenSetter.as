package org.toshiroioc.test.beans{
	
	public class SimpleDependencyChildrenSetter{
		
		private var childField:SimpleDependencyObject;
		private var childField2:SimpleDependencyObject;
		
		private var someStringField:String;
		
		public function set someChild(childBean:SimpleDependencyObject):void{
			childField = childBean;
		}
		
		public function get someChild():SimpleDependencyObject{
			return childField;
		}
		
		public function set someChild2(childBean:SimpleDependencyObject):void{
			childField2 = childBean;
		}
		
		public function get someChild2():SimpleDependencyObject{
			return childField2;
		}
		
		public function get someString():String{
			return someStringField;
		}
		
		public function set someString(value:String):void{
			someStringField = value;			
		}
	}
}