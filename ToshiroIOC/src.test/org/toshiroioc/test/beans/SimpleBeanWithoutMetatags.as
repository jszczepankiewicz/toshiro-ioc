package org.toshiroioc.test.beans{

	
	public class SimpleBeanWithoutMetatags{
				
		
		private var dependencyField:SimpleBean;
		
		private var numberField:Number;
		public var beforeConfigureMethodInvocation:Boolean;
		public var afterConfigureMethodInvocation:Boolean;
		
		public function methodBeforeConfigure():void{
			beforeConfigureMethodInvocation = true;
		}
		
		public function methodAfterConfigure():void{
			afterConfigureMethodInvocation = true;
		}
		
		public function set dependencyItem(value:SimpleBean):void{
			dependencyField = value;	
		}
		
		public function get dependencyItem():SimpleBean{
			return dependencyField;
		}
		
		public function set numberItem(value:Number):void{
			numberField = value;
		}
		
		public function get numberItem():Number{
			return numberField;
		}
		
	}
}