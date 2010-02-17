package org.toshiroioc.test.beans{
	
	public class CyclicSetter{
		
		private var childField:CyclicSetter;
		
		
		
		public function set someChild(childBean:CyclicSetter):void{
			childField = childBean;
		}
		
		public function get someChild():CyclicSetter{
			return childField;
		}
		
		
	}
}