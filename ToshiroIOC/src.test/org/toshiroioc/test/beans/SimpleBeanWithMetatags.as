package org.toshiroioc.test.beans{

	
	public class SimpleBeanWithMetatags{
				
		[Required]
		private var dependencyField:SimpleBean;
		[Required]
		protected var dependencyField2:SimpleBean;
		[Required]
		public var dependencyField3:SimpleBean;
		
		private var numberField:Number;
		public var beforeConfigureMethodInvocation:Boolean;
		public var afterConfigureMethodInvocation:Boolean;
		
		[BeforeConfigure]
		public function methodBeforeConfigure():void{
			beforeConfigureMethodInvocation = true;
		}
		
		[AfterConfigure]
		public function methodAfterConfigure():void{
			afterConfigureMethodInvocation = true;
		}
		
		
		public function set dependencyItem(value:SimpleBean):void{
			dependencyField = value;	
		}
		
		public function get dependencyItem():SimpleBean{
			return dependencyField;
		} 
		
		public function set dependencyItem2(value:SimpleBean):void{
			dependencyField2 = value;	
		}
		
		public function get dependencyItem2():SimpleBean{
			return dependencyField2;
		} 
		
				public function set dependencyItem3(value:SimpleBean):void{
			dependencyField3 = value;	
		}
		
		public function get dependencyItem3():SimpleBean{
			return dependencyField3;
		} 
		
		public function set numberItem(value:Number):void{
			numberField = value;
		}
		
		public function get numberItem():Number{
			return numberField;
		}
		
	}
}