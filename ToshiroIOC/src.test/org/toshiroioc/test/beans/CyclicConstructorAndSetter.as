package org.toshiroioc.test.beans{
	
	public class CyclicConstructorAndSetter{
		
		private var childField:CyclicConstructorAndSetter;
		
		
		public function CyclicConstructor(childBean:CyclicConstructorAndSetter = null):void{
			childField = childBean;
		}
		
		public function set someChild(childBean:CyclicConstructorAndSetter):void{
			childField = childBean;
		}
		
		public function get someChild():CyclicConstructorAndSetter{
			return childField;
		}
		
	}
}