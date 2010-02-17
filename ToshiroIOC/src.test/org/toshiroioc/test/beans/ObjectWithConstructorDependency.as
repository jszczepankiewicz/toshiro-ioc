package org.toshiroioc.test.beans
{
	public class ObjectWithConstructorDependency
	{
		private var simpleChildField:SimpleBean;
		
		
		public function ObjectWithConstructorDependency(child:SimpleBean){
			simpleChildField = child;
		}
		
		public function get simpleChild():SimpleBean{
			return simpleChildField;
		}
	}
}