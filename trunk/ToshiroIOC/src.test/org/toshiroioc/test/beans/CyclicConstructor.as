package org.toshiroioc.test.beans{
	
	public class CyclicConstructor{
		
		private var childField:CyclicConstructor;
		
		
		public function CyclicConstructor(childBean:CyclicConstructor){
			childField = childBean;
		}
		
		public function get someChild():CyclicConstructor{
			return childField;
		}
		
	}
}