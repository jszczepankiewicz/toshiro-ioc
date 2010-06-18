package org.toshiroioc.test.beans{
	
	public class ComplexDependencyObjectInnerParentBeans{
		
		private var childField:ParentOfSimpleDependencyObject;
		private var childField2:ParentOfSimpleDependencyObject;
		
		private var someStringField:String;
		
		public function set someChild(childBean:ParentOfSimpleDependencyObject):void{
			childField = childBean;
		}
		
		public function get someChild():ParentOfSimpleDependencyObject{
			return childField;
		}
		
		public function set someChild2(childBean:ParentOfSimpleDependencyObject):void{
			childField2 = childBean;
		}
		
		public function get someChild2():ParentOfSimpleDependencyObject{
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