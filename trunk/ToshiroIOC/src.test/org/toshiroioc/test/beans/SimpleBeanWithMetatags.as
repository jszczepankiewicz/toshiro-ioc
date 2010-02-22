package org.toshiroioc.test.beans{

	
	public class SimpleBeanWithMetatags{
				
		private var dependencyField:SimpleBean;
		
		private var numberField:Number;
		public var beforeConfigureMethodInvocation:Boolean;
		public var afterConfigureMethodInvocation:Boolean;
		
		[BeforeConfigure]
		public function methodBeforeConfigure():void{
			if (!numberField)
				beforeConfigureMethodInvocation = true;
		}
		
		[AfterConfigure]
		public function methodAfterConfigure():void{
			if (numberField)
				afterConfigureMethodInvocation = true;
		}
		
		[Required]
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