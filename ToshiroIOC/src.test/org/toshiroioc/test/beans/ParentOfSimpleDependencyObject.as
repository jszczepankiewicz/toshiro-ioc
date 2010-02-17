package org.toshiroioc.test.beans
{
	public class ParentOfSimpleDependencyObject{
		
		private var nextChildField:SimpleDependencyObject;
		
		public function set nextChild(child:SimpleDependencyObject):void{
			nextChildField = child;
		}
		
		public function get nextChild():SimpleDependencyObject{
			return nextChildField;
		}
	}
}